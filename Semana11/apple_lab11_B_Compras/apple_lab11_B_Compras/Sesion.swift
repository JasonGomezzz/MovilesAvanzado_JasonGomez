//
//  Sesion.swift
//  apple_lab11_B_Compras
//
//  Created by Jason on 17/11/26.
//

import Foundation
import SwiftData
import Observation

// Guarda quién inició sesión. Se comparte con toda la app usando .environment(...)
// Si "usuario" es nil se muestra el login; si tiene valor, se muestran las pestañas.
@Observable
class Sesion {
    var usuario: Usuario?

    // El usuario se guarda siempre en minúsculas y sin espacios
    func limpiar(_ texto: String) -> String {
        return texto.trimmingCharacters(in: .whitespaces).lowercased()
    }

    // Busca con un FetchDescriptor si ya existe ese usuario
    func existeUsuario(_ nombreUsuario: String, contexto: ModelContext) -> Bool {
        let buscado = limpiar(nombreUsuario)   // se guarda en un let antes de usarlo en el #Predicate
        if buscado.isEmpty { return false }
        let consulta = FetchDescriptor<Usuario>(predicate: #Predicate { $0.usuario == buscado })
        let cantidad = (try? contexto.fetchCount(consulta)) ?? 0
        return cantidad > 0
    }

    // Registra un usuario nuevo. Devuelve un mensaje de error, o nil si todo salió bien.
    func registrar(nombre: String, usuario: String, clave: String, confirmacion: String,
                   rol: String, contexto: ModelContext) -> String? {
        if nombre.trimmingCharacters(in: .whitespaces).isEmpty { return "Escribe tu nombre completo." }
        if limpiar(usuario).isEmpty { return "Escribe un usuario." }
        if existeUsuario(usuario, contexto: contexto) { return "Ese usuario ya existe." }
        if clave.count < 6 { return "La clave debe tener al menos 6 caracteres." }
        if clave != confirmacion { return "Las claves no coinciden." }

        let nuevo = Usuario(nombre: nombre.trimmingCharacters(in: .whitespaces),
                            usuario: limpiar(usuario), clave: clave, rol: rol)
        contexto.insert(nuevo)
        try? contexto.save()
        self.usuario = nuevo   // entra directo a la app
        return nil
    }

    // Login: devuelve true si el usuario y la clave coinciden
    func iniciarSesion(usuario: String, clave: String, contexto: ModelContext) -> Bool {
        let buscado = limpiar(usuario)
        let consulta = FetchDescriptor<Usuario>(predicate: #Predicate { $0.usuario == buscado })
        if let encontrado = try? contexto.fetch(consulta).first, encontrado.clave == clave {
            self.usuario = encontrado
            return true
        }
        return false
    }

    // Cerrar sesión: poner la variable en nil y la vista cambia sola al login
    func cerrarSesion() {
        usuario = nil
    }
}
