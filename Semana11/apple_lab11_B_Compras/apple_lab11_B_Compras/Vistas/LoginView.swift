//
//  LoginView.swift
//  apple_lab11_B_Compras
//
//  Created by Jason on 17/11/26.
//

import SwiftUI
import SwiftData

// B1 · Inicio de sesión
struct LoginView: View {
    @Environment(Sesion.self) private var sesion
    @Environment(\.modelContext) private var modelContext

    @State private var usuario = ""
    @State private var clave = ""
    @State private var hayError = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 14) {
                Image("LogoCompras")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                Text("Compras Tecsup")
                    .font(.title.bold())
                Text("Inicia sesión para continuar")
                    .foregroundStyle(.secondary)

                TextField("Usuario", text: $usuario)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()

                SecureField("Clave", text: $clave)
                    .textFieldStyle(.roundedBorder)

                // Mensaje genérico: no dice si falló el usuario o la clave
                if hayError {
                    Label("Usuario o clave incorrectos", systemImage: "exclamationmark.triangle.fill")
                        .font(.footnote)
                        .foregroundStyle(.red)
                }

                Button {
                    ingresar()
                } label: {
                    Text("Ingresar")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)

                NavigationLink("¿Primera vez? Crear cuenta") {
                    RegistroView()
                }
                .font(.subheadline)
            }
            .padding(24)
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.top, 40)
        }
    }

    func ingresar() {
        let entro = sesion.iniciarSesion(usuario: usuario, clave: clave, contexto: modelContext)
        hayError = !entro
        if !entro { clave = "" }
    }
}
