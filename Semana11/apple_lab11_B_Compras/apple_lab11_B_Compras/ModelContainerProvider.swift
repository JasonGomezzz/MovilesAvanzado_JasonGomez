//
//  ModelContainerProvider.swift
//  apple_lab11_B_Compras
//
//  Created by Jason on 17/11/26.
//

import Foundation
import SwiftData

@MainActor // Garantiza que esta clase se ejecute en el hilo principal (UI-safe)
class ModelContainerProvider {
    // Patrón Singleton: una única instancia del contenedor para toda la app
    static let shared = ModelContainerProvider()

    let container: ModelContainer // Contenedor principal de SwiftData

    private init() {
        // Esquema: las cuatro clases modelo que se guardan en la base
        let schema = Schema([Usuario.self, Proveedor.self, Producto.self, Compra.self])

        do {
            // Dónde se guardará la base de datos SQLite
            let config = ModelConfiguration(
                "ComprasData",
                schema: schema,
                url: FileManager.default
                    .urls(for: .applicationSupportDirectory, in: .userDomainMask)
                    .first!
                    .appendingPathComponent("ComprasData.sqlite")
            )

            // Para ver dónde quedó el archivo
            print("Base de datos SQLite en: \(config.url.path)")

            container = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Error al inicializar ModelContainer: \(error)")
        }
    }
}
