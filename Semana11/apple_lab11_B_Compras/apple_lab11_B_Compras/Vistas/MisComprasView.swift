//
//  MisComprasView.swift
//  apple_lab11_B_Compras
//
//  Created by Jason on 17/11/26.
//

import SwiftUI
import SwiftData

// B6 · Mis compras. El comprador solo ve las suyas y no puede pagar ni aprobar.
struct MisComprasView: View {
    @Environment(Sesion.self) private var sesion

    // Todas las compras, de la más nueva a la más antigua
    @Query(sort: \Compra.fecha, order: .reverse) private var compras: [Compra]

    @State private var filtro = "Todas"

    // Se filtra el arreglo: primero las del usuario de la sesión, luego por estado
    private var misCompras: [Compra] {
        let propias = compras.filter { $0.comprador?.usuario == sesion.usuario?.usuario }
        if filtro == "Pendientes" { return propias.filter { $0.estado == "Pendiente" } }
        if filtro == "Rechazadas" { return propias.filter { $0.estado == "Rechazada" } }
        return propias
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker("Filtro", selection: $filtro) {
                        Text("Todas").tag("Todas")
                        Text("Pendientes").tag("Pendientes")
                        Text("Rechazadas").tag("Rechazadas")
                    }
                    .pickerStyle(.segmented)
                }

                Section {
                    ForEach(misCompras) { compra in
                        HStack {
                            Image(systemName: icono(compra.estado))
                                .foregroundStyle(colorEstado(compra.estado))
                                .frame(width: 30)
                            VStack(alignment: .leading) {
                                Text(compra.proveedor?.nombre ?? "Proveedor").font(.headline)
                                Text("\(compra.producto?.nombre ?? "Producto") × \(compra.cantidad) · \(fechaCorta(compra.fecha))")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                                // Compra rechazada: se muestra el motivo
                                if compra.estado == "Rechazada", let motivo = compra.motivoRechazo {
                                    Text("Motivo: \(motivo)")
                                        .font(.footnote)
                                        .foregroundStyle(.red)
                                }
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text(soles(compra.total)).font(.subheadline.bold())
                                Etiqueta(texto: compra.estado, color: colorEstado(compra.estado))
                            }
                        }
                    }
                } footer: {
                    Text("El comprador solo ve sus compras; no puede pagar ni aprobar.")
                }
            }
            .navigationTitle("Mis compras")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    MenuAvatar()
                }
            }
        }
    }

    func icono(_ estado: String) -> String {
        if estado == "Aprobada" { return "checkmark.circle.fill" }
        if estado == "Rechazada" { return "xmark.circle.fill" }
        return "hourglass.circle.fill"
    }
}
