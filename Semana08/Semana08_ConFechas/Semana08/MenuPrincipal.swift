//
//  MenuPrincipal.swift
//  Semana08
//
//  Menú navegable. Para sumar una pantalla: agregar un NavigationLink.
//

import SwiftUI

struct MenuPrincipal: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Venta de productos") { ContentView() }
                NavigationLink("Cálculo de CTS") { CTSView() }
                NavigationLink("Pago de instructores") { PagoInstructoresView() }
            }
            .navigationTitle("Menú Principal")
        }
    }
}

#Preview {
    MenuPrincipal()
}
