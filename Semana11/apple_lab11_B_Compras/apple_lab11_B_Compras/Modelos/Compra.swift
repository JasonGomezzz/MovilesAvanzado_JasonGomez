//
//  Compra.swift
//  apple_lab11_B_Compras
//
//  Created by Jason on 17/11/26.
//

import Foundation
import SwiftData

@Model
class Compra {
    var fecha: Date
    var cantidad: Int
    var costoUnitario: Double
    var igv: Double
    var total: Double
    var alCredito: Bool          // true = crédito a 30 días, false = contado
    var vence: Date?             // solo tiene valor si es a crédito
    var estado: String           // "Pendiente", "Aprobada" o "Rechazada"
    var pagada: Bool
    var motivoRechazo: String?

    // Relaciones (la inversa está declarada en Usuario, Proveedor y Producto)
    var comprador: Usuario?
    var proveedor: Proveedor?
    var producto: Producto?

    init(fecha: Date = Date(), cantidad: Int, costoUnitario: Double, alCredito: Bool,
         comprador: Usuario?, proveedor: Proveedor?, producto: Producto?) {
        self.fecha = fecha
        self.cantidad = cantidad
        self.costoUnitario = costoUnitario
        self.alCredito = alCredito
        self.comprador = comprador
        self.proveedor = proveedor
        self.producto = producto

        // El IGV y el total se calculan al crear la compra
        let calculo = Compra.calcular(cantidad: cantidad, costoUnitario: costoUnitario)
        self.igv = calculo.igv
        self.total = calculo.total

        // A crédito vence a los 30 días; al contado no vence
        if alCredito {
            self.vence = Calendar.current.date(byAdding: .day, value: 30, to: fecha)
        } else {
            self.vence = nil
        }
        self.estado = "Pendiente"
        self.pagada = false
        self.motivoRechazo = nil
    }

    // ---- Reglas de negocio ----

    static let limiteAprobacion = 5000.0   // desde este total necesita aprobación

    // Subtotal, IGV (18 %) y total, redondeados a 2 decimales
    static func calcular(cantidad: Int, costoUnitario: Double) -> (subtotal: Double, igv: Double, total: Double) {
        let subtotal = redondear(Double(cantidad) * costoUnitario)
        let igv = redondear(subtotal * 0.18)
        let total = redondear(subtotal + igv)
        return (subtotal, igv, total)
    }

    static func redondear(_ valor: Double) -> Double {
        return (valor * 100).rounded() / 100
    }

    var subtotal: Double {
        return Compra.redondear(Double(cantidad) * costoUnitario)
    }

    // Una compra menor a S/ 5,000 se aprueba sola
    var necesitaAprobacion: Bool {
        return total >= Compra.limiteAprobacion
    }

    // Aprobar: ahora sí cambian el stock y el costo promedio
    func aprobar() {
        producto?.recibir(cantidad: cantidad, costoUnitario: costoUnitario)
        estado = "Aprobada"
        pagada = !alCredito   // al contado queda pagada; a crédito queda por pagar
    }

    // Rechazar: guarda el motivo y no cambia nada más
    func rechazar(motivo: String) {
        estado = "Rechazada"
        motivoRechazo = motivo
    }

    // Pagar: solo tiene sentido en compras aprobadas a crédito
    func pagar() {
        pagada = true
    }

    // Vencida = a crédito, aprobada, sin pagar y con la fecha de vencimiento pasada
    var estaVencida: Bool {
        if estado == "Aprobada" && alCredito && !pagada, let fechaVence = vence {
            return fechaVence < Date()
        }
        return false
    }
}
