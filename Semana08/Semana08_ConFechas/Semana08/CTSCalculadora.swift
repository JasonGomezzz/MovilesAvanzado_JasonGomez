//
//  CTSCalculadora.swift
//  Semana08
//
//  Lógica de la CTS (D.S. 001-97-TR) y de las fechas del semestre.
//  Los meses y días se calculan solos a partir de las fechas.
//

import Foundation

/// Semestre de la CTS y la gratificación que se toma como base
enum SemestreCTS: String, CaseIterable, Identifiable {
    case novAbr = "Nov – Abr"
    case mayOct = "May – Oct"
    var id: String { rawValue }
    var deposito: String { self == .novAbr ? "15 de mayo" : "15 de noviembre" }
    /// Gratificación más reciente al cierre del semestre
    var gratificacion: String { self == .novAbr ? "diciembre" : "julio" }

    /// Período de la CTS. `anio` es el año en que inicia el semestre
    /// (Nov – Abr 2025 va del 01/11/2025 al 30/04/2026).
    func periodoCTS(anio: Int) -> (inicio: Date, fin: Date) {
        switch self {
        case .novAbr: return (Fechas.fecha(anio, 11, 1), Fechas.fecha(anio + 1, 4, 30))
        case .mayOct: return (Fechas.fecha(anio, 5, 1), Fechas.fecha(anio, 10, 31))
        }
    }

    /// Período que cubre la gratificación usada (diciembre: jul–dic, julio: ene–jun)
    func periodoGratificacion(anio: Int) -> (inicio: Date, fin: Date) {
        switch self {
        case .novAbr: return (Fechas.fecha(anio, 7, 1), Fechas.fecha(anio, 12, 31))
        case .mayOct: return (Fechas.fecha(anio, 1, 1), Fechas.fecha(anio, 6, 30))
        }
    }
}

/// Tipo de trabajo extra que ingresa el usuario
enum TipoExtra: String, CaseIterable, Identifiable {
    case horas = "Horas extras"
    case dias = "Días extras"
    var id: String { rawValue }
    var nota: String {
        self == .horas ? "Las 2 primeras horas del día se pagan con 25% de recargo y desde la tercera con 35%"
                       : "Cada día extra se paga doble (100% de recargo)"
    }
}

/// Tiempo de servicio dentro de un período, contado en meses y días de 30
struct TiempoServicio {
    let meses: Int
    let dias: Int
}

enum Fechas {
    static let calendario = Calendar(identifier: .gregorian)

    static func fecha(_ a: Int, _ m: Int, _ d: Int) -> Date {
        calendario.date(from: DateComponents(year: a, month: m, day: d))!
    }

    /// Días entre dos fechas con base 30/360 (cada mes cuenta 30 días).
    /// `hasta` es exclusivo: para contar hasta el 30/04 se pasa el 01/05.
    static func dias360(desde: Date, hasta: Date) -> Int {
        let a = calendario.dateComponents([.year, .month, .day], from: desde)
        let b = calendario.dateComponents([.year, .month, .day], from: hasta)
        return (b.year! - a.year!) * 360 + (b.month! - a.month!) * 30
            + (min(b.day!, 30) - min(a.day!, 30))
    }

    /// Meses y días trabajados en el período. Si dejó de trabajar (`cese`), el período
    /// termina ese día. Devuelve nil si ingresó después del cierre o cesó antes del inicio.
    static func servicio(ingreso: Date, inicio: Date, fin: Date, cese: Date? = nil) -> TiempoServicio? {
        let ingresoDia = calendario.startOfDay(for: ingreso)
        var finEfectivo = fin
        if let cese { finEfectivo = min(fin, calendario.startOfDay(for: cese)) }
        guard ingresoDia <= finEfectivo, finEfectivo >= inicio else { return nil }
        let desde = max(ingresoDia, inicio)
        let hastaExclusivo = calendario.date(byAdding: .day, value: 1, to: finEfectivo)!
        let total = max(dias360(desde: desde, hasta: hastaExclusivo), 0)
        let meses = min(total / 30, CTSCalculadora.mesesSemestre)
        let dias = meses >= CTSCalculadora.mesesSemestre ? 0 : total % 30
        return TiempoServicio(meses: meses, dias: dias)
    }
}

