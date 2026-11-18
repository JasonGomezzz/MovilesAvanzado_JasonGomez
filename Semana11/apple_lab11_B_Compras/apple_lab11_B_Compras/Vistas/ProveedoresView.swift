//
//  ProveedoresView.swift
//  apple_lab11_B_Compras
//
//  Created by Jason on 17/11/26.
//

import SwiftUI
import SwiftData

// B4 · Proveedores. Lo comprado y lo por pagar se calculan con las compras de cada proveedor.
struct ProveedoresView: View {
    @Environment(Sesion.self) private var sesion
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \Proveedor.nombre) private var proveedores: [Proveedor]

    @State private var busqueda = ""
    @State private var mostrarFormulario = false
    @State private var proveedorAEditar: Proveedor?
    @State private var mensajeBorrado = ""
    @State private var mostrarAlerta = false

    private var proveedoresFiltrados: [Proveedor] {
        if busqueda.isEmpty { return proveedores }
        return proveedores.filter {
            $0.nombre.localizedCaseInsensitiveContains(busqueda) || $0.ruc.contains(busqueda)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(proveedoresFiltrados) { proveedor in
                    HStack {
                        Iniciales(texto: proveedor.nombre)
                        VStack(alignment: .leading) {
                            Text(proveedor.nombre).font(.headline)
                            Text("RUC \(proveedor.ruc)").font(.subheadline).foregroundStyle(.secondary)
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text(soles(proveedor.totalComprado)).font(.subheadline.bold())
                            // Insignia: "N por pagar" o "Al día"
                            if proveedor.comprasPorPagar.count > 0 {
                                Etiqueta(texto: "\(proveedor.comprasPorPagar.count) por pagar", color: .red)
                            } else {
                                Etiqueta(texto: "Al día", color: .green)
                            }
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if sesion.usuario?.esSupervisor == true {
                            proveedorAEditar = proveedor
                        }
                    }
                    .deleteDisabled(sesion.usuario?.esSupervisor != true)
                }
                .onDelete(perform: borrarProveedores)
            }
            .searchable(text: $busqueda, prompt: "Buscar proveedor")
            .navigationTitle("Proveedores")
            .toolbar {
                if sesion.usuario?.esSupervisor == true {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            mostrarFormulario = true
                        } label: {
                            Label("Nuevo proveedor", systemImage: "plus")
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    MenuAvatar()
                }
            }
            .sheet(isPresented: $mostrarFormulario) {
                FormularioProveedor(proveedor: nil)
            }
            .sheet(item: $proveedorAEditar) { proveedor in
                FormularioProveedor(proveedor: proveedor)
            }
            .alert("No se puede borrar", isPresented: $mostrarAlerta) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(mensajeBorrado)
            }
        }
    }

    private func borrarProveedores(offsets: IndexSet) {
        for indice in offsets {
            let proveedor = proveedoresFiltrados[indice]
            // Regla deny: con compras no se puede borrar
            if !proveedor.compras.isEmpty {
                mensajeBorrado = "\"\(proveedor.nombre)\" tiene \(proveedor.compras.count) compra(s) registradas."
                mostrarAlerta = true
            } else {
                modelContext.delete(proveedor)
            }
        }
        try? modelContext.save()
    }
}

// Formulario para crear o editar un proveedor (solo supervisor)
struct FormularioProveedor: View {
    let proveedor: Proveedor?   // nil = proveedor nuevo

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var nombre = ""
    @State private var ruc = ""

    // El RUC tiene 11 dígitos
    var rucValido: Bool {
        return ruc.count == 11 && Int(ruc) != nil
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField("Nombre o razón social", text: $nombre)
                TextField("RUC (11 dígitos)", text: $ruc)
                    .keyboardType(.numberPad)
                if !ruc.isEmpty && !rucValido {
                    Text("El RUC debe tener 11 dígitos.").foregroundStyle(.red)
                }
            }
            .navigationTitle(proveedor == nil ? "Nuevo proveedor" : "Editar proveedor")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") { guardar() }
                        .disabled(nombre.isEmpty || !rucValido)
                }
            }
            .onAppear {
                if let proveedor = proveedor {
                    nombre = proveedor.nombre
                    ruc = proveedor.ruc
                }
            }
        }
    }

    func guardar() {
        if let proveedor = proveedor {
            proveedor.nombre = nombre
            proveedor.ruc = ruc
        } else {
            modelContext.insert(Proveedor(nombre: nombre, ruc: ruc))
        }
        try? modelContext.save()
        dismiss()
    }
}
