import SwiftData
import SwiftUI

enum FiltroCompra: String, CaseIterable, Identifiable {
    case todas = "Todas"
    case pendientes = "Pendientes"
    case rechazadas = "Rechazadas"

    var id: String { rawValue }

    func admite(_ compra: Compra) -> Bool {
        switch self {
        case .todas: true
        case .pendientes: compra.estadoCompra == .pendiente
        case .rechazadas: compra.estadoCompra == .rechazada
        }
    }
}

/// B6 · Mis compras. El comprador solo ve las suyas y no puede pagar ni aprobar.
struct MisComprasView: View {
    @Environment(Sesion.self) private var sesion
    @State private var filtro: FiltroCompra = .todas

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Filtro", selection: $filtro) {
                    ForEach(FiltroCompra.allCases) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.vertical, 8)

                if let usuario = sesion.usuario {
                    MisComprasLista(usuario: usuario.usuario, filtro: filtro)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Mis compras")
            .toolbar { ToolbarItem(placement: .topBarTrailing) { MenuCuenta() } }
        }
    }
}

/// La consulta @Query filtra por comprador con un #Predicate: la base solo entrega las compras de esta persona.
private struct MisComprasLista: View {
    @Query private var compras: [Compra]
    private let filtro: FiltroCompra
    @State private var seleccionada: Compra?

    init(usuario: String, filtro: FiltroCompra) {
        self.filtro = filtro
        _compras = Query(filter: #Predicate<Compra> { $0.comprador?.usuario == usuario },
                         sort: \Compra.fecha, order: .reverse)
    }

    private var visibles: [Compra] { compras.filter(filtro.admite) }

    var body: some View {
        List {
            Section {
                ForEach(visibles) { compra in
                    Button { seleccionada = compra } label: { FilaMiCompra(compra: compra) }
                        .buttonStyle(.plain)
                }
            } footer: {
                Text("El comprador solo ve sus compras; no puede pagar ni aprobar.")
                    .font(.footnote)
                    .padding(.top, 6)
                    .textCase(nil)
            }
        }
        .contentMargins(.top, 4, for: .scrollContent)
        .overlay {
            if visibles.isEmpty {
                ContentUnavailableView(compras.isEmpty ? "Aún no registras compras" : "Nada en \"\(filtro.rawValue)\"",
                                       systemImage: "list.bullet.rectangle",
                                       description: Text(compras.isEmpty ? "Ve a la pestaña Compra para registrar la primera." : ""))
            }
        }
        .sheet(item: $seleccionada) { DetalleCompraView(compra: $0) }
    }
}

private struct FilaMiCompra: View {
    let compra: Compra

    var body: some View {
        HStack(spacing: 12) {
            IconoEstado(estado: compra.estadoCompra)
            VStack(alignment: .leading, spacing: 2) {
                Text(compra.proveedor?.nombre ?? "Proveedor eliminado")
                    .font(.body.weight(.semibold))
                    .lineLimit(1)
                Text("\(compra.producto?.nombre ?? "Producto") × \(compra.cantidad) · \(Formato.fechaCorta(compra.fecha))")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                if compra.estadoCompra == .rechazada, let motivo = compra.motivoRechazo {
                    Text("Motivo: \(motivo)")
                        .font(.caption)
                        .foregroundStyle(Color.peligro)
                        .lineLimit(1)
                }
            }
            Spacer(minLength: 8)
            VStack(alignment: .trailing, spacing: 4) {
                Text(Formato.soles(compra.total))
                    .font(.subheadline.weight(.semibold))
                    .monospacedDigit()
                Insignia(texto: compra.estado, color: compra.estadoCompra.color)
            }
        }
        .contentShape(Rectangle())
        .padding(.vertical, 2)
    }
}

/// Detalle de solo lectura de una compra.
struct DetalleCompraView: View {
    let compra: Compra
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section {
                    LabeledContent("Proveedor", value: compra.proveedor?.nombre ?? "—")
                    LabeledContent("Producto", value: compra.producto?.nombre ?? "—")
                    LabeledContent("Registrada por", value: compra.comprador?.nombre ?? "—")
                    LabeledContent("Fecha", value: Formato.fechaCompleta(compra.fecha))
                }
                Section("Importes") {
                    LabeledContent("Cantidad", value: "\(compra.cantidad) u.")
                    LabeledContent("Costo unitario", value: Formato.soles(compra.costoUnitario))
                    LabeledContent("Subtotal", value: Formato.soles(compra.subtotal))
                    LabeledContent("IGV 18 %", value: Formato.soles(compra.igv))
                    LabeledContent("Total") {
                        Text(Formato.soles(compra.total)).fontWeight(.bold)
                    }
                }
                Section("Estado") {
                    LabeledContent("Estado") {
                        Insignia(texto: compra.estado, color: compra.estadoCompra.color)
                    }
                    LabeledContent("Pago", value: compra.alCredito ? "Crédito 30 días" : "Contado")
                    if let vence = compra.vence {
                        LabeledContent("Vence", value: Formato.fechaCompleta(vence))
                    }
                    if compra.estadoCompra == .aprobada {
                        LabeledContent("Pagada", value: compra.pagada ? "Sí" : "No")
                    }
                    if let motivo = compra.motivoRechazo {
                        LabeledContent("Motivo de rechazo", value: motivo)
                    }
                }
            }
            .monospacedDigit()
            .navigationTitle("Detalle de compra")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) { Button("Listo") { dismiss() } }
            }
        }
        .presentationDetents([.medium, .large])
    }
}
