//
//  MenuAvatar.swift
//  apple_lab11_B_Compras
//
//  Created by Jason on 17/11/26.
//

import SwiftUI
import SwiftData

// Avatar con las iniciales del usuario. Al tocarlo: nombre, rol y Cerrar sesión.
// Se pone en la barra superior de cada pestaña.
struct MenuAvatar: View {
    @Environment(Sesion.self) private var sesion
    @Environment(\.modelContext) private var modelContext
    @State private var confirmarDatos = false

    var body: some View {
        if let usuario = sesion.usuario {
            Menu {
                Text("\(usuario.nombre) · \(usuario.rol)")

                // Solo el supervisor puede cargar compras de ejemplo
                if usuario.esSupervisor {
                    Button("Cargar compras de ejemplo", systemImage: "tray.and.arrow.down") {
                        confirmarDatos = true
                    }
                }
                Button("Cerrar sesión", systemImage: "rectangle.portrait.and.arrow.right", role: .destructive) {
                    sesion.cerrarSesion()
                }
            } label: {
                Text(iniciales(usuario.nombre))
                    .font(.caption.bold())
                    .foregroundStyle(.white)
                    .frame(width: 30, height: 30)
                    .background(Color.teal)
                    .clipShape(Circle())
            }
            .confirmationDialog("Compras de ejemplo", isPresented: $confirmarDatos) {
                Button("Cargar 11 compras de ejemplo") {
                    DatosIniciales.cargarCompras(comprador: usuario, contexto: modelContext)
                }
            } message: {
                Text("Crea compras de los últimos meses para ver el Resumen con datos.")
            }
        }
    }

    func iniciales(_ nombre: String) -> String {
        var resultado = ""
        for palabra in nombre.split(separator: " ").prefix(2) {
            resultado += String(palabra.prefix(1))
        }
        return resultado.uppercased()
    }
}
