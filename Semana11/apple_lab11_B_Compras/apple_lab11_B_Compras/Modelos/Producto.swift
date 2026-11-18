//
//  Producto.swift
//  apple_lab11_B_Compras
//
//  Created by Jason on 17/11/26.
//

import Foundation
import SwiftData

@Model
class Producto {
    var nombre: String
    var categoria: String
    var stock: Int
    var costoPromedio: Double

    // Deny: no se puede borrar un producto que tiene compras
    @Relationship(deleteRule: .deny, inverse: \Compra.producto)
    var compras: [Compra] = []

    init(nombre: String, categoria: String, stock: Int, costoPromedio: Double) {
        self.nombre = nombre
        self.categoria = categoria
        self.stock = stock
        self.costoPromedio = costoPromedio
    }

    // Valor en inventario = stock × costo promedio
    var valorInventario: Double {
        return Double(stock) * costoPromedio
    }

    // Costo promedio ponderado si entrara esta compra (no cambia nada, solo calcula)
    // nuevo = (stock actual × costo promedio + cantidad × costo unitario) / (stock actual + cantidad)
    func costoPromedioConCompra(cantidad: Int, costoUnitario: Double) -> Double {
        let unidades = stock + cantidad
        if unidades == 0 { return costoUnitario }
        let valorActual = Double(stock) * costoPromedio
        let valorCompra = Double(cantidad) * costoUnitario
        return (valorActual + valorCompra) / Double(unidades)
    }

    // Aplica la compra al producto: sube el stock y recalcula el costo promedio
    func recibir(cantidad: Int, costoUnitario: Double) {
        // OJO: primero el costo (usa el stock anterior) y después el stock
        costoPromedio = costoPromedioConCompra(cantidad: cantidad, costoUnitario: costoUnitario)
        stock += cantidad
    }
}
