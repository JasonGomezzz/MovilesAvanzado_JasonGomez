//
//  UserValidator.swift
//  Semana13_MetodosAPI
//
//  Created by Jason Gomez.
//  Reglas del formulario. Están fuera de la vista para poder probarlas solas
//  (ver Verificacion/main.swift).
//

import Foundation

nonisolated enum UserValidator {

    static let maxNameLength = 60
    static let maxEmailLength = 80

    /// Palabras que la gente escribe "para probar" y que no son nombres reales.
    private static let fillerWords: Set<String> = [
        "xxx", "xx", "asd", "asdf", "qwe", "qwerty", "test", "testing", "prueba", "pruebas",
        "demo", "ejemplo", "nombre", "apellido", "usuario", "user", "name", "null", "nil",
        "none", "abc", "abcd", "foo", "lorem", "ipsum", "sin", "nadie", "fulano", "mengano"
    ]

    /// Dominios que solo se usan para pruebas.
    private static let fillerDomains: Set<String> = [
        "test.com", "prueba.com", "example.com", "ejemplo.com", "xxx.com", "asdf.com", "correo.com"
    ]

    private static let honorifics: Set<String> = ["mr.", "mrs.", "ms.", "dr.", "sr.", "sra.", "srta."]

    // MARK: - Normalización (lo que realmente se guarda)

    /// Quita espacios de los extremos y los dobles espacios del medio.
    static func normalizeName(_ raw: String) -> String {
        raw.split(whereSeparator: \.isWhitespace)
            .map { word -> String in
                // "juan pérez" -> "Juan Pérez", pero respeta "DuBuque" o "McDonald"
                let text = String(word)
                return text == text.lowercased() ? text.prefix(1).uppercased() + text.dropFirst() : text
            }
            .joined(separator: " ")
    }

    static func normalizeEmail(_ raw: String) -> String {
        raw.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    // MARK: - Reglas

    /// Devuelve el mensaje de error del nombre, o nil si es válido.
    static func nameError(_ raw: String) -> String? {
        let name = normalizeName(raw)
        if name.isEmpty {
            return "Escribe el nombre del usuario."
        }
        if name.count > maxNameLength {
            return "Máximo \(maxNameLength) caracteres."
        }
        let allowed = CharacterSet.letters.union(CharacterSet(charactersIn: " '-."))
        if name.unicodeScalars.contains(where: { !allowed.contains($0) }) {
            return "Usa solo letras: sin números ni símbolos."
        }

        let words = name.split(separator: " ")
            .map { String($0) }
            .filter { !honorifics.contains($0.lowercased()) }
        // Se aceptan iniciales sueltas ("Nicholas Runolfsdottir V"), pero debe haber
        // al menos un nombre y un apellido de 2 letras o más.
        let realWords = words.filter { lettersOnly($0).count >= 2 }
        if realWords.count < 2 {
            return "Escribe nombre y apellido."
        }

        for word in words {
            let letters = lettersOnly(word).lowercased()
            if fillerWords.contains(letters) {
                return "“\(word)” no es un nombre real."
            }
            if hasTripleLetter(letters) {
                return "“\(word)” parece texto de relleno."
            }
            if letters.count >= 3 && !letters.contains(where: { "aeiouáéíóúüy".contains($0) }) {
                return "“\(word)” no parece un nombre."
            }
        }
        return nil
    }

    /// Devuelve el mensaje de error del correo, o nil si es válido.
    /// `others` son los demás usuarios (sin el que se está editando) para evitar duplicados.
    static func emailError(_ raw: String, others: [User]) -> String? {
        let email = normalizeEmail(raw)
        if email.isEmpty {
            return "Escribe el correo."
        }
        if email.count > maxEmailLength {
            return "Máximo \(maxEmailLength) caracteres."
        }
        let pattern = #"^[a-z0-9._%+-]+@[a-z0-9-]+(\.[a-z0-9-]+)*\.[a-z]{2,}$"#
        let parts = email.split(separator: "@", omittingEmptySubsequences: false)
        guard email.range(of: pattern, options: .regularExpression) != nil,
              parts.count == 2,
              !email.contains(".."),
              !parts[0].hasPrefix("."), !parts[0].hasSuffix(".") else {
            return "El correo debe tener la forma nombre@dominio.com."
        }

        let local = String(parts[0])
        let domain = String(parts[1])
        if fillerWords.contains(local) || hasTripleLetter(local) || fillerDomains.contains(domain) {
            return "Usa un correo real, no uno de prueba."
        }
        if let owner = others.first(where: { $0.email.lowercased() == email }) {
            return "Ese correo ya lo usa \(owner.name)."
        }
        return nil
    }

    // MARK: - Apoyo

    static func initials(for name: String) -> String {
        let words = name.split(separator: " ").filter { !honorifics.contains($0.lowercased()) }
        let letters = words.prefix(2).compactMap(\.first)
        return letters.isEmpty ? "?" : String(letters).uppercased()
    }

    private static func lettersOnly(_ word: String) -> String {
        String(word.filter(\.isLetter))
    }

    /// true si la misma letra aparece 3 veces seguidas ("xxx", "Juaaan").
    private static func hasTripleLetter(_ text: String) -> Bool {
        let chars = Array(text.lowercased())
        guard chars.count >= 3 else { return false }
        for i in 2..<chars.count where chars[i] == chars[i - 1] && chars[i] == chars[i - 2] {
            return true
        }
        return false
    }
}
