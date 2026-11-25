//
//  UserViewModel.swift
//  Semana13_MetodosAPI_Async
//
//  Created by Jason Gomez.
//  Lógica y consumo de la API: GET, POST, PUT y DELETE con URLSession.dataTask.
//

import Foundation
import Combine // ObservableObject y @Published vienen de Combine

/// Registro de la última petición, para ver en pantalla qué respondió la API.
struct RequestLog: Equatable {
    let method: String
    let path: String
    let status: Int?
    let seconds: Double
    let note: String?
}

final class UserViewModel: ObservableObject {

    enum LoadState: Equatable {
        case loading
        case loaded
        case failed(String)
    }

    @Published var users: [User] = []
    @Published var searchText: String = ""
    @Published var state: LoadState = .loading
    @Published var isSending = false          // bloquea los botones mientras viaja una petición
    @Published var lastRequest: RequestLog?
    @Published var errorMessage: String?      // se muestra en una alerta

    private let baseURL = "https://jsonplaceholder.typicode.com/users"

    /// JSONPlaceholder responde a los POST pero no guarda nada: un PUT o DELETE a esos
    /// ids devuelve error 500. Los usuarios creados aquí se editan y borran solo en la app.
    private var localOnlyIDs: Set<Int> = []

    var filteredUsers: [User] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if query.isEmpty {
            return users
        }
        return users.filter { user in
            user.name.localizedStandardContains(query) || user.email.localizedStandardContains(query)
        }
    }

    // MARK: - GET: obtener todos los usuarios

    func fetchUsers() {
        guard let url = URL(string: baseURL) else { return }
        state = .loading

        send(URLRequest(url: url), path: "/users") { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                do {
                    users = try JSONDecoder().decode([User].self, from: data)
                    localOnlyIDs.removeAll()
                    state = .loaded
                } catch {
                    state = .failed("La respuesta de la API no tiene el formato esperado.")
                }
            case .failure(let apiError):
                state = .failed(apiError.message)
            }
        }
    }

    // MARK: - POST: crear un nuevo usuario

    func createUser(name: String, email: String) {
        guard let url = URL(string: baseURL), !isSending else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let newUser = User(id: 0, name: name, email: email) // el id lo pone el servidor
        do {
            request.httpBody = try JSONEncoder().encode(newUser)
        } catch {
            errorMessage = "No se pudo preparar el usuario para enviarlo."
            return
        }

        send(request, path: "/users") { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                guard let created = try? JSONDecoder().decode(User.self, from: data) else {
                    errorMessage = "La API respondió, pero no devolvió el usuario creado."
                    return
                }
                // La API siempre devuelve id 11. Si ya existe, se usa el siguiente libre
                // para que el List no tenga dos filas con el mismo id.
                let freeID = users.contains { $0.id == created.id }
                    ? (users.map(\.id).max() ?? 0) + 1
                    : created.id
                users.insert(User(id: freeID, name: created.name, email: created.email), at: 0)
                localOnlyIDs.insert(freeID)
                if freeID != created.id {
                    annotateLastRequest("La API asignó id \(created.id); en la app quedó con id \(freeID).")
                }
            case .failure(let apiError):
                errorMessage = apiError.message
            }
        }
    }

    // MARK: - PUT: actualizar un usuario existente

    func updateUser(user: User) {
        guard !isSending else { return }

        if localOnlyIDs.contains(user.id) {
            replaceLocally(user)
            lastRequest = RequestLog(method: "PUT", path: "/users/\(user.id)", status: nil, seconds: 0,
                                     note: "Solo en la app: JSONPlaceholder no guarda los usuarios nuevos.")
            return
        }

        guard let url = URL(string: "\(baseURL)/\(user.id)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try JSONEncoder().encode(user)
        } catch {
            errorMessage = "No se pudo preparar el usuario para enviarlo."
            return
        }

        send(request, path: "/users/\(user.id)") { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                replaceLocally(user)
            case .failure(let apiError):
                errorMessage = apiError.message
            }
        }
    }

    // MARK: - DELETE: eliminar un usuario por id

    func deleteUser(id: Int) {
        guard !isSending else { return }

        if localOnlyIDs.contains(id) {
            users.removeAll { $0.id == id }
            localOnlyIDs.remove(id)
            lastRequest = RequestLog(method: "DELETE", path: "/users/\(id)", status: nil, seconds: 0,
                                     note: "Solo en la app: el usuario no existía en el servidor.")
            return
        }

        guard let url = URL(string: "\(baseURL)/\(id)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        send(request, path: "/users/\(id)") { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                // El servidor responde 200 pero no borra de verdad (API de prueba)
                users.removeAll { $0.id == id }
            case .failure(let apiError):
                errorMessage = apiError.message
            }
        }
    }

    // MARK: - Apoyo

    private func replaceLocally(_ user: User) {
        if let index = users.firstIndex(where: { $0.id == user.id }) {
            users[index] = user
        }
    }

    private func annotateLastRequest(_ note: String) {
        guard let log = lastRequest else { return }
        lastRequest = RequestLog(method: log.method, path: log.path, status: log.status, seconds: log.seconds, note: note)
    }

    /// Ejecuta la petición con dataTask, revisa el código HTTP y vuelve al hilo principal
    /// antes de tocar las propiedades @Published.
    private func send(_ request: URLRequest, path: String, completion: @escaping (Result<Data, APIError>) -> Void) {
        let method = request.httpMethod ?? "GET"
        let start = Date()
        isSending = true

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            let status = (response as? HTTPURLResponse)?.statusCode
            let result = Self.check(data: data, status: status, error: error)
            let seconds = Date().timeIntervalSince(start)

            DispatchQueue.main.async {
                self?.isSending = false
                self?.lastRequest = RequestLog(method: method, path: path, status: status, seconds: seconds, note: nil)
                completion(result)
            }
        }.resume() // la tarea se crea suspendida: resume() la inicia
    }

    nonisolated private static func check(data: Data?, status: Int?, error: Error?) -> Result<Data, APIError> {
        if let error {
            return .failure(APIError(networkError: error))
        }
        if let status, !(200...299).contains(status) {
            return .failure(APIError(message: "La API respondió con el código \(status)."))
        }
        return .success(data ?? Data())
    }
}

/// Mensaje de error listo para mostrarse al usuario.
nonisolated struct APIError: Error {
    let message: String

    init(message: String) {
        self.message = message
    }

    init(networkError: Error) {
        switch (networkError as? URLError)?.code {
        case .notConnectedToInternet, .networkConnectionLost:
            message = "No hay conexión a internet. Revisa tu red e inténtalo otra vez."
        case .timedOut:
            message = "La API tardó demasiado en responder."
        default:
            message = "No se pudo conectar con la API."
        }
    }
}
