import SwiftData
import SwiftUI

@main // Punto de entrada principal de la aplicación
struct ComprasApp: App {
    /// Una sola sesión para toda la app; se comparte por el entorno.
    @State private var sesion = Sesion()

    var body: some Scene {
        WindowGroup {
            RaizView()
                .environment(sesion)
                .tint(.marca)
        }
        // Contenedor persistente: los datos se guardan en disco y no se borran al cerrar la app.
        .modelContainer(ModelContainerProvider.shared.container)
    }
}
