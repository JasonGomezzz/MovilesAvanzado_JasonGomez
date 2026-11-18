//
//  AprobarView.swift
//  apple_lab11_B_Compras
//
//  Created by Jason on 17/11/26.
//

import SwiftUI
import SwiftData

// B7 · Aprobar. El supervisor ve cada compra pendiente con el efecto que tendría y la aprueba o rechaza.
struct AprobarView: View {
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \Compra.fecha) private var compras: [Compra]

    @State private var compraARechazar: Compra?

    private var pendientes: [Compra] {
        return compras.filter { $0.estado == "Pendiente" }
    }

    var body: some View {
        NavigationStack {
            List {
                if pendientes.isEmpty {
                    Text("No hay compras pendientes de aprobación.")
                        .foregroundStyle(.secondary)
                }

                ForEach(pendientes) { compra in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("\(compra.proveedor?.nombre ?? "Proveedor") · \(compra.producto?.nombre ?? "Producto")")
                                .font(.headline)
                            Spacer()
                            Etiqueta(texto: "Pendiente", color: .orange)
                        }
                        Text("Solicitó: \(compra.comprador?.nombre ?? "-") · \(fechaCorta(compra.fecha))")
                            .font(.footnote)
                            .foregroundStyle(.secondary)

                        Text("\(compra.cantidad) u. × \(soles(compra.costoUnitario)) = \(soles(compra.subtotal))")
                        Text("IGV 18 % \(soles(compra.igv)) · Total \(soles(compra.total))").bold()
                        if compra.alCredito, let vence = compra.vence {
                            Text("Crédito 30 días · vence \(fechaCorta(vence))").foregroundStyle(.secondary)
                        } else {
                            Text("Contado").foregroundStyle(.secondary)
                        }

                        // Vista previa del efecto: antes y después
                        if let producto = compra.producto {
                            let nuevoCosto = producto.costoPromedioConCompra(cantidad: compra.cantidad,
                                                                             costoUnitario: compra.costoUnitario)
                            VStack(alignment: .leading) {
                                Text("Si apruebas:").font(.caption.bold())
                                Text("Stock: \(producto.stock) → \(producto.stock + compra.cantidad)")
                                Text("Costo promedio: \(soles(producto.costoPromedio)) → \(soles(nuevoCosto))")
                            }
                            .font(.footnote)
                            .padding(8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.teal.opacity(0.12))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }

                        HStack {
                            Button("Rechazar", role: .destructive) {
                                compraARechazar = compra
                            }
                            .buttonStyle(.bordered)
                            Spacer()
                            Button("Aprobar") {
                                compra.aprobar()
                                try? modelContext.save()
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Aprobar")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    MenuAvatar()
                }
            }
            .sheet(item: $compraARechazar) { compra in
                FormularioRechazo(compra: compra)
            }
        }
    }
}

// Hoja para rechazar: el motivo es obligatorio
struct FormularioRechazo: View {
    let compra: Compra

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var motivo = ""

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text("\(compra.proveedor?.nombre ?? "Proveedor") · \(compra.producto?.nombre ?? "Producto") × \(compra.cantidad) · \(soles(compra.total))")
                }
                Section("Motivo (obligatorio)") {
                    TextField("Ej.: precio fuera del presupuesto", text: $motivo, axis: .vertical)
                        .lineLimit(3...5)
                }
                Section {
                    // Deshabilitado mientras el motivo esté vacío
                    Button("Rechazar compra", role: .destructive) {
                        compra.rechazar(motivo: motivo.trimmingCharacters(in: .whitespacesAndNewlines))
                        try? modelContext.save()
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .disabled(motivo.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .navigationTitle("Rechazar compra")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium])
    }
}
