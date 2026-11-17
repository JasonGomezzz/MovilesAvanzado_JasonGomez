import SwiftData
import SwiftUI

/// Crear o editar un producto (solo supervisor). Si `producto` es nil se crea uno nuevo.
struct ProductoFormView: View {
    let producto: Producto?

    @Environment(\.modelContext) private var contexto
    @Environment(\.dismiss) private var dismiss

    @State private var nombre = ""
    @State private var categoria = ""
    @State private var stockTexto = "0"
    @State private var costoTexto = ""
    @FocusState private var enfocado: Bool

    private var stock: Int? { Int(stockTexto.trimmingCharacters(in: .whitespaces)).flatMap { $0 >= 0 ? $0 : nil } }
    private var costo: Double? { Formato.numero(costoTexto).flatMap { $0 >= 0 ? $0 : nil } }

    private var esValido: Bool {
        !nombre.trimmingCharacters(in: .whitespaces).isEmpty
            && !categoria.trimmingCharacters(in: .whitespaces).isEmpty
            && stock != nil && costo != nil
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Datos del producto") {
                    TextField("Nombre", text: $nombre)
                        .textInputAutocapitalization(.sentences)
                    TextField("Categoría (Laptops, Monitores…)", text: $categoria)
                        .textInputAutocapitalization(.words)
                }
                Section {
                    LabeledContent("Stock") {
                        TextField("0", text: $stockTexto)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .focused($enfocado)
                    }
                    LabeledContent("Costo promedio (S/)") {
                        TextField("0.00", text: $costoTexto)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .focused($enfocado)
                    }
                } footer: {
                    Text("El stock y el costo promedio cambian solos cuando se aprueba una compra.")
                }
            }
            .navigationTitle(producto == nil ? "Nuevo producto" : "Editar producto")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar", action: guardar).disabled(!esValido)
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Listo") { enfocado = false }
                }
            }
            .onAppear(perform: cargar)
        }
        .presentationDetents([.medium, .large])
    }

    private func cargar() {
        guard let producto else { return }
        nombre = producto.nombre
        categoria = producto.categoria
        stockTexto = String(producto.stock)
        costoTexto = Formato.decimal(producto.costoPromedio)
    }

    private func guardar() {
        guard let stock, let costo else { return }
        let nombreLimpio = nombre.trimmingCharacters(in: .whitespaces)
        let categoriaLimpia = categoria.trimmingCharacters(in: .whitespaces)
        if let producto {
            producto.nombre = nombreLimpio
            producto.categoria = categoriaLimpia
            producto.stock = stock
            producto.costoPromedio = costo
        } else {
            contexto.insert(Producto(nombre: nombreLimpio, categoria: categoriaLimpia,
                                     stock: stock, costoPromedio: costo))
        }
        contexto.guardar()
        dismiss()
    }
}
