//
//  Proveedor.swift
//  apple_lab11_B_Compras
//
//  Created by Jason on 17/11/26.
//

import Foundation
import SwiftData

@Model
class Proveedor {
    var nombre: String
    var ruc: String

    // Deny: no se puede borrar un proveedor que tiene compras
    @Relationship(deleteRule: .deny, inverse: \Compra.proveedor)
    var compras: [Compra] = []

    init(nombre: String, ruc: String) {
        self.nombre = nombre
        self.ruc = ruc
    }

    // ---- Valores calculados con las compras (no se guardan en la base) ----

    // Solo cuentan las compras aprobadas
    var comprasAprobadas: [Compra] {
        return compras.filter { $0.estado == "Aprobada" }
    }

    // Total comprado = suma de los totales de las compras aprobadas
    var totalComprado: Double {
        var suma = 0.0
        for compra in comprasAprobadas {
            suma += compra.total
        }
        return suma
    }

    // Compras a crédito que todavía no se pagaron
    var comprasPorPagar: [Compra] {
        return comprasAprobadas.filter { $0.alCredito && !$0.pagada }
    }
}