struct ResultadoCTS {
    let asignacionFamiliar: Double
    let gratificacion: Double
    let promedioExtras: Double
    let sextoGratificacion: Double
    let remuneracionComputable: Double
    let montoPorMeses: Double
    let montoPorDias: Double
    let descuentoDias: Double
    let total: Double
}

enum CTSCalculadora {
    static let mesesSemestre = 6
    /// Horas o días extras: entran a la base si se recibieron en al menos 3 meses
    static let mesesMinimosExtras = 3
    static let diasPorMes = 30.0
    static let horasPorDia = 8.0
    static let recargoHorasIniciales = 0.25   // 2 primeras horas del día
    static let recargoHorasAdicionales = 0.35 // desde la tercera hora
    static let recargoDias = 1.0
    /// Máximo de sobretiempo por semana
    static let horasExtrasSemanales = 12.0
    /// Remuneración mínima vital y asignación familiar (10%); verificar el valor vigente
    static let rmv = 1230.0
    static let porcentajeAsignacion = 0.10
    static var asignacionFamiliar: Double { rmv * porcentajeAsignacion }

    /// Pago en soles de las extras. Valor del día = sueldo / 30; valor de la hora = día / 8.
    static func montoExtras(tipo: TipoExtra, horasIniciales: Double, horasAdicionales: Double,
                            dias: Double, sueldo: Double) -> Double {
        let valorDia = sueldo / diasPorMes
        let valorHora = valorDia / horasPorDia
        switch tipo {
        case .horas:
            return max(horasIniciales, 0) * valorHora * (1 + recargoHorasIniciales)
                 + max(horasAdicionales, 0) * valorHora * (1 + recargoHorasAdicionales)
        case .dias:
            return max(dias, 0) * valorDia * (1 + recargoDias)
        }
    }

    /// Si hubo extras en al menos 3 meses se suma 1/6 del total pagado; si no, 0.
    static func promedioExtras(total: Double, mesesConExtras: Int) -> Double {
        mesesConExtras >= mesesMinimosExtras ? max(total, 0) / Double(mesesSemestre) : 0
    }

    /// Gratificación = (sueldo + asignación familiar + promedio de extras) × meses trabajados / 6
    /// Con 6 meses completos equivale a una remuneración.
    static func gratificacion(sueldo: Double, asignacionFamiliar: Double,
                              promedioExtras: Double, mesesGratificacion: Int) -> Double {
        let m = min(max(mesesGratificacion, 0), mesesSemestre)
        return (sueldo + asignacionFamiliar + promedioExtras) * Double(m) / Double(mesesSemestre)
    }

    /// CTS = (Rem. computable / 12) × meses + (Rem. computable / 12 / 30) × días − (faltas + licencias)
    /// Rem. computable = sueldo + asignación familiar + promedio de extras + 1/6 de la gratificación
    static func calcular(sueldo: Double,
                         asignacionFamiliar: Double,
                         extrasTotal: Double,
                         mesesConExtras: Int,
                         mesesGratificacion: Int,
                         meses: Int,
                         dias: Int,
                         diasDescontados: Int) -> ResultadoCTS {
        let extras = promedioExtras(total: extrasTotal, mesesConExtras: mesesConExtras)
        let grat = gratificacion(sueldo: sueldo,
                                 asignacionFamiliar: asignacionFamiliar,
                                 promedioExtras: extras,
                                 mesesGratificacion: mesesGratificacion)
        let sexto = grat / 6
        let computable = sueldo + asignacionFamiliar + extras + sexto
        let porMes = computable / 12
        let porDia = porMes / 30
        let montoMeses = porMes * Double(min(max(meses, 0), mesesSemestre))
        let montoDias = porDia * Double(max(dias, 0))
        let descuento = porDia * Double(max(diasDescontados, 0))
        let total = max(montoMeses + montoDias - descuento, 0)
        return ResultadoCTS(asignacionFamiliar: asignacionFamiliar,
                            gratificacion: grat,
                            promedioExtras: extras,
                            sextoGratificacion: sexto,
                            remuneracionComputable: computable,
                            montoPorMeses: montoMeses,
                            montoPorDias: montoDias,
                            descuentoDias: descuento,
                            total: total)
    }
}
