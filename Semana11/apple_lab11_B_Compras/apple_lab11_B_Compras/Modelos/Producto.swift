import Foundation
import SwiftData

@Model
final class Producto {
    var nombre: String
    var categoria: String
    var stock: Int
    /// Costo promedio ponderado; cambia cada vez que se aprueba una compra.
    var costoPromedio: Double

    /// Un producto con compras no se puede borrar (.deny).
    @Relationship(deleteRule: .deny, inverse: \Compra.producto)
    var compras: [Compra] = []

    init(nombre: String, categoria: String, stock: Int, costoPromedio: Double) {
        self.nombre = nombre
        self.categoria = categoria
        self.stock = stock
        self.costoPromedio = costoPromedio
    }

    /// Valor del producto en el inventario: stock × costo promedio.
    var valorInventario: Double { Double(stock) * costoPromedio }
}
