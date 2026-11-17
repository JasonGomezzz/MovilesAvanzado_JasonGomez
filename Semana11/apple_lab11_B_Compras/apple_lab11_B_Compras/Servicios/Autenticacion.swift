import Foundation
import SwiftData

enum ErrorRegistro: LocalizedError {
    case nombreVacio
    case usuarioVacio
    case usuarioExistente
    case claveCorta
    case clavesNoCoinciden

    var errorDescription: String? {
        switch self {
        case .nombreVacio: "Escribe tu nombre completo."
        case .usuarioVacio: "Escribe un nombre de usuario."
        case .usuarioExistente: "Ese usuario ya existe. Elige otro."
        case .claveCorta: "La clave debe tener al menos 6 caracteres."
        case .clavesNoCoinciden: "Las claves no coinciden."
        }
    }
}

/// Registro e inicio de sesión. Las claves van como texto: es una práctica de laboratorio.
enum Autenticacion {
    static let largoMinimoClave = 6

    /// Quita espacios y pasa a minúsculas para comparar usuarios sin distinguir mayúsculas.
    static func normalizar(_ usuario: String) -> String {
        usuario.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    /// Consulta con #Predicate: el texto se guarda en un `let` antes de usarlo.
    static func existe(_ usuario: String, en contexto: ModelContext) -> Bool {
        let buscado = normalizar(usuario)
        guard !buscado.isEmpty else { return false }
        let consulta = FetchDescriptor<Usuario>(predicate: #Predicate { $0.usuario == buscado })
        return ((try? contexto.fetchCount(consulta)) ?? 0) > 0
    }

    static func registrar(nombre: String, usuario: String, clave: String, confirmacion: String,
                          rol: RolUsuario, en contexto: ModelContext) throws -> Usuario {
        let nombreLimpio = nombre.trimmingCharacters(in: .whitespacesAndNewlines)
        let usuarioLimpio = normalizar(usuario)

        guard !nombreLimpio.isEmpty else { throw ErrorRegistro.nombreVacio }
        guard !usuarioLimpio.isEmpty else { throw ErrorRegistro.usuarioVacio }
        guard !existe(usuarioLimpio, en: contexto) else { throw ErrorRegistro.usuarioExistente }
        guard clave.count >= largoMinimoClave else { throw ErrorRegistro.claveCorta }
        guard clave == confirmacion else { throw ErrorRegistro.clavesNoCoinciden }

        let nuevo = Usuario(nombre: nombreLimpio, usuario: usuarioLimpio, clave: clave, rol: rol)
        contexto.insert(nuevo)
        contexto.guardar()
        return nuevo
    }

    /// Devuelve el usuario si coinciden usuario y clave. Nunca dice cuál de los dos falló.
    static func iniciarSesion(usuario: String, clave: String, en contexto: ModelContext) -> Usuario? {
        let buscado = normalizar(usuario)
        guard !buscado.isEmpty else { return nil }
        let consulta = FetchDescriptor<Usuario>(predicate: #Predicate { $0.usuario == buscado })
        guard let encontrado = try? contexto.fetch(consulta).first, encontrado.clave == clave else {
            return nil
        }
        return encontrado
    }
}
