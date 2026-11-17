import Foundation
import OSLog
import SwiftData

/// Mensajes de diagnóstico de la app (se leen en la consola de Xcode).
let registro = Logger(subsystem: "pe.tecsup.compras", category: "datos")

extension ModelContext {
    /// Guarda y avisa en consola si falla. SwiftData ya guarda solo, pero esto asegura el guardado inmediato.
    func guardar() {
        do {
            try save()
        } catch {
            registro.error("No se pudo guardar: \(error.localizedDescription, privacy: .public)")
        }
    }
}

enum Formato {
    private static let ingles = Locale(identifier: "en_US")
    private static let peru = Locale(identifier: "es_PE")

    /// 7080 → "S/ 7,080.00"
    static func soles(_ valor: Double) -> String {
        "S/ " + valor.formatted(.number.precision(.fractionLength(2)).locale(ingles))
    }

    /// 7080 → "S/ 7.1k" para los ejes de los gráficos
    static func solesCompacto(_ valor: Double) -> String {
        if valor >= 1_000 {
            return "S/ " + (valor / 1_000).formatted(.number.precision(.fractionLength(0...1)).locale(ingles)) + "k"
        }
        return "S/ " + valor.formatted(.number.precision(.fractionLength(0)).locale(ingles))
    }

    /// 3 de noviembre → "03/11"
    static func fechaCorta(_ fecha: Date) -> String {
        fecha.formatted(.dateTime.day(.twoDigits).month(.twoDigits).locale(peru))
    }

    /// 3 de noviembre de 2026 → "03/11/2026"
    static func fechaCompleta(_ fecha: Date) -> String {
        fecha.formatted(.dateTime.day(.twoDigits).month(.twoDigits).year().locale(peru))
    }

    static func mes(_ fecha: Date) -> String {
        fecha.formatted(.dateTime.month(.abbreviated).locale(peru))
            .replacingOccurrences(of: ".", with: "")
            .capitalized
    }

    /// Acepta "120", "120.5" o "120,5". Devuelve nil si no es un número.
    static func numero(_ texto: String) -> Double? {
        let limpio = texto.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: ",", with: ".")
        return Double(limpio)
    }

    static func decimal(_ valor: Double) -> String {
        valor.formatted(.number.precision(.fractionLength(2)).grouping(.never).locale(ingles))
    }

    /// "Laptop Pro 14" → "LP"
    static func iniciales(_ texto: String) -> String {
        let letras = texto.split(separator: " ").prefix(2).compactMap { $0.first }
        return String(letras).uppercased()
    }
}
