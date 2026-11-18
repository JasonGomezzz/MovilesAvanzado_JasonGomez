//
//  Usuario.swift
//  apple_lab11_B_Compras
//
//  Created by Jason on 17/11/26.
//

import Foundation
import SwiftData

// Persona que usa la app. Su rol puede ser "Comprador" o "Supervisor"
@Model
class Usuario {
    var nombre: String
    var usuario: String   // nombre de usuario único (siempre en minúsculas)
    var clave: String
    var rol: String       // "Comprador" o "Supervisor"

    // Deny: no se puede borrar un usuario que ya registró compras
    @Relationship(deleteRule: .deny, inverse: \Compra.comprador)
    var compras: [Compra] = []

    init(nombre: String, usuario: String, clave: String, rol: String) {
        self.nombre = nombre
        self.usuario = usuario
        self.clave = clave
        self.rol = rol
    }

    // Atajo para saber si es supervisor
    var esSupervisor: Bool {
        return rol == "Supervisor"
    }
}
