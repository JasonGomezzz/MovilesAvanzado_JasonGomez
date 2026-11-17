import SwiftData
import SwiftUI

/// Pantalla inicial: si hay una sesión se ven las pestañas del rol; si no, el login.
struct RaizView: View {
    @Environment(Sesion.self) private var sesion
    @Environment(\.modelContext) private var contexto

    var body: some View {
        Group {
            if sesion.usuario != nil {
                PestanasView()
            } else {
                NavigationStack { LoginView() }
            }
        }
        .animation(.easeOut(duration: 0.2), value: sesion.usuario == nil)
        .task { DatosDemo.sembrarCatalogoSiVacio(en: contexto) }
    }
}

/// Las pestañas cambian según el rol de quien inició sesión.
struct PestanasView: View {
    @Environment(Sesion.self) private var sesion

    var body: some View {
        if sesion.esSupervisor {
            TabView {
                Tab("Resumen", systemImage: "chart.bar.xaxis") { ResumenView() }
                Tab("Aprobar", systemImage: "checkmark.seal") { AprobarView() }
                Tab("Por pagar", systemImage: "creditcard") { PorPagarView() }
                Tab("Productos", systemImage: "shippingbox") { ProductosView() }
                Tab("Proveedores", systemImage: "building.2") { ProveedoresView() }
            }
        } else {
            TabView {
                Tab("Productos", systemImage: "shippingbox") { ProductosView() }
                Tab("Proveedores", systemImage: "building.2") { ProveedoresView() }
                Tab("Compra", systemImage: "cart.badge.plus") { NuevaCompraView() }
                Tab("Mis compras", systemImage: "list.bullet.rectangle") { MisComprasView() }
            }
        }
    }
}
