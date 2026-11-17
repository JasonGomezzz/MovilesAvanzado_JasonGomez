import SwiftData
import SwiftUI

/// B2 · Crear cuenta. Al registrarse la persona entra directo a la app.
struct RegistroView: View {
    @Environment(\.modelContext) private var contexto
    @Environment(Sesion.self) private var sesion

    @State private var nombre = ""
    @State private var usuario = ""
    @State private var clave = ""
    @State private var confirmacion = ""
    @State private var rol: RolUsuario = .comprador
    @State private var error: String?
    @State private var intentosFallidos = 0

    /// nil = todavía no escribió nada; true = libre; false = ya existe.
    private var usuarioDisponible: Bool? {
        guard !Autenticacion.normalizar(usuario).isEmpty else { return nil }
        return !Autenticacion.existe(usuario, en: contexto)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                CampoEtiquetado(etiqueta: "Nombre completo") {
                    TextField("Lucía Paredes", text: $nombre)
                        .textContentType(.name)
                        .textInputAutocapitalization(.words)
                        .submitLabel(.next)
                }

                CampoEtiquetado(etiqueta: "Usuario") {
                    HStack {
                        TextField("lparedes", text: $usuario)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .submitLabel(.next)
                        if let libre = usuarioDisponible {
                            Label(libre ? "Disponible" : "Ya existe",
                                  systemImage: libre ? "checkmark" : "xmark")
                                .font(.footnote.weight(.medium))
                                .foregroundStyle(libre ? Color.correcto : Color.peligro)
                                .labelStyle(.titleAndIcon)
                                .transition(.opacity)
                        }
                    }
                }
                .animation(.easeOut(duration: 0.15), value: usuarioDisponible)

                CampoEtiquetado(etiqueta: "Clave (mínimo \(Autenticacion.largoMinimoClave) caracteres)") {
                    SecureField("••••••", text: $clave)
                        .submitLabel(.next)
                }

                CampoEtiquetado(etiqueta: "Confirmar clave") {
                    HStack {
                        SecureField("••••••", text: $confirmacion)
                                .submitLabel(.go)
                            .onSubmit(registrar)
                        if !confirmacion.isEmpty {
                            Image(systemName: confirmacion == clave ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundStyle(confirmacion == clave ? Color.correcto : Color.peligro)
                                .accessibilityLabel(confirmacion == clave ? "Las claves coinciden" : "Las claves no coinciden")
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("TU ROL")
                        .font(.caption2.weight(.semibold))
                        .tracking(0.6)
                        .foregroundStyle(.secondary)
                    Picker("Rol", selection: $rol) {
                        ForEach(RolUsuario.allCases) { Text($0.rawValue).tag($0) }
                    }
                    .pickerStyle(.segmented)
                }

                if let error {
                    MensajeError(texto: error)
                }

                Button("Registrarme", action: registrar)
                    .buttonStyle(BotonPrincipal())

                Text("Al registrarte entrarás directamente a la app con las pestañas de tu rol.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Crear cuenta")
        .navigationBarTitleDisplayMode(.inline)
        .sensoryFeedback(.error, trigger: intentosFallidos)
    }

    private func registrar() {
        do {
            let nuevo = try Autenticacion.registrar(nombre: nombre, usuario: usuario, clave: clave,
                                                    confirmacion: confirmacion, rol: rol, en: contexto)
            sesion.iniciar(nuevo)
        } catch {
            self.error = error.localizedDescription
            intentosFallidos += 1
        }
    }
}
