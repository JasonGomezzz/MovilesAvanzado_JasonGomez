//
//  DatosIniciales.swift
//  apple_lab11_B_Compras
//
//  Created by Jason on 17/11/26.
//

import Foundation
import SwiftData

// Datos de apoyo para probar la app sin escribir todo a mano
class DatosIniciales {

    // Catálogo inicial (solo se crea si la base está vacía). No crea usuarios.
    static func cargarCatalogo(contexto: ModelContext) {
        let hayProductos = ((try? contexto.fetchCount(FetchDescriptor<Producto>())) ?? 0) > 0
        if hayProductos { return }

        contexto.insert(Producto(nombre: "Laptop Pro 14", categoria: "Laptops", stock: 40, costoPromedio: 110))
        contexto.insert(Producto(nombre: "Monitor 24\"", categoria: "Monitores", stock: 9, costoPromedio: 300))
        contexto.insert(Producto(nombre: "Mouse inalámbrico", categoria: "Accesorios", stock: 120, costoPromedio: 18.5))
        contexto.insert(Producto(nombre: "Teclado mecánico", categoria: "Accesorios", stock: 4, costoPromedio: 80))

        contexto.insert(Proveedor(nombre: "Dist. Lima SAC", ruc: "20481230011"))
        contexto.insert(Proveedor(nombre: "TecnoImport EIRL", ruc: "20551230012"))
        contexto.insert(Proveedor(nombre: "Mayorista Sur SAC", ruc: "20601230013"))
        try? contexto.save()
    }

    // Compras de ejemplo de los últimos meses para ver los gráficos del Resumen.
    // Cada una pasa por las mismas reglas que una compra normal.
    static func cargarCompras(comprador: Usuario, contexto: ModelContext) {
        let proveedores = (try? contexto.fetch(FetchDescriptor<Proveedor>())) ?? []
        let productos = (try? contexto.fetch(FetchDescriptor<Producto>())) ?? []

        // OJO: la consulta no garantiza ningún orden, por eso se busca cada uno por su nombre
        func proveedor(_ nombre: String) -> Proveedor? {
            return proveedores.first { $0.nombre == nombre }
        }
        func producto(_ nombre: String) -> Producto? {
            return productos.first { $0.nombre == nombre }
        }

        // (días atrás, proveedor, producto, cantidad, costo, crédito, pagada)
        let ejemplos: [(Int, String, String, Int, Double, Bool, Bool)] = [
            (150, "Dist. Lima SAC", "Laptop Pro 14", 20, 105, false, true),
            (120, "TecnoImport EIRL", "Monitor 24\"", 10, 290, true, true),
            (95, "Mayorista Sur SAC", "Mouse inalámbrico", 150, 17.5, true, true),
            (70, "Dist. Lima SAC", "Laptop Pro 14", 30, 112, true, false),
            (50, "TecnoImport EIRL", "Teclado mecánico", 40, 78, false, true),
            (35, "Dist. Lima SAC", "Laptop Pro 14", 50, 118, true, true),
            (22, "Mayorista Sur SAC", "Mouse inalámbrico", 200, 18, true, false),
            (10, "TecnoImport EIRL", "Monitor 24\"", 15, 295, true, false),
            (3, "Dist. Lima SAC", "Laptop Pro 14", 10, 120, true, false)
        ]

        for ejemplo in ejemplos {
            guard let elProveedor = proveedor(ejemplo.1), let elProducto = producto(ejemplo.2) else { continue }
            let fecha = Calendar.current.date(byAdding: .day, value: -ejemplo.0, to: Date()) ?? Date()
            let compra = Compra(fecha: fecha, cantidad: ejemplo.3, costoUnitario: ejemplo.4,
                                alCredito: ejemplo.5, comprador: comprador,
                                proveedor: elProveedor, producto: elProducto)
            contexto.insert(compra)
            // Son compras del pasado: se dejan aprobadas (y pagadas si corresponde)
            compra.aprobar()
            if ejemplo.6 { compra.pagar() }
        }

        // Una compra grande que queda pendiente y otra rechazada
        if let lima = proveedor("Dist. Lima SAC"), let teclado = producto("Teclado mecánico") {
            contexto.insert(Compra(cantidad: 60, costoUnitario: 82, alCredito: false,
                                   comprador: comprador, proveedor: lima, producto: teclado))
        }
        if let sur = proveedor("Mayorista Sur SAC"), let mouse = producto("Mouse inalámbrico") {
            let rechazada = Compra(cantidad: 400, costoUnitario: 19, alCredito: true,
                                   comprador: comprador, proveedor: sur, producto: mouse)
            contexto.insert(rechazada)
            rechazada.rechazar(motivo: "Precio por encima del mercado")
        }

        try? contexto.save()
    }
}
