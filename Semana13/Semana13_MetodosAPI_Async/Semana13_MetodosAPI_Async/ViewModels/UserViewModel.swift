//
//  UserViewModel.swift
//  Semana13_MetodosAPI_Async
//
//  Created by Jason Gomez.
//  Misma lógica de la actividad 02, pero con async/await:
//  URLSession.shared.data(from:) para GET y data(for:) para POST, PUT y DELETE.
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

// @MainActor: todo el ViewModel corre en el hilo principal, así que después de cada
// await se puede actualizar `users` directamente, sin DispatchQueue ni MainActor.run.
@MainActor
final class UserViewModel: ObservableObject {

    enum LoadState: Equatable {
        case loading
        case loaded
        case failed(String)
    }

    @Published var users: [User] = []
    @Published var searchText: String = ""
    @Published var state: LoadState = .loading
    @Published var isSending = false
    @Published var lastRequest: RequestLog?
    @Published var errorMessage: String?

    private let baseURL = "https://jsonplaceholder.typicode.com/users"

    /// JSONPlaceholder no guarda los POST: un PUT o DELETE a esos ids devuelve 500.
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

    func fetchUsers() async {
        guard let url = URL(string: baseURL) else { return }
        if users.isEmpty { state = .loading }
        let start = Date()

        do {
            // La función se pausa aquí hasta que llega la respuesta, sin bloquear la pantalla
            let (data, response) = try await URLSession.shared.data(from: url)
            try record("GET", "/users", response, since: start)
            users = try JSONDecoder().decode([User].self, from: data)
            localOnlyIDs.removeAll()
            state = .loaded
        } catch is CancellationError {
            // Se canceló porque la vista desapareció o se repitió el pull-to-refresh
        } catch let error as APIError {
            state = .failed(error.message)
        } catch is DecodingError {
            state = .failed("La respuesta de la API no tiene el formato esperado.")
        } catch {
            if (error as? URLError)?.code == .cancelled { return }
            state = .failed(APIError(networkError: error).message)
        }
    }

    // MARK: - POST: crear un nuevo usuario

    /// Devuelve nil si salió bien o el mensaje de error para mostrarlo en el formulario.
    @discardableResult
    func createUser(name: String, email: String) async -> String? {
        guard let url = URL(string: baseURL), !isSending else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONEncoder().encode(User(id: 0, name: name, email: email))
            let data = try await send(request, path: "/users")
            let created = try JSONDecoder().decode(User.self, from: data)

            // La API siempre devuelve id 11: si ya existe, se usa el siguiente libre
            let freeID = users.contains { $0.id == created.id }
                ? (users.map(\.id).max() ?? 0) + 1
                : created.id
            users.insert(User(id: freeID, name: created.name, email: created.email), at: 0)
            localOnlyIDs.insert(freeID)
            if freeID != created.id {
                annotateLastRequest("La API asignó id \(created.id); en la app quedó con id \(freeID).")
            }
            return nil
        } catch {
            return message(for: error)
        }
    }

    // MARK: - PUT: actualizar un usuario existente

    @discardableResult
    func updateUser(user: User) async -> String? {
        guard !isSending else { return nil }

        if localOnlyIDs.contains(user.id) {
            replaceLocally(user)
            lastRequest = RequestLog(method: "PUT", path: "/users/\(user.id)", status: nil, seconds: 0,
                                     note: "Solo en la app: JSONPlaceholder no guarda los usuarios nuevos.")
            return nil
        }

        guard let url = URL(string: "\(baseURL)/\(user.id)") else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONEncoder().encode(user)
            _ = try await send(request, path: "/users/\(user.id)")
            replaceLocally(user)
            return nil
        } catch {
            return message(for: error)
        }
    }

    // MARK: - DELETE: eliminar un usuario por id

    func deleteUser(id: Int) async {
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

        do {
            _ = try await send(request, path: "/users/\(id)")
            users.removeAll { $0.id == id } // la API responde 200 pero no borra de verdad
        } catch {
            errorMessage = message(for: error)
        }
    }

    // MARK: - Apoyo

    /// Envía POST, PUT o DELETE con data(for:) y revisa el código HTTP.
    private func send(_ request: URLRequest, path: String) async throws -> Data {
        isSending = true
        defer { isSending = false }
        let start = Date()

        let (data, response) = try await URLSession.shared.data(for: request)
        try record(request.httpMethod ?? "GET", path, response, since: start)
        return data
    }

    /// Guarda la petición en el registro y lanza error si el código no es 2xx.
    private func record(_ method: String, _ path: String, _ response: URLResponse, since start: Date) throws {
        let status = (response as? HTTPURLResponse)?.statusCode
        lastRequest = RequestLog(method: method, path: path, status: status,
                                 seconds: Date().timeIntervalSince(start), note: nil)
        if let status, !(200...299).contains(status) {
            throw APIError(message: "La API respondió con el código \(status).")
        }
    }

    private func message(for error: Error) -> String {
        switch error {
        case let apiError as APIError: apiError.message
        case is DecodingError: "La API respondió, pero no devolvió el usuario esperado."
        case is EncodingError: "No se pudo preparar el usuario para enviarlo."
        default: APIError(networkError: error).message
        }
    }

    private func replaceLocally(_ user: User) {
        if let index = users.firstIndex(where: { $0.id == user.id }) {
            users[index] = user
        }
    }

    private func annotateLastRequest(_ note: String) {
        guard let log = lastRequest else { return }
        lastRequest = RequestLog(method: log.method, path: log.path, status: log.status, seconds: log.seconds, note: note)
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
