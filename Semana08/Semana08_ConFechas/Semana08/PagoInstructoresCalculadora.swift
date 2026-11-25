//
//  PagoInstructoresCalculadora.swift
//  Semana08
//
//  Lógica del pago de instructores (sueldo bruto, descuentos y neto).
//

import Foundation

enum SistemaPension: String, CaseIterable, Identifiable {
    case onp = "ONP (13%)"
    case afp = "AFP (10%)"
    var id: String { rawValue }
    var tasa: Double { self == .onp ? 0.13 : 0.10 }
}

struct ResultadoPago {
    let sueldoBruto: Double
    let pension: Double
    let impuestoRenta: Double
    let sueldoNeto: Double
    let essalud: Double
}

enum PagoInstructoresCalculadora {
    static let pagoPorHora = 50.0
    static let horasMaximas = 23.0
    static let semanasPorMes = 4.0
    static let tasaEssalud = 0.09
    // UIT de referencia; verificar el valor vigente del año
    static let uit = 5500.0

    /// Impuesto anual de 5ta categoría con los tramos de la ley
    static func impuestoAnual(rentaAnual: Double) -> Double {
        let neta = max(rentaAnual - 7 * uit, 0)
        let tramos: [(limite: Double, tasa: Double)] = [
            (5 * uit, 0.08), (20 * uit, 0.14), (35 * uit, 0.17), (45 * uit, 0.20), (.infinity, 0.30)
        ]
        var restante = neta
        var inferior = 0.0
        var impuesto = 0.0
        for t in tramos where restante > 0 {
            let ancho = t.limite - inferior
            let base = min(restante, ancho)
            impuesto += base * t.tasa
            restante -= base
            inferior = t.limite
        }
        return impuesto
    }

    /// Sueldo bruto, descuentos y neto. El ESSALUD (9%) lo paga el empleador y no reduce el neto.
    static func calcular(horasSemanales: Double, sistema: SistemaPension) -> ResultadoPago {
        let horas = min(max(horasSemanales, 0), horasMaximas)
        let bruto = horas * pagoPorHora * semanasPorMes
        let pension = bruto * sistema.tasa
        let irMensual = impuestoAnual(rentaAnual: bruto * 12) / 12
        return ResultadoPago(sueldoBruto: bruto,
                             pension: pension,
                             impuestoRenta: irMensual,
                             sueldoNeto: bruto - pension - irMensual,
                             essalud: bruto * tasaEssalud)
    }
}
