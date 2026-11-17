import Foundation
import SwiftData

@Model
final class Proveedor {
    var nombre: String
    var ruc: String

    /// Un proveedor con compras no se puede borrar (.deny).
    @Relationship(deleteRule: .deny, inverse: \Compra.proveedor)
    var compras: [Compra] = []

    init(nombre: String, ruc: String) {
        self.nombre = nombre
        self.ruc = ruc
    }

    // Valores calculados a partir de la relación proveedor ▸ compras (no se guardan).

    var comprasAprobadas: [Compra] {
        compras.filter { $0.estadoCompra == .aprobada }
    }

    var totalComprado: Double {
        comprasAprobadas.reduce(0) { $0 + $1.total }
    }

    /// Compras aprobadas a crédito que todavía no se pagan.
    var comprasPorPagar: [Compra] {
        comprasAprobadas.filter { $0.alCredito && !$0.pagada }
    }
}
