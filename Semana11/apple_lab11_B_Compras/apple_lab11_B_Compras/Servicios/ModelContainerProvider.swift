import Foundation
import SwiftData

/// Dónde se guardan los datos: un único contenedor para toda la app (patrón singleton),
/// igual que en la Actividad 02 pero con las cuatro clases del caso Compras.
@MainActor
final class ModelContainerProvider {
    static let shared = ModelContainerProvider()

    static let esquema = Schema([Usuario.self, Proveedor.self, Producto.self, Compra.self])

    let container: ModelContainer

    private init() {
        do {
            let carpeta = URL.applicationSupportDirectory
            try FileManager.default.createDirectory(at: carpeta, withIntermediateDirectories: true)
            let configuracion = ModelConfiguration(
                "ComprasData",
                schema: Self.esquema,
                url: carpeta.appending(path: "ComprasData.sqlite")
            )
            // Para ver dónde quedó el archivo SQLite
            print("Base de datos SQLite en: \(configuracion.url.path)")
            container = try ModelContainer(for: Self.esquema, configurations: [configuracion])
        } catch {
            fatalError("Error al inicializar ModelContainer: \(error)")
        }
    }

    /// Contenedor en memoria para vistas previas y pruebas: no toca el archivo real.
    static func enMemoria() -> ModelContainer {
        let configuracion = ModelConfiguration(isStoredInMemoryOnly: true)
        // swiftlint:disable:next force_try
        return try! ModelContainer(for: esquema, configurations: [configuracion])
    }
}
