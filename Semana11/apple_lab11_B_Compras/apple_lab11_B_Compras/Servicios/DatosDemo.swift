import Foundation
import SwiftData

/// Datos de apoyo para probar la app sin escribir todo a mano.
enum DatosDemo {

    /// Catálogo inicial: 4 productos y 3 proveedores. Solo se crea si la base está vacía.
    /// No crea usuarios: cada persona se registra con su propia cuenta.
    static func sembrarCatalogoSiVacio(en contexto: ModelContext) {
        let hayProductos = ((try? contexto.fetchCount(FetchDescriptor<Producto>())) ?? 0) > 0
        let hayProveedores = ((try? contexto.fetchCount(FetchDescriptor<Proveedor>())) ?? 0) > 0
        guard !hayProductos, !hayProveedores else { return }

        let productos = [
            Producto(nombre: "Laptop Pro 14", categoria: "Laptops", stock: 40, costoPromedio: 110),
            Producto(nombre: "Monitor 24\"", categoria: "Monitores", stock: 9, costoPromedio: 300),
            Producto(nombre: "Mouse inalámbrico", categoria: "Accesorios", stock: 120, costoPromedio: 18.5),
            Producto(nombre: "Teclado mecánico", categoria: "Accesorios", stock: 4, costoPromedio: 80)
        ]
        let proveedores = [
            Proveedor(nombre: "Dist. Lima SAC", ruc: "20481230011"),
            Proveedor(nombre: "TecnoImport EIRL", ruc: "20551230012"),
            Proveedor(nombre: "Mayorista Sur SAC", ruc: "20601230013")
        ]
        productos.forEach(contexto.insert)
        proveedores.forEach(contexto.insert)
        contexto.guardar()
    }

    private enum Desenlace {
        case aprobada          // si pasa de S/ 5,000 la aprueba el supervisor
        case pagada            // aprobada y además pagada
        case pendiente         // se queda esperando al supervisor
        case rechazada(String)
    }

    private struct Movimiento {
        let diasAtras: Int
        let proveedor: String
        let producto: String
        let cantidad: Int
        let costo: Double
        let credito: Bool
        let desenlace: Desenlace
    }

    /// Historial de ejemplo de los últimos 6 meses, hecho con las mismas reglas que la app real.
    /// Sirve para ver los gráficos del Resumen, las cuentas vencidas y las compras pendientes.
    static func cargarHistorial(por supervisor: Usuario, en contexto: ModelContext) {
        let proveedores = (try? contexto.fetch(FetchDescriptor<Proveedor>())) ?? []
        let productos = (try? contexto.fetch(FetchDescriptor<Producto>())) ?? []

        let movimientos: [Movimiento] = [
            .init(diasAtras: 160, proveedor: "Dist. Lima SAC", producto: "Laptop Pro 14", cantidad: 20, costo: 105, credito: false, desenlace: .aprobada),
            .init(diasAtras: 130, proveedor: "TecnoImport EIRL", producto: "Monitor 24\"", cantidad: 10, costo: 290, credito: true, desenlace: .pagada),
            .init(diasAtras: 100, proveedor: "Mayorista Sur SAC", producto: "Mouse inalámbrico", cantidad: 150, costo: 17.5, credito: true, desenlace: .pagada),
            .init(diasAtras: 75, proveedor: "Dist. Lima SAC", producto: "Laptop Pro 14", cantidad: 30, costo: 112, credito: true, desenlace: .aprobada),
            .init(diasAtras: 55, proveedor: "TecnoImport EIRL", producto: "Teclado mecánico", cantidad: 40, costo: 78, credito: false, desenlace: .aprobada),
            .init(diasAtras: 40, proveedor: "Dist. Lima SAC", producto: "Laptop Pro 14", cantidad: 50, costo: 118, credito: true, desenlace: .pagada),
            .init(diasAtras: 28, proveedor: "Mayorista Sur SAC", producto: "Mouse inalámbrico", cantidad: 200, costo: 18, credito: true, desenlace: .aprobada),
            .init(diasAtras: 12, proveedor: "TecnoImport EIRL", producto: "Monitor 24\"", cantidad: 15, costo: 295, credito: true, desenlace: .aprobada),
            .init(diasAtras: 5, proveedor: "Dist. Lima SAC", producto: "Teclado mecánico", cantidad: 60, costo: 82, credito: false, desenlace: .pendiente),
            .init(diasAtras: 2, proveedor: "Mayorista Sur SAC", producto: "Mouse inalámbrico", cantidad: 400, costo: 19, credito: true, desenlace: .rechazada("Precio por encima del mercado")),
            .init(diasAtras: 1, proveedor: "Dist. Lima SAC", producto: "Laptop Pro 14", cantidad: 10, costo: 120, credito: true, desenlace: .aprobada)
        ]

        for paso in movimientos {
            guard let proveedor = proveedores.first(where: { $0.nombre == paso.proveedor }),
                  let producto = productos.first(where: { $0.nombre == paso.producto }),
                  let fecha = Calendar.current.date(byAdding: .day, value: -paso.diasAtras, to: .now),
                  let compra = try? ReglasCompra.registrar(comprador: supervisor, proveedor: proveedor,
                                                           producto: producto, cantidad: paso.cantidad,
                                                           costoUnitario: paso.costo, alCredito: paso.credito,
                                                           fecha: fecha, en: contexto)
            else { continue }

            switch paso.desenlace {
            case .aprobada:
                try? ReglasCompra.aprobar(compra, por: supervisor, en: contexto)
            case .pagada:
                try? ReglasCompra.aprobar(compra, por: supervisor, en: contexto)
                try? ReglasCompra.pagar(compra, por: supervisor, en: contexto)
            case .pendiente:
                break
            case .rechazada(let motivo):
                try? ReglasCompra.rechazar(compra, motivo: motivo, por: supervisor, en: contexto)
            }
        }
    }
}
