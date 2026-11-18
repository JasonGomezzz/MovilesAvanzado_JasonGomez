//
//  ResumenView.swift
//  apple_lab11_B_Compras
//
//  Created by Jason on 17/11/26.
//

import SwiftUI
import SwiftData
import Charts   // Swift Charts: valor agregado del trabajo

// B9 · Resumen del supervisor: cifras del negocio y dos gráficos (por proveedor y por mes)
struct ResumenView: View {
    @Query private var compras: [Compra]
    @Query private var productos: [Producto]
    @Query(sort: \Proveedor.nombre) private var proveedores: [Proveedor]

    private var aprobadas: [Compra] {
        return compras.filter { $0.estado == "Aprobada" }
    }

    private var pendientes: [Compra] {
        return compras.filter { $0.estado == "Pendiente" }
    }

    // Suma de stock × costo promedio de todos los productos
    private var inventario: Double {
        var suma = 0.0
        for producto in productos { suma += producto.valorInventario }
        return suma
    }

    // El IGV de las compras aprobadas es crédito fiscal
    private var creditoFiscal: Double {
        var suma = 0.0
        for compra in aprobadas { suma += compra.igv }
        return suma
    }

    // Aprobadas, a crédito y sin pagar
    private var porPagar: Double {
        var suma = 0.0
        for compra in aprobadas where compra.alCredito && !compra.pagada { suma += compra.total }
        return suma
    }

    private var importePendiente: Double {
        var suma = 0.0
        for compra in pendientes { suma += compra.total }
        return suma
    }

    // Total comprado por cada proveedor, calculado con las compras aprobadas de la consulta.
    // (Se hace aquí y no con proveedor.compras porque la consulta sí se refresca sola en esta pantalla)
    private var totalesPorProveedor: [(nombre: String, total: Double)] {
        var resultado: [(nombre: String, total: Double)] = []
        for proveedor in proveedores {
            var suma = 0.0
            for compra in aprobadas where compra.proveedor?.persistentModelID == proveedor.persistentModelID {
                suma += compra.total
            }
            resultado.append((proveedor.nombre, suma))
        }
        return resultado
    }

    // Total aprobado de los últimos 6 meses (para el gráfico de líneas)
    private var totalesPorMes: [(mes: Date, total: Double)] {
        let calendario = Calendar.current
        let inicioMesActual = calendario.dateInterval(of: .month, for: Date())?.start ?? Date()
        var resultado: [(mes: Date, total: Double)] = []
        for atras in stride(from: 5, through: 0, by: -1) {
            let mes = calendario.date(byAdding: .month, value: -atras, to: inicioMesActual) ?? inicioMesActual
            var suma = 0.0
            for compra in aprobadas where calendario.isDate(compra.fecha, equalTo: mes, toGranularity: .month) {
                suma += compra.total
            }
            resultado.append((mes, suma))
        }
        return resultado
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        Tarjeta(titulo: "Inventario", valor: soles(inventario), nota: "")
                        Tarjeta(titulo: "Crédito fiscal", valor: soles(creditoFiscal), nota: "IGV de compras")
                    }
                    HStack(spacing: 12) {
                        Tarjeta(titulo: "Por pagar", valor: soles(porPagar), nota: "")
                        Tarjeta(titulo: "Por aprobar", valor: "\(pendientes.count)", nota: soles(importePendiente))
                    }

                    // Gráfico 1: barras horizontales, total comprado por proveedor
                    VStack(alignment: .leading) {
                        Text("Total comprado por proveedor").font(.headline)
                        Chart(totalesPorProveedor, id: \.nombre) { fila in
                            BarMark(x: .value("Total", fila.total),
                                    y: .value("Proveedor", fila.nombre))
                                .foregroundStyle(Color.teal)
                                .annotation(position: .trailing) {
                                    Text(soles(fila.total)).font(.caption)
                                }
                        }
                        .chartXAxis(.hidden)
                        .frame(height: 150)
                    }
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                    // Gráfico 2: línea con el total aprobado de cada mes
                    VStack(alignment: .leading) {
                        Text("Compras por mes").font(.headline)
                        Chart {
                            ForEach(totalesPorMes, id: \.mes) { punto in
                                LineMark(x: .value("Mes", punto.mes, unit: .month),
                                         y: .value("Total", punto.total))
                                    .foregroundStyle(Color.teal)
                                PointMark(x: .value("Mes", punto.mes, unit: .month),
                                          y: .value("Total", punto.total))
                                    .foregroundStyle(Color.orange)
                            }
                        }
                        .chartXAxis {
                            AxisMarks(values: .stride(by: .month)) { _ in
                                AxisGridLine()
                                AxisValueLabel(format: .dateTime.month(.abbreviated).locale(Locale(identifier: "es_PE")))
                            }
                        }
                        .frame(height: 170)
                    }
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Resumen")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    MenuAvatar()
                }
            }
        }
    }
}

// Cuadro con un indicador del resumen
struct Tarjeta: View {
    let titulo: String
    let valor: String
    let nota: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(titulo).font(.caption).foregroundStyle(.secondary)
            Text(valor).font(.title3.bold()).minimumScaleFactor(0.7).lineLimit(1)
            Text(nota.isEmpty ? " " : nota).font(.caption).foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
