import Charts
import SwiftData
import SwiftUI

/// B9 · Resumen del supervisor: cifras del negocio y, como valor agregado, gráficos con Swift Charts.
struct ResumenView: View {
    @Query private var compras: [Compra]
    @Query private var productos: [Producto]

    // MARK: Cifras (se calculan al vuelo desde las consultas)

    private var aprobadas: [Compra] { compras.filter { $0.estadoCompra == .aprobada } }
    private var pendientes: [Compra] { compras.filter { $0.estadoCompra == .pendiente } }

    private var inventario: Double { productos.reduce(0) { $0 + $1.valorInventario } }
    /// El IGV de las compras aprobadas es crédito fiscal: se descuenta del IGV de las ventas.
    private var creditoFiscal: Double { aprobadas.reduce(0) { $0 + $1.igv } }
    private var porPagar: Double { aprobadas.filter { $0.alCredito && !$0.pagada }.reduce(0) { $0 + $1.total } }
    private var importePendiente: Double { pendientes.reduce(0) { $0 + $1.total } }

    private var tieneDatos: Bool { !aprobadas.isEmpty }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 14) {
                    Grid(horizontalSpacing: 12, verticalSpacing: 12) {
                        GridRow {
                            Metrica(titulo: "Inventario", valor: Formato.soles(inventario))
                            Metrica(titulo: "Crédito fiscal", valor: Formato.soles(creditoFiscal),
                                    nota: "IGV de compras")
                        }
                        GridRow {
                            Metrica(titulo: "Por pagar", valor: Formato.soles(porPagar))
                            Metrica(titulo: "Por aprobar", valor: "\(pendientes.count)",
                                    nota: Formato.soles(importePendiente), color: .aviso)
                        }
                    }

                    if tieneDatos {
                        GraficoMensual(compras: aprobadas)
                        GraficoProveedores(compras: aprobadas)
                        GraficoCategorias(compras: aprobadas)
                    } else {
                        ContentUnavailableView("Aún no hay compras aprobadas", systemImage: "chart.bar",
                                               description: Text("Registra compras o carga el historial de ejemplo desde el menú de tu avatar."))
                            .tarjeta()
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Resumen")
            .toolbar { ToolbarItem(placement: .topBarTrailing) { MenuCuenta() } }
        }
    }
}

// MARK: - Tarjetas

private struct Metrica: View {
    let titulo: String
    let valor: String
    var nota: String?
    var color: Color = .primary

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(titulo.uppercased())
                .font(.caption2.weight(.semibold))
                .tracking(0.6)
                .foregroundStyle(.secondary)
            Text(valor)
                .font(.system(.title2, design: .rounded, weight: .bold))
                .monospacedDigit()
                .foregroundStyle(color)
                .minimumScaleFactor(0.7)
                .lineLimit(1)
            Text(nota ?? " ")
                .font(.caption)
                .foregroundStyle(.secondary)
                .monospacedDigit()
        }
        .tarjeta()
        .accessibilityElement(children: .combine)
    }
}

private struct TarjetaGrafico<Contenido: View>: View {
    let titulo: String
    let subtitulo: String
    @ViewBuilder var contenido: Contenido

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(titulo).font(.headline)
                Text(subtitulo).font(.footnote).foregroundStyle(.secondary)
            }
            contenido
        }
        .tarjeta()
    }
}

// MARK: - Gráficos

private struct GraficoMensual: View {
    let compras: [Compra]

    private struct Punto: Identifiable {
        let mes: Date
        let total: Double
        var id: Date { mes }
    }

    /// Los últimos 6 meses, incluidos los que no tuvieron compras (en cero).
    private var puntos: [Punto] {
        let calendario = Calendar.current
        let inicioActual = calendario.dateInterval(of: .month, for: .now)?.start ?? .now
        return (0..<6).reversed().compactMap { atras in
            guard let mes = calendario.date(byAdding: .month, value: -atras, to: inicioActual) else { return nil }
            let suma = compras
                .filter { calendario.isDate($0.fecha, equalTo: mes, toGranularity: .month) }
                .reduce(0) { $0 + $1.total }
            return Punto(mes: mes, total: suma)
        }
    }

