import SwiftData
import SwiftUI

/// B7 · Aprobar. El supervisor ve cada compra pendiente con el efecto que tendría y la aprueba o rechaza.
struct AprobarView: View {
    @Environment(Sesion.self) private var sesion
    @Environment(\.modelContext) private var contexto

    @Query(filter: #Predicate<Compra> { $0.estado == "Pendiente" }, sort: \Compra.fecha)
    private var pendientes: [Compra]

    @Query(filter: #Predicate<Compra> { $0.estado != "Pendiente" }, sort: \Compra.fecha, order: .reverse)
    private var resueltas: [Compra]

    @State private var compraARechazar: Compra?
    @State private var aviso: AvisoAlerta?
    @State private var decisiones = 0

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 14) {
                    if pendientes.isEmpty {
                        ContentUnavailableView("Nada por aprobar", systemImage: "checkmark.seal",
                                               description: Text("Las compras desde S/ 5,000 aparecerán aquí."))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 32)
                    } else {
                        ForEach(pendientes) { compra in
                            TarjetaPendiente(compra: compra,
                                             aprobar: { aprobar(compra) },
                                             rechazar: { compraARechazar = compra })
                        }
                        Text("Al rechazar se pide un motivo, que el comprador verá en \"Mis compras\".")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 4)
                    }

                    if !resueltas.isEmpty {
                        Text("RESUELTAS RECIENTEMENTE")
                            .font(.caption2.weight(.semibold))
                            .tracking(0.6)
                            .foregroundStyle(.secondary)
                            .padding(.top, 14)
                            .padding(.horizontal, 4)
                        VStack(spacing: 0) {
                            ForEach(Array(resueltas.prefix(6).enumerated()), id: \.element.id) { indice, compra in
                                FilaResuelta(compra: compra)
                                if indice < min(resueltas.count, 6) - 1 { Divider().padding(.leading, 56) }
                            }
                        }
                        .tarjeta(relleno: 12)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Aprobar")
            .toolbar { ToolbarItem(placement: .topBarTrailing) { MenuCuenta() } }
            .sheet(item: $compraARechazar) { compra in
                RechazoView(compra: compra) { decisiones += 1 }
            }
            .alert(item: $aviso) { Alert(title: Text($0.titulo), message: Text($0.mensaje)) }
            .sensoryFeedback(.success, trigger: decisiones)
        }
    }

    private func aprobar(_ compra: Compra) {
        guard let supervisor = sesion.usuario else { return }
        do {
            try ReglasCompra.aprobar(compra, por: supervisor, en: contexto)
            decisiones += 1
        } catch {
            aviso = AvisoAlerta(titulo: "No se pudo aprobar", mensaje: error.localizedDescription)
        }
    }
}

private struct TarjetaPendiente: View {
    let compra: Compra
    let aprobar: () -> Void
    let rechazar: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(compra.proveedor?.nombre ?? "Proveedor")
                        .font(.headline)
                    Text(compra.producto?.nombre ?? "Producto")
                        .font(.subheadline.weight(.medium))
                    Text("Solicitó: \(compra.comprador?.nombre ?? "—") · \(Formato.fechaCorta(compra.fecha))")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                Spacer(minLength: 8)
                Insignia(texto: "Pendiente", color: .aviso)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text("\(compra.cantidad) u. × \(Formato.soles(compra.costoUnitario)) = \(Formato.soles(compra.subtotal))")
                Text("IGV 18 % \(Formato.soles(compra.igv)) · **Total \(Formato.soles(compra.total))**")
                Text(compra.alCredito
                     ? "Crédito 30 días · vence \(Formato.fechaCorta(compra.vence ?? .now))"
                     : "Contado")
                    .foregroundStyle(.secondary)
            }
            .font(.subheadline)
            .monospacedDigit()

            if let efecto = ReglasCompra.efectoPrevisto(de: compra) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("SI APRUEBAS")
                        .font(.caption2.weight(.semibold))
                        .tracking(0.6)
                        .foregroundStyle(.secondary)
                    Text("Stock: \(efecto.stockAntes) → \(efecto.stockDespues)")
                    Text("Costo promedio: \(Formato.soles(efecto.costoAntes)) → \(Formato.soles(efecto.costoDespues))")
                }
                .font(.footnote.weight(.medium))
                .monospacedDigit()
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.marca.opacity(0.10), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            }

            HStack(spacing: 10) {
                Button("Rechazar", action: rechazar).buttonStyle(BotonContorno())
                Button("Aprobar", action: aprobar).buttonStyle(BotonPrincipal())
            }
        }
        .tarjeta()
    }
}

private struct FilaResuelta: View {
    let compra: Compra

    var body: some View {
        HStack(spacing: 12) {
            IconoEstado(estado: compra.estadoCompra)
            VStack(alignment: .leading, spacing: 1) {
                Text("\(compra.proveedor?.nombre ?? "Proveedor") · \(compra.producto?.nombre ?? "Producto")")
                    .font(.subheadline.weight(.medium))
                    .lineLimit(1)
                Text(compra.estadoCompra == .rechazada
                     ? "Rechazada: \(compra.motivoRechazo ?? "")"
                     : "\(compra.comprador?.nombre ?? "—") · \(Formato.fechaCorta(compra.fecha))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            Spacer(minLength: 8)
            Text(Formato.soles(compra.total))
                .font(.subheadline.weight(.semibold))
                .monospacedDigit()
        }
        .padding(.vertical, 8)
    }
}

/// Hoja para rechazar: el motivo es obligatorio y el botón queda apagado hasta escribirlo.
private struct RechazoView: View {
    let compra: Compra
    let alTerminar: () -> Void

    @Environment(Sesion.self) private var sesion
    @Environment(\.modelContext) private var contexto
    @Environment(\.dismiss) private var dismiss

    @State private var motivo = ""
    @State private var error: String?
    @FocusState private var enfocado: Bool

    private var motivoVacio: Bool { motivo.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text("\(compra.proveedor?.nombre ?? "Proveedor") · \(compra.producto?.nombre ?? "Producto") × \(compra.cantidad) · \(Formato.soles(compra.total))")
                        .font(.subheadline)
                }
                Section {
                    TextField("Ej.: precio fuera del presupuesto", text: $motivo, axis: .vertical)
                        .lineLimit(3...5)
                        .focused($enfocado)
                } header: {
                    Text("Motivo (obligatorio)")
                } footer: {
                    Text("El comprador verá este motivo en \"Mis compras\". El stock y el costo promedio no cambian.")
                }
                if let error {
                    Section { MensajeError(texto: error) }
                }
                Section {
                    Button("Rechazar compra", action: rechazar)
                        .buttonStyle(BotonPrincipal(color: .peligro))
                        .disabled(motivoVacio)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                }
            }
            .navigationTitle("Rechazar compra")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancelar") { dismiss() } }
            }
            .onAppear { enfocado = true }
        }
        .presentationDetents([.medium])
    }

    private func rechazar() {
        guard let supervisor = sesion.usuario else { return }
        do {
            try ReglasCompra.rechazar(compra, motivo: motivo, por: supervisor, en: contexto)
            alTerminar()
            dismiss()
        } catch {
            self.error = error.localizedDescription
        }
    }
}
