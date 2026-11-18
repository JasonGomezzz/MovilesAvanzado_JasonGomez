//
//  ContentView.swift
//  apple_lab11_B_Compras
//
//  Created by Jason on 17/11/26.
//

import SwiftUI
import SwiftData

// Pantalla inicial: si hay un usuario en la sesión se muestran las pestañas de su rol;
// si no, se muestra el login.
struct ContentView: View {
    @Environment(Sesion.self) private var sesion
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        Group {
            if let usuario = sesion.usuario {
                if usuario.esSupervisor {
                    // Pestañas del supervisor
                    TabView {
                        ResumenView()
                            .tabItem { Label("Resumen", systemImage: "chart.bar") }
                        AprobarView()
                            .tabItem { Label("Aprobar", systemImage: "checkmark.seal") }
                        PorPagarView()
                            .tabItem { Label("Por pagar", systemImage: "creditcard") }
                        ProductosView()
                            .tabItem { Label("Productos", systemImage: "shippingbox") }
                        ProveedoresView()
                            .tabItem { Label("Proveedores", systemImage: "building.2") }
                    }
                } else {
                    // Pestañas del comprador
                    TabView {
                        ProductosView()
                            .tabItem { Label("Productos", systemImage: "shippingbox") }
                        ProveedoresView()
                            .tabItem { Label("Proveedores", systemImage: "building.2") }
                        NuevaCompraView()
                            .tabItem { Label("Compra", systemImage: "cart.badge.plus") }
                        MisComprasView()
                            .tabItem { Label("Mis compras", systemImage: "list.bullet") }
                    }
                }
            } else {
                LoginView()
            }
        }
        // La primera vez se cargan los productos y proveedores de ejemplo
        .onAppear {
            DatosIniciales.cargarCatalogo(contexto: modelContext)
        }
    }
}
