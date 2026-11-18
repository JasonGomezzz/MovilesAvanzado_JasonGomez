//
//  RegistroView.swift
//  apple_lab11_B_Compras
//
//  Created by Jason on 17/11/26.
//

import SwiftUI
import SwiftData

// B2 · Crear cuenta. Al registrarse entra directo a la app.
struct RegistroView: View {
    @Environment(Sesion.self) private var sesion
    @Environment(\.modelContext) private var modelContext

    @State private var nombre = ""
    @State private var usuario = ""
    @State private var clave = ""
    @State private var confirmacion = ""
    @State private var rol = "Comprador"
    @State private var mensaje = ""

    var body: some View {
        Form {
            Section("Nombre completo") {
                TextField("Lucía Paredes", text: $nombre)
                    .textInputAutocapitalization(.words)
            }

            Section("Usuario") {
                HStack {
                    TextField("lparedes", text: $usuario)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    // Aviso en vivo: Disponible o Ya existe
                    if !usuario.isEmpty {
                        if sesion.existeUsuario(usuario, contexto: modelContext) {
                            Text("Ya existe").foregroundStyle(.red)
                        } else {
                            Text("✓ Disponible").foregroundStyle(.green)
                        }
                    }
                }
            }

            Section("Clave (mínimo 6 caracteres)") {
                SecureField("Clave", text: $clave)
                SecureField("Confirmar clave", text: $confirmacion)
            }

            Section("Tu rol") {
                Picker("Rol", selection: $rol) {
                    Text("Comprador").tag("Comprador")
                    Text("Supervisor").tag("Supervisor")
                }
                .pickerStyle(.segmented)
            }

            if !mensaje.isEmpty {
                Text(mensaje)
                    .foregroundStyle(.red)
            }

            Button("Registrarme") {
                registrar()
            }
            .frame(maxWidth: .infinity)
        }
        .navigationTitle("Crear cuenta")
        .navigationBarTitleDisplayMode(.inline)
    }

    func registrar() {
        // Si hay error vuelve un texto; si todo sale bien vuelve nil y la sesión ya queda iniciada
        if let error = sesion.registrar(nombre: nombre, usuario: usuario, clave: clave,
                                        confirmacion: confirmacion, rol: rol, contexto: modelContext) {
            mensaje = error
        }
    }
}
