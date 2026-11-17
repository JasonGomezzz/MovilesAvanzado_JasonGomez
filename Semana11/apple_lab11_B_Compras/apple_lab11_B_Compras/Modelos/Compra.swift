import Foundation
import SwiftData

enum EstadoCompra: String, CaseIterable {
    case pendiente = "Pendiente"
    case aprobada = "Aprobada"
    case rechazada = "Rechazada"
}

/// Una compra de un producto a un proveedor, registrada por un comprador.
@Model
final class Compra {
    var fecha: Date
    var cantidad: Int
    var costoUnitario: Double
    var igv: Double
    var total: Double
    var alCredito: Bool
    /// Solo tiene valor si la compra es a crédito: fecha de la compra + 30 días.
    var vence: Date?
    /// Se guarda el texto del enum EstadoCompra.
    var estado: String
    var pagada: Bool
    var motivoRechazo: String?

    var comprador: Usuario?
    var proveedor: Proveedor?
    var producto: Producto?

    init(fecha: Date, cantidad: Int, costoUnitario: Double, igv: Double, total: Double,
         alCredito: Bool, vence: Date?, estado: EstadoCompra,
         comprador: Usuario?, proveedor: Proveedor?, producto: Producto?) {
        self.fecha = fecha
        self.cantidad = cantidad
        self.costoUnitario = costoUnitario
        self.igv = igv
        self.total = total
        self.alCredito = alCredito
        self.vence = vence
        self.estado = estado.rawValue
        self.pagada = false
        self.motivoRechazo = nil
        self.comprador = comprador
        self.proveedor = proveedor
        self.producto = producto
    }

    var estadoCompra: EstadoCompra {
        get { EstadoCompra(rawValue: estado) ?? .pendiente }
        set { estado = newValue.rawValue }
    }

    var subtotal: Double { ReglasCompra.redondear(Double(cantidad) * costoUnitario) }

    /// Crédito aprobado, sin pagar y con la fecha de vencimiento ya pasada.
    var estaVencida: Bool {
        guard alCredito, estadoCompra == .aprobada, !pagada, let vence else { return false }
        return vence < .now
    }
}
