import Foundation
import Observation

/// Quién está conectado mientras la app está abierta.
/// Se pone en el entorno desde la App: si `usuario` es nil se ve el login, si no, las pestañas.
@Observable
final class Sesion {
    private(set) var usuario: Usuario?

    var esSupervisor: Bool { usuario?.esSupervisor ?? false }

    func iniciar(_ usuario: Usuario) {
        self.usuario = usuario
    }

    func cerrar() {
        usuario = nil
    }
}
