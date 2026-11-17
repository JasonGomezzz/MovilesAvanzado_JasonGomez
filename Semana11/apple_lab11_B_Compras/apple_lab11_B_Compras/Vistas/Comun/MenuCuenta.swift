import SwiftData
import SwiftUI

/// Avatar de la sesión en la barra superior. Al tocarlo: nombre, rol y Cerrar sesión.
/// Esta es la "pestaña Cuenta" del enunciado, hecha como menú del avatar.
struct MenuCuenta: View {
    @Environment(Sesion.self) private var sesion
    @Environment(\.modelContext) private var contexto
    @State private var confirmarCarga = false

    var body: some View {
        if let usuario = sesion.usuario {
            Menu {
                Section("\(usuario.nombre) · \(usuario.rol)") {
                    Label("@\(usuario.usuario)", systemImage: "person")
                }
                if usuario.esSupervisor {
                    Button("Cargar historial de ejemplo", systemImage: "tray.and.arrow.down") {
                        confirmarCarga = true
                    }
                }
                Section {
                    Button("Cerrar sesión", systemImage: "rectangle.portrait.and.arrow.right", role: .destructive) {
                        sesion.cerrar()
                    }
                }
            } label: {
                Avatar(texto: usuario.nombre, tamano: 32, circular: true)
            }
            .accessibilityLabel("Cuenta de \(usuario.nombre)")
            .confirmationDialog("Cargar historial de ejemplo",
                                isPresented: $confirmarCarga, titleVisibility: .visible) {
                Button("Cargar 11 compras de ejemplo") {
                    DatosDemo.cargarHistorial(por: usuario, en: contexto)
                }
            } message: {
                Text("Crea compras de los últimos 6 meses con las mismas reglas de la app, para ver el Resumen con datos.")
            }
        }
    }
}

/// Aviso corto en alerta con un solo botón.
struct AvisoAlerta: Identifiable {
    let id = UUID()
    let titulo: String
    let mensaje: String
}
