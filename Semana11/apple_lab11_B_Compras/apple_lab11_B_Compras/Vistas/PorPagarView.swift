//
//  PorPagarView.swift
//  apple_lab11_B_Compras
//
//  Created by Jason on 17/11/26.
//

import SwiftUI
import SwiftData

// B8 · Por pagar. Compras aprobadas a crédito. Solo el supervisor las paga.
struct PorPagarView: View {
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \Compra.fecha) private var compras: [Compra]

    @State private var segmento = "Pendientes"
    @State private var busqueda = ""

    // Todas las compras a crédito aprobadas
    private var aCredito: [Compra] {
        return compras.filter { $0.estado == "Aprobada" && $0.alCredito }
    }

    // Lo que falta pagar (sin importar el segmento ni la búsqueda)
    private var totalPorPagar: Double {
        var suma = 0.0
        for compra in aCredito where !compra.pagada {
            suma += compra.total
        }
        return suma
    }

    // Filtra por segmento y por proveedor
    private var listaMostrada: [Compra] {
        var lista: [Compra]
        if segmento == "Vencidas" {
            lista = aCredito.filter { $0.estaVencida }
        } else if segmento == "Pagadas" {
            lista = aCredito.filter { $0.pagada }
        } else {
            lista = aCredito.filter { !$0.pagada }
        }
        if !busqueda.isEmpty {
            lista = lista.filter { ($0.proveedor?.nombre ?? "").localizedCaseInsensitiveContains(busqueda) }
        }
        return lista
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker("Segmento", selection: $segmento) {
                        Text("Pendientes").tag("Pendientes")
                        Text("Vencidas").tag("Vencidas")
                        Text("Pagadas").tag("Pagadas")
                    }
                    .pickerStyle(.segmented)
                }

                Section {
                    ForEach(listaMostrada) { compra in
                        HStack {
                            Iniciales(texto: compra.proveedor?.nombre ?? "?")
                            VStack(alignment: .leading) {
                                Text(compra.proveedor?.nombre ?? "Proveedor").font(.headline)
                                Text("\(compra.producto?.nombre ?? "Producto") × \(compra.cantidad)")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                                if !compra.pagada, let vence = compra.vence {
                                    Text("Vence \(fechaCorta(vence))")
                                        .font(.caption)
                                        .foregroundStyle(compra.estaVencida ? .red : .secondary)
                                }
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text(soles(compra.total)).font(.subheadline.bold())
                                if compra.estaVencida {
                                    Etiqueta(texto: "VENCIDA", color: .red)
                                } else if compra.pagada {
                                    Etiqueta(texto: "Pagada", color: .green)
                                }
                            }
                        }
                        // Deslizar para pagar (solo en las que todavía no se pagaron)
                        .swipeActions(edge: .trailing) {
                            if !compra.pagada {
                                Button("Pagar") {
                                    compra.pagar()
                                    try? modelContext.save()
                                }
                                .tint(.green)
                            }
                        }
                    }
                }

                Section {
                    VStack(alignment: .leading) {
                        Text("Total por pagar").font(.footnote).foregroundStyle(.secondary)
                        Text(soles(totalPorPagar)).font(.title2.bold())
                    }
                } footer: {
                    Text("Solo cuentan compras aprobadas a crédito y no pagadas.")
                }
            }
            .searchable(text: $busqueda, prompt: "Buscar proveedor")
            .navigationTitle("Por pagar")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    MenuAvatar()
                }
            }
        }
    }
}
