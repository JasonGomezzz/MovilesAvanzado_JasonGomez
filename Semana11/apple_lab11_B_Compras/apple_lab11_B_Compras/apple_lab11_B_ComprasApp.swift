//
//  apple_lab11_B_ComprasApp.swift
//  apple_lab11_B_Compras
//
//  Created by Jason on 17/11/26.
//

import SwiftUI
import SwiftData

@main // Punto de entrada principal de la aplicación
struct ComprasApp: App {
    // Una sola sesión para toda la app
    @State private var sesion = Sesion()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(sesion) // La sesión se comparte con todas las vistas
                .tint(.teal)
                // Contenedor persistente: los datos se guardan en disco
                .modelContainer(ModelContainerProvider.shared.container)
        }
    }
}
