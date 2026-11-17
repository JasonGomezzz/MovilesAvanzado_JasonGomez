import Foundation
import SwiftData

/// Resultado de calcular una compra. Es un valor puro: no toca la base de datos.
struct DesgloseCompra {
    let subtotal: Double
    let igv: Double
    let total: Double

    init(cantidad: Int, costoUnitario: Double) {
        let base = ReglasCompra.redondear(Double(cantidad) * costoUnitario)
        let impuesto = ReglasCompra.redondear(base * ReglasCompra.tasaIGV)
        subtotal = base
        igv = impuesto
        total = ReglasCompra.redondear(base + impuesto)
    }

    /// Desde S/ 5,000 la compra necesita la aprobación del supervisor.
    var requiereAprobacion: Bool { total >= ReglasCompra.umbralAprobacion }
}

/// Lo que cambiaría en el producto si se aprueba una compra (vista previa de la pantalla B7).
struct EfectoPrevisto {
    let stockAntes: Int
    let stockDespues: Int
    let costoAntes: Double
    let costoDespues: Double
}

enum ErrorCompra: LocalizedError {
    case cantidadInvalida
    case costoInvalido
    case motivoObligatorio
    case estadoIncorrecto
    case soloSupervisor

    var errorDescription: String? {
        switch self {
        case .cantidadInvalida: "La cantidad debe ser mayor que cero."
        case .costoInvalido: "El costo unitario debe ser mayor que cero."
        case .motivoObligatorio: "Escribe el motivo del rechazo."
        case .estadoIncorrecto: "Esta compra ya no se puede modificar."
        case .soloSupervisor: "Solo un supervisor puede hacer esto."
        }
    }
}

/// Todas las reglas de negocio del caso Compras en un solo lugar,
/// para poder explicarlas y probarlas sin abrir ninguna pantalla.
enum ReglasCompra {
    static let tasaIGV = 0.18
    static let umbralAprobacion = 5_000.0
    static let diasDeCredito = 30

    /// Redondea a dos decimales (céntimos).
    static func redondear(_ valor: Double) -> Double {
        (valor * 100).rounded() / 100
    }

    /// nuevo = (stock × costo promedio + cantidad × costo unitario) / (stock + cantidad)
    static func costoPromedioPonderado(stock: Int, costoPromedio: Double,
                                       cantidad: Int, costoUnitario: Double) -> Double {
        let unidades = stock + cantidad
        guard unidades > 0 else { return costoUnitario }
        return (Double(stock) * costoPromedio + Double(cantidad) * costoUnitario) / Double(unidades)
    }

    static func efectoPrevisto(de compra: Compra) -> EfectoPrevisto? {
        guard let producto = compra.producto else { return nil }
        let nuevoCosto = costoPromedioPonderado(stock: producto.stock,
                                                costoPromedio: producto.costoPromedio,
                                                cantidad: compra.cantidad,
                                                costoUnitario: compra.costoUnitario)
        return EfectoPrevisto(stockAntes: producto.stock,
                              stockDespues: producto.stock + compra.cantidad,
                              costoAntes: producto.costoPromedio,
                              costoDespues: nuevoCosto)
    }

    /// Registra una compra. Si el total es menor a S/ 5,000 queda Aprobada al instante
    /// (con todos sus efectos); si no, queda Pendiente y no cambia nada más.
    @discardableResult
    static func registrar(comprador: Usuario, proveedor: Proveedor, producto: Producto,
                          cantidad: Int, costoUnitario: Double, alCredito: Bool,
                          fecha: Date = .now, en contexto: ModelContext) throws -> Compra {
        guard cantidad > 0 else { throw ErrorCompra.cantidadInvalida }
        guard costoUnitario > 0 else { throw ErrorCompra.costoInvalido }

        let desglose = DesgloseCompra(cantidad: cantidad, costoUnitario: costoUnitario)
        let vence = alCredito
            ? Calendar.current.date(byAdding: .day, value: diasDeCredito, to: fecha)
            : nil

        let compra = Compra(fecha: fecha, cantidad: cantidad, costoUnitario: costoUnitario,
                            igv: desglose.igv, total: desglose.total, alCredito: alCredito,
                            vence: vence, estado: .pendiente,
                            comprador: comprador, proveedor: proveedor, producto: producto)
        contexto.insert(compra)

        if !desglose.requiereAprobacion {
            aplicarAprobacion(compra)
        }
        contexto.guardar()
        return compra
    }

    /// El supervisor aprueba una compra pendiente: ahora sí cambian stock, costo promedio y cuentas.
    static func aprobar(_ compra: Compra, por usuario: Usuario, en contexto: ModelContext) throws {
        guard usuario.esSupervisor else { throw ErrorCompra.soloSupervisor }
        guard compra.estadoCompra == .pendiente else { throw ErrorCompra.estadoIncorrecto }
        aplicarAprobacion(compra)
        contexto.guardar()
    }

    /// El supervisor rechaza una compra pendiente. El motivo es obligatorio y no cambia nada más.
    static func rechazar(_ compra: Compra, motivo: String, por usuario: Usuario, en contexto: ModelContext) throws {
        guard usuario.esSupervisor else { throw ErrorCompra.soloSupervisor }
        guard compra.estadoCompra == .pendiente else { throw ErrorCompra.estadoIncorrecto }
        let texto = motivo.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !texto.isEmpty else { throw ErrorCompra.motivoObligatorio }
        compra.estadoCompra = .rechazada
        compra.motivoRechazo = texto
        contexto.guardar()
    }

    /// El supervisor marca una compra a crédito como pagada.
    static func pagar(_ compra: Compra, por usuario: Usuario, en contexto: ModelContext) throws {
        guard usuario.esSupervisor else { throw ErrorCompra.soloSupervisor }
        guard compra.estadoCompra == .aprobada, compra.alCredito, !compra.pagada else {
            throw ErrorCompra.estadoIncorrecto
        }
        compra.pagada = true
        contexto.guardar()
    }

    // MARK: - Privado

    private static func aplicarAprobacion(_ compra: Compra) {
        if let producto = compra.producto {
            producto.costoPromedio = costoPromedioPonderado(stock: producto.stock,
                                                            costoPromedio: producto.costoPromedio,
                                                            cantidad: compra.cantidad,
                                                            costoUnitario: compra.costoUnitario)
            producto.stock += compra.cantidad
        }
        compra.estadoCompra = .aprobada
        // Al contado se paga en el momento; a crédito queda por pagar.
        compra.pagada = !compra.alCredito
    }
}
