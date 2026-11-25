//
//  User.swift
//  Semana13_MetodosAPI_Async
//
//  Created by Jason Gomez.
//  Modelo usado en los métodos POST, PUT y DELETE.
//

import Foundation

// Codable: sirve para leer el JSON de la API (GET) y para armar el cuerpo de POST y PUT.
// Identifiable: el List y los swipeActions ubican cada fila por su id.
nonisolated struct User: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let email: String
}

extension User {
    /// Iniciales para el avatar: "Leanne Graham" -> "LG". Se salta prefijos como "Mrs.".
    var initials: String {
        UserValidator.initials(for: name)
    }
}
