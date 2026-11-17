import Foundation
import SwiftData

/// Los dos roles de la app. En la base de datos se guarda el texto (rawValue).
enum RolUsuario: String, CaseIterable, Identifiable {
    case comprador = "Comprador"
    case supervisor = "Supervisor"

    var id: String { rawValue }
}

/// Persona que entra a la app. Cada compra guarda quién la registró.
@Model
final class Usuario {
    var nombre: String
    /// Siempre en minúsculas y sin espacios: así "LParedes" y "lparedes" son el mismo usuario.
    var usuario: String
    /// Práctica de laboratorio: la clave va como texto. En una app real se guardaría un hash.
    var clave: String
    var rol: String

    /// Un usuario con compras no se puede borrar (.deny).
    @Relationship(deleteRule: .deny, inverse: \Compra.comprador)
    var compras: [Compra] = []

    init(nombre: String, usuario: String, clave: String, rol: RolUsuario) {
        self.nombre = nombre
        self.usuario = usuario
        self.clave = clave
        self.rol = rol.rawValue
    }

    var rolTipo: RolUsuario { RolUsuario(rawValue: rol) ?? .comprador }
    var esSupervisor: Bool { rolTipo == .supervisor }
}