    var body: some View {
        let datos = puntos
        let mesActual = datos.last?.mes
        TarjetaGrafico(titulo: "Compras por mes", subtitulo: "Total aprobado, últimos 6 meses") {
            Chart(datos) { punto in
                BarMark(x: .value("Mes", punto.mes, unit: .month),
                        y: .value("Total", punto.total))
                    .foregroundStyle(punto.mes == mesActual ? Color.marca : Color.marca.opacity(0.35))
                    .cornerRadius(4)
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .month)) { valor in
                    AxisValueLabel {
                        if let fecha = valor.as(Date.self) { Text(Formato.mes(fecha)) }
                    }
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) { valor in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                        .foregroundStyle(.quaternary)
                    AxisValueLabel {
                        if let numero = valor.as(Double.self) { Text(Formato.solesCompacto(numero)) }
                    }
                }
            }
            .frame(height: 180)
            .accessibilityLabel("Gráfico de barras: compras aprobadas por mes")
        }
    }
}

private struct GraficoProveedores: View {
    let compras: [Compra]

    private struct Barra: Identifiable {
        let proveedor: String
        let total: Double
        var id: String { proveedor }
    }

    private var barras: [Barra] {
        Dictionary(grouping: compras, by: { $0.proveedor?.nombre ?? "Sin proveedor" })
            .map { Barra(proveedor: $0.key, total: $0.value.reduce(0) { $0 + $1.total }) }
            .sorted { $0.total > $1.total }
    }

    var body: some View {
        let datos = barras
        TarjetaGrafico(titulo: "Total comprado por proveedor", subtitulo: "Compras aprobadas") {
            Chart(datos) { barra in
                BarMark(x: .value("Total", barra.total),
                        y: .value("Proveedor", barra.proveedor))
                    .foregroundStyle(Color.marca)
                    .cornerRadius(4)
                    .annotation(position: .trailing, spacing: 6) {
                        Text(Formato.solesCompacto(barra.total))
                            .font(.caption.weight(.semibold))
                            .monospacedDigit()
                            .foregroundStyle(.secondary)
                    }
            }
            .chartXAxis(.hidden)
            .chartXScale(domain: 0...((datos.map(\.total).max() ?? 1) * 1.25))
            .chartYAxis {
                AxisMarks { _ in AxisValueLabel().font(.footnote) }
            }
            .frame(height: CGFloat(datos.count) * 44 + 8)
            .accessibilityLabel("Gráfico de barras: total comprado por proveedor")
        }
    }
}

private struct GraficoCategorias: View {
    let compras: [Compra]

    private struct Porcion: Identifiable {
        let categoria: String
        let total: Double
        var id: String { categoria }
    }

    private var porciones: [Porcion] {
        Dictionary(grouping: compras, by: { $0.producto?.categoria ?? "Otros" })
            .map { Porcion(categoria: $0.key, total: $0.value.reduce(0) { $0 + $1.total }) }
            .sorted { $0.total > $1.total }
    }

    var body: some View {
        let datos = porciones
        let suma = datos.reduce(0) { $0 + $1.total }
        TarjetaGrafico(titulo: "Gasto por categoría", subtitulo: "Participación sobre el total aprobado") {
            HStack(alignment: .center, spacing: 16) {
                Chart(datos) { porcion in
                    SectorMark(angle: .value("Total", porcion.total),
                               innerRadius: .ratio(0.62),
                               angularInset: 1.5)
                        .cornerRadius(3)
                        .foregroundStyle(by: .value("Categoría", porcion.categoria))
                }
                .chartForegroundStyleScale(domain: datos.map(\.categoria),
                                           range: Array(Paleta.serie.prefix(max(datos.count, 1))))
                .chartLegend(.hidden)
                .frame(width: 140, height: 140)
                .accessibilityLabel("Gráfico circular: gasto por categoría")

                VStack(alignment: .leading, spacing: 8) {
                    ForEach(Array(datos.enumerated()), id: \.element.id) { indice, porcion in
                        HStack(spacing: 8) {
                            Circle()
                                .fill(Paleta.serie[indice % Paleta.serie.count])
                                .frame(width: 9, height: 9)
                            Text(porcion.categoria)
                                .font(.footnote)
                                .lineLimit(1)
                            Spacer(minLength: 4)
                            Text((porcion.total / max(suma, 1)).formatted(.percent.precision(.fractionLength(0))))
                                .font(.footnote.weight(.semibold))
                                .monospacedDigit()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    let contenedor = ModelContainerProvider.enMemoria()
    let contexto = contenedor.mainContext
    DatosDemo.sembrarCatalogoSiVacio(en: contexto)
    let lucia = Usuario(nombre: "Lucía Paredes", usuario: "lparedes", clave: "123456", rol: .supervisor)
    contexto.insert(lucia)
    DatosDemo.cargarHistorial(por: lucia, en: contexto)
    return ResumenView()
        .environment(Sesion())
        .modelContainer(contenedor)
}
