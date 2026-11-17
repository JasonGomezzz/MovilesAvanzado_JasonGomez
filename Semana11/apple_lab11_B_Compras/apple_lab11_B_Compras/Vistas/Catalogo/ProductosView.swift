import SwiftData
import SwiftUI

/// B3 · Productos. El comprador solo consulta y busca; el supervisor crea, edita y borra.
struct ProductosView: View {
    @Environment(Sesion.self) private var sesion
    @Environment(\.modelContext) private var contexto

    @Query(sort: \Producto.nombre) private var productos: [Producto]

    @State private var busqueda = ""
    @State private var mostrarNuevo = false
    @State private var productoAEditar: Producto?
    @State private var aviso: AvisoAlerta?

    private var filtrados: [Producto] {
        let texto = busqueda.trimmingCharacters(in: .whitespaces)
        guard !texto.isEmpty else { return productos }
        return productos.filter {
            $0.nombre.localizedStandardContains(texto) || $0.categoria.localizedStandardContains(texto)
        }
    }

    private var valorInventario: Double {
        productos.reduce(0) { $0 + $1.valorInventario }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(filtrados) { producto in
                        FilaProducto(producto: producto)
                            .deleteDisabled(!sesion.esSupervisor) // solo el supervisor desliza para borrar
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if sesion.esSupervisor { productoAEditar = producto }
                            }
                    }
                    .onDelete(perform: borrar)
                }

                if !productos.isEmpty {
                    Section {
                        ResumenInventario(valor: valorInventario)
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.clear)
                    } footer: {
                        Text(sesion.esSupervisor
                             ? "Toca un producto para editarlo. Desliza para borrar: se bloquea si tiene compras."
                             : "Solo el supervisor puede crear, editar o borrar productos.")
                            .font(.footnote)
                    }
                }
            }
            .overlay {
                if productos.isEmpty {
                    ContentUnavailableView("Sin productos", systemImage: "shippingbox",
                                           description: Text("El supervisor puede agregar el primero con +."))
                } else if filtrados.isEmpty {
                    ContentUnavailableView.search(text: busqueda)
                }
            }
            .navigationTitle("Productos")
            .searchable(text: $busqueda, prompt: "Buscar producto")
            .toolbar {
                if sesion.esSupervisor {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Nuevo producto", systemImage: "plus") { mostrarNuevo = true }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) { MenuCuenta() }
            }
            .sheet(isPresented: $mostrarNuevo) { ProductoFormView(producto: nil) }
            .sheet(item: $productoAEditar) { ProductoFormView(producto: $0) }
            .alert(item: $aviso) { Alert(title: Text($0.titulo), message: Text($0.mensaje)) }
        }
    }

    /// Los índices que entrega .onDelete son los de la lista filtrada que se ve en pantalla.
    private func borrar(en posiciones: IndexSet) {
        for posicion in posiciones {
            let producto = filtrados[posicion]
            // delete rule .deny: un producto con compras no se puede borrar
            guard producto.compras.isEmpty else {
                aviso = AvisoAlerta(titulo: "No se puede borrar",
                                    mensaje: "\"\(producto.nombre)\" tiene \(producto.compras.count) compra(s) registradas.")
                continue
            }
            contexto.delete(producto)
        }
        contexto.guardar()
    }
}

private struct FilaProducto: View {
    let producto: Producto

    var body: some View {
        HStack(spacing: 12) {
            Avatar(texto: producto.nombre)
            VStack(alignment: .leading, spacing: 2) {
                Text(producto.nombre)
                    .font(.body.weight(.semibold))
                Text(producto.categoria)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 8)
            VStack(alignment: .trailing, spacing: 4) {
                Text(Formato.soles(producto.costoPromedio))
                    .font(.subheadline.weight(.semibold))
                    .monospacedDigit()
                    .lineLimit(1)
                    .fixedSize()
                HStack(spacing: 6) {
                    Text("costo prom.")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    InsigniaStock(stock: producto.stock)
                }
            }
        }
        .padding(.vertical, 2)
        .accessibilityElement(children: .combine)
    }
}

private struct ResumenInventario: View {
    let valor: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Valor del inventario (stock × costo promedio)")
                .font(.footnote)
                .foregroundStyle(.secondary)
            Text(Formato.soles(valor))
                .font(.system(.title2, design: .rounded, weight: .bold))
                .monospacedDigit()
                .foregroundStyle(.primary)
        }
        .tarjeta()
    }
}

#Preview {
    let contenedor = ModelContainerProvider.enMemoria()
    DatosDemo.sembrarCatalogoSiVacio(en: contenedor.mainContext)
    return ProductosView()
        .environment(Sesion())
        .modelContainer(contenedor)
}
