//
//  User.swift
//  Semana13_ConsumoAPI
//
//  Created by Jason Gomez.
//

import Foundation

// Codable: convierte el JSON de la API en esta estructura (y al revés) sin escribir el parseo a mano.
// Identifiable: SwiftUI usa el id para saber qué fila es cuál dentro del List.
// La API devuelve más campos (username, phone, address...), pero solo pedimos id y name;
// JSONDecoder ignora los que no están declarados.
nonisolated struct User: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
}

extension User {
    /// Iniciales para el avatar: "Leanne Graham" -> "LG". Se salta prefijos como "Mrs." o "Mr.".
    var initials: String {
        let prefixes: Set<String> = ["mr.", "mrs.", "ms.", "dr."]
        let words = name
            .split(separator: " ")
            .filter { !prefixes.contains($0.lowercased()) }
        let letters = words.prefix(2).compactMap { $0.first }
        return letters.isEmpty ? "?" : String(letters).uppercased()
    }
}
