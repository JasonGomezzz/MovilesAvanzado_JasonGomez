import SwiftData
import SwiftUI

enum SegmentoPago: String, CaseIterable, Identifiable {
    case pendientes = "Pendientes"
    case vencidas = "Vencidas"
    case pagadas = "Pagadas"

    var id: String { rawValue }
}

/// B8 · Por pagar. Cuentas por pagar de las compras aprobadas a crédito; solo el supervisor paga.
struct PorPagarView: View {
    @State private var segmento: SegmentoPago = .pendientes
    @State private var busqueda = ""

    /// Toda la deuda, sin importar el segmento ni la búsqueda: es el total del pie de la pantalla.
    @Query(filter: #Predicate<Compra> { $0.estado == "Aprobada" && $0.alCredito && !$0.pagada })
    private var deuda: [Compra]

    private var totalPorPagar: Double { deuda.reduce(0) { $0 + $1.total } }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Segmento", selection: $segmento) {
                    ForEach(SegmentoPago.allCases) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.vertical, 8)

                ListaPorPagar(segmento: segmento, busqueda: busqueda)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Por pagar")
            .searchable(text: $busqueda, prompt: "Buscar proveedor")
            .toolbar { ToolbarItem(placement: .topBarTrailing) { MenuCuenta() } }
            .safeAreaInset(edge: .bottom) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Total por pagar")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    Text(Formato.soles(totalPorPagar))
                        .font(.system(.title2, design: .rounded, weight: .bold))
                        .monospacedDigit()
                    Text("Solo cuentan compras aprobadas a crédito y no pagadas.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .tarjeta()
                .padding(.horizontal)
                .padding(.bottom, 8)
                .background(.bar)
            }
        }
    }
}

/// El filtro por segmento y por proveedor se hace dentro de la consulta con #Predicate.
private struct ListaPorPagar: View {
    @Environment(Sesion.self) private var sesion
    @Environment(\.modelContext) private var contexto

    @Query private var compras: [Compra]
    private let segmento: SegmentoPago

    @State private var aviso: AvisoAlerta?
    @State private var pagos = 0

    init(segmento: SegmentoPago, busqueda: String) {
        self.segmento = segmento
        let texto = busqueda.trimmingCharacters(in: .whitespaces)
        let ahora = Date.now

        let predicado: Predicate<Compra>
        switch segmento {
        case .pendientes:
            predicado = #Predicate<Compra> {
                $0.estado == "Aprobada" && $0.alCredito && !$0.pagada
                    && (texto.isEmpty || ($0.proveedor?.nombre.localizedStandardContains(texto) ?? false))
            }
        case .vencidas:
            predicado = #Predicate<Compra> {
                $0.estado == "Aprobada" && $0.alCredito && !$0.pagada
                    && ($0.vence ?? ahora) < ahora
                    && (texto.isEmpty || ($0.proveedor?.nombre.localizedStandardContains(texto) ?? false))
            }
        case .pagadas:
            predicado = #Predicate<Compra> {
                $0.estado == "Aprobada" && $0.alCredito && $0.pagada
                    && (texto.isEmpty || ($0.proveedor?.nombre.localizedStandardContains(texto) ?? false))
            }
        }
        // Se ordena por fecha: el vencimiento es siempre la fecha + 30 días.
        _compras = Query(filter: predicado, sort: \Compra.fecha,
                         order: segmento == .pagadas ? .reverse : .forward)
    }

    var body: some View {
        List {
            ForEach(compras) { compra in
                FilaPorPagar(compra: compra)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        if segmento != .pagadas {
                            Button("Pagar", systemImage: "checkmark.circle") { pagar(compra) }
                                .tint(Color.correcto)
                        }
                    }
            }
        }
        .contentMargins(.top, 4, for: .scrollContent)
        .overlay {
            if compras.isEmpty {
                ContentUnavailableView(vacioTitulo, systemImage: "creditcard",
                                       description: Text(vacioDetalle))
            }
        }
        .alert(item: $aviso) { Alert(title: Text($0.titulo), message: Text($0.mensaje)) }
        .sensoryFeedback(.success, trigger: pagos)
    }

    private var vacioTitulo: String {
        switch segmento {
        case .pendientes: "Sin cuentas pendientes"
        case .vencidas: "Sin cuentas vencidas"
        case .pagadas: "Sin pagos registrados"
        }
    }

    private var vacioDetalle: String {
        segmento == .pagadas ? "Las compras que pagues aparecerán aquí." : "Todo al día."
    }

    private func pagar(_ compra: Compra) {
        guard let supervisor = sesion.usuario else { return }
        do {
            try ReglasCompra.pagar(compra, por: supervisor, en: contexto)
            pagos += 1
        } catch {
            aviso = AvisoAlerta(titulo: "No se pudo pagar", mensaje: error.localizedDescription)
        }
    }
}

private struct FilaPorPagar: View {
    let compra: Compra

    var body: some View {
        HStack(spacing: 12) {
            Avatar(texto: compra.proveedor?.nombre ?? "?")
            VStack(alignment: .leading, spacing: 2) {
                Text(compra.proveedor?.nombre ?? "Proveedor eliminado")
                    .font(.body.weight(.semibold))
                    .lineLimit(1)
                Text("\(compra.producto?.nombre ?? "Producto") × \(compra.cantidad)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                if !compra.pagada, let vence = compra.vence {
                    Text("Vence \(Formato.fechaCorta(vence))")
                        .font(.caption)
                        .foregroundStyle(compra.estaVencida ? Color.peligro : .secondary)
                }
            }
            Spacer(minLength: 8)
            VStack(alignment: .trailing, spacing: 4) {
                Text(Formato.soles(compra.total))
                    .font(.subheadline.weight(.semibold))
                    .monospacedDigit()
                if compra.estaVencida {
                    Insignia(texto: "VENCIDA", color: .peligro)
                } else if compra.pagada {
                    Insignia(texto: "Pagada", color: .correcto)
                }
            }
        }
        .padding(.vertical, 2)
        .accessibilityElement(children: .combine)
    }
}
