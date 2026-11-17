import SwiftData
import SwiftUI

/// B1 · Inicio de sesión.
struct LoginView: View {
    @Environment(\.modelContext) private var contexto
    @Environment(Sesion.self) private var sesion

    @State private var usuario = ""
    @State private var clave = ""
    @State private var huboError = false
    @State private var intentosFallidos = 0
    @FocusState private var foco: Campo?

    private enum Campo { case usuario, clave }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(spacing: 10) {
                    Image("LogoCompras")
                        .resizable()
                        .frame(width: 84, height: 84)
                        .clipShape(RoundedRectangle(cornerRadius: 19, style: .continuous))
                        .shadow(color: .black.opacity(0.12), radius: 8, y: 3)
                        .accessibilityHidden(true)
                    Text("Compras Tecsup")
                        .font(.title.weight(.bold))
                        .tracking(-0.3)
                    Text("Inicia sesión para continuar")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 48)
                .padding(.bottom, 12)

                CampoEtiquetado(etiqueta: "Usuario") {
                    TextField("Tu usuario", text: $usuario)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .textContentType(.username)
                        .submitLabel(.next)
                        .focused($foco, equals: .usuario)
                        .onSubmit { foco = .clave }
                }

                CampoEtiquetado(etiqueta: "Clave") {
                    SecureField("Tu clave", text: $clave)
                        .textContentType(.password)
                        .submitLabel(.go)
                        .focused($foco, equals: .clave)
                        .onSubmit(ingresar)
                }

                if huboError {
                    MensajeError(texto: "Usuario o clave incorrectos")
                        .transition(.opacity)
                }

                Button("Ingresar", action: ingresar)
                    .buttonStyle(BotonPrincipal())
                    .padding(.top, 4)

                NavigationLink {
                    RegistroView()
                } label: {
                    Text("¿Primera vez? \(Text("Crear cuenta").foregroundStyle(Color.marca).bold())")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
                .font(.subheadline)
                .padding(.top, 4)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .scrollBounceBehavior(.basedOnSize)
        .scrollDismissesKeyboard(.interactively)
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Ingresar")
        .toolbarVisibility(.hidden, for: .navigationBar)
        .sensoryFeedback(.error, trigger: intentosFallidos)
    }

    private func ingresar() {
        if let encontrado = Autenticacion.iniciarSesion(usuario: usuario, clave: clave, en: contexto) {
            sesion.iniciar(encontrado)
        } else {
            // Mensaje genérico: nunca se dice si falló el usuario o la clave.
            withAnimation(.easeOut(duration: 0.2)) { huboError = true }
            intentosFallidos += 1
            clave = ""
        }
    }
}
