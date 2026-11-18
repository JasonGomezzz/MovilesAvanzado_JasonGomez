//
//  ProductosView.swift
//  apple_lab11_B_Compras
//
//  Created by Jason on 17/11/26.
//

import SwiftUI
import SwiftData

// B3 · Productos. El comprador solo consulta y busca; el supervisor crea, edita y borra.
struct ProductosView: View {
    @Environment(Sesion.self) private var sesion
    @Environment(\.modelContext) private var modelContext

    // READ: todos los productos ordenados por nombre
    @Query(sort: \Producto.nombre) private var productos: [Producto]

    @State private var busqueda = ""
    @State private var mostrarFormulario = false
    @State private var productoAEditar: Producto?
    @State private var mensajeBorrado = ""
    @State private var mostrarAlerta = false

    // Productos que coinciden con la búsqueda (por nombre o categoría)
    private var productosFiltrados: [Producto] {
        if busqueda.isEmpty { return productos }
        return productos.filter {
            $0.nombre.localizedCaseInsensitiveContains(busqueda) ||
            $0.categoria.localizedCaseInsensitiveContains(busqueda)
        }
    }

    // Valor del inventario = suma de stock × costo promedio
    private var valorInventario: Double {
        var suma = 0.0
        for producto in productos {
            suma += producto.valorInventario
        }
        return suma
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(productosFiltrados) { producto in
                    HStack {
                        Iniciales(texto: producto.nombre)
                        VStack(alignment: .leading) {
                            Text(producto.nombre).font(.headline)
                            Text(producto.categoria).font(.subheadline).foregroundStyle(.secondary)
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text(soles(producto.costoPromedio)).font(.subheadline.bold())
                            Etiqueta(texto: "\(producto.stock) u.", color: colorStock(producto.stock))
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        // Solo el supervisor puede editar
                        if sesion.usuario?.esSupervisor == true {
                            productoAEditar = producto
                        }
                    }
                    // Solo el supervisor puede borrar con swipe
                    .deleteDisabled(sesion.usuario?.esSupervisor != true)
                }
                .onDelete(perform: borrarProductos)

                Section {
                    VStack(alignment: .leading) {
                        Text("Valor del inventario (stock × costo promedio)")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                        Text(soles(valorInventario)).font(.title2.bold())
                    }
                } footer: {
                    Text(sesion.usuario?.esSupervisor == true
                         ? "Desliza para borrar: se bloquea si el producto tiene compras."
                         : "Solo el supervisor puede crear, editar o borrar.")
                }
            }
            .searchable(text: $busqueda, prompt: "Buscar producto")
            .navigationTitle("Productos")
            .toolbar {
                if sesion.usuario?.esSupervisor == true {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            mostrarFormulario = true
                        } label: {
                            Label("Nuevo producto", systemImage: "plus")
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    MenuAvatar()
                }
            }
            .sheet(isPresented: $mostrarFormulario) {
                FormularioProducto(producto: nil)
            }
            .sheet(item: $productoAEditar) { producto in
                FormularioProducto(producto: producto)
            }
            .alert("No se puede borrar", isPresented: $mostrarAlerta) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(mensajeBorrado)
            }
        }
    }

    // DELETE: los índices son los de la lista filtrada que se ve en pantalla
    private func borrarProductos(offsets: IndexSet) {
        for indice in offsets {
            let producto = productosFiltrados[indice]
            // Regla deny: si tiene compras no se borra y se avisa con una alerta
            if !producto.compras.isEmpty {
                mensajeBorrado = "\"\(producto.nombre)\" tiene \(producto.compras.count) compra(s) registradas."
                mostrarAlerta = true
            } else {
                modelContext.delete(producto)
            }
        }
        try? modelContext.save()
    }
}

// Formulario para crear o editar un producto (solo supervisor)
struct FormularioProducto: View {
    let producto: Producto?   // nil = producto nuevo

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var nombre = ""
    @State private var categoria = ""
    @State private var stock = "0"
    @State private var costo = ""

    var esValido: Bool {
        return !nombre.isEmpty && !categoria.isEmpty && Int(stock) != nil && leerNumero(costo) != nil
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField("Nombre", text: $nombre)
                TextField("Categoría (Laptops, Monitores...)", text: $categoria)
                TextField("Stock", text: $stock)
                    .keyboardType(.numberPad)
                TextField("Costo promedio (S/)", text: $costo)
                    .keyboardType(.decimalPad)
            }
            .navigationTitle(producto == nil ? "Nuevo producto" : "Editar producto")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") { guardar() }
                        .disabled(!esValido)
                }
            }
            .onAppear {
                // Si se está editando, se cargan los datos actuales
                if let producto = producto {
                    nombre = producto.nombre
                    categoria = producto.categoria
                    stock = String(producto.stock)
                    costo = String(producto.costoPromedio)
                }
            }
        }
    }

    func guardar() {
        let stockNumero = Int(stock) ?? 0
        let costoNumero = leerNumero(costo) ?? 0
        if let producto = producto {
            // UPDATE: SwiftData detecta el cambio solo
            producto.nombre = nombre
            producto.categoria = categoria
            producto.stock = stockNumero
            producto.costoPromedio = costoNumero
        } else {
            // CREATE
            let nuevo = Producto(nombre: nombre, categoria: categoria, stock: stockNumero, costoPromedio: costoNumero)
            modelContext.insert(nuevo)
        }
        try? modelContext.save()
        dismiss()
    }
}
