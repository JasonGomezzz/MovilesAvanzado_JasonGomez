//
//  UserViewModel.swift
//  Semana13_ConsumoAPI
//
//  Created by Jason Gomez.
//

import Foundation
import Combine // ObservableObject y @Published viven en Combine (Xcode 26 exige importarlo)

// ViewModel: pide los usuarios a la API y guarda en qué estado está la pantalla.
// La vista solo lee estas propiedades; no sabe nada de URLSession.
final class UserViewModel: ObservableObject {

    enum LoadState: Equatable {
        case loading
        case loaded
        case failed(String)
    }

    // @Published avisa a la vista cada vez que cambian, para que se vuelva a dibujar
    @Published var users: [User] = []
    @Published var state: LoadState = .loading

    private let endpoint = "https://jsonplaceholder.typicode.com/users"

    // GET: obtiene la lista de usuarios
    func fetchUsers() {
        guard let url = URL(string: endpoint) else {
            state = .failed("La dirección de la API no es válida.")
            return
        }
        state = .loading

        // dataTask trabaja en segundo plano; el resultado llega en el closure
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            let result = Self.decodeUsers(data: data, response: response, error: error)

            // La interfaz solo se puede tocar desde el hilo principal
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
                    self?.users = users
                    self?.state = .loaded
                case .failure(let apiError):
                    self?.state = .failed(apiError.message)
                }
            }
        }.resume() // sin resume() la petición nunca sale
    }

    /// Revisa error de red, código HTTP y formato del JSON, en ese orden.
    nonisolated private static func decodeUsers(data: Data?, response: URLResponse?, error: Error?) -> Result<[User], APIError> {
        if let error {
            return .failure(APIError(networkError: error))
        }
        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            return .failure(APIError(message: "La API respondió con el código \(http.statusCode)."))
        }
        guard let data else {
            return .failure(APIError(message: "La API no devolvió datos."))
        }
        do {
            return .success(try JSONDecoder().decode([User].self, from: data))
        } catch {
            return .failure(APIError(message: "La respuesta de la API no tiene el formato esperado."))
        }
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
