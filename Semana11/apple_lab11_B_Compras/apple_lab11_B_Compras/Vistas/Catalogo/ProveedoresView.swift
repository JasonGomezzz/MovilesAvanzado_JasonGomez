import SwiftData
import SwiftUI

/// B4 · Proveedores. "Por pagar" y "comprado" se calculan desde la relación proveedor ▸ compras.
struct ProveedoresView: View {
    @Environment(Sesion.self) private var sesion
    @Environment(\.modelContext) private var contexto

    @Query(sort: \Proveedor.nombre) private var proveedores: [Proveedor]

    @State private var busqueda = ""
    @State private var mostrarNuevo = false
    @State private var proveedorAEditar: Proveedor?
    @State private var aviso: AvisoAlerta?

    private var filtrados: [Proveedor] {
        let texto = busqueda.trimmingCharacters(in: .whitespaces)
        guard !texto.isEmpty else { return proveedores }
        return proveedores.filter {
            $0.nombre.localizedStandardContains(texto) || $0.ruc.contains(texto)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(filtrados) { proveedor in
                        FilaProveedor(proveedor: proveedor)
                            .deleteDisabled(!sesion.esSupervisor) // solo el supervisor desliza para borrar
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if sesion.esSupervisor { proveedorAEditar = proveedor }
                            }
                    }
                    .onDelete(perform: borrar)
                } footer: {
                    Text("\"Por pagar\" y \"comprado\" se calculan con las compras aprobadas de cada proveedor (relación proveedor ▸ compras).")
                        .font(.footnote)
                        .padding(.top, 6)
                        .textCase(nil)
                }
            }
            .overlay {
                if proveedores.isEmpty {
                    ContentUnavailableView("Sin proveedores", systemImage: "building.2",
                                           description: Text("El supervisor puede agregar el primero con +."))
                } else if filtrados.isEmpty {
                    ContentUnavailableView.search(text: busqueda)
                }
            }
            .navigationTitle("Proveedores")
            .searchable(text: $busqueda, prompt: "Buscar proveedor")
            .toolbar {
                if sesion.esSupervisor {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Nuevo proveedor", systemImage: "plus") { mostrarNuevo = true }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) { MenuCuenta() }
            }
            .sheet(isPresented: $mostrarNuevo) { ProveedorFormView(proveedor: nil) }
            .sheet(item: $proveedorAEditar) { ProveedorFormView(proveedor: $0) }
            .alert(item: $aviso) { Alert(title: Text($0.titulo), message: Text($0.mensaje)) }
        }
    }

    private func borrar(en posiciones: IndexSet) {
        for posicion in posiciones {
            let proveedor = filtrados[posicion]
            guard proveedor.compras.isEmpty else {
                aviso = AvisoAlerta(titulo: "No se puede borrar",
                                    mensaje: "\"\(proveedor.nombre)\" tiene \(proveedor.compras.count) compra(s) registradas.")
                continue
            }
            contexto.delete(proveedor)
        }
        contexto.guardar()
    }
}

private struct FilaProveedor: View {
    let proveedor: Proveedor

    var body: some View {
        let porPagar = proveedor.comprasPorPagar.count
        HStack(spacing: 12) {
            Avatar(texto: proveedor.nombre)
            VStack(alignment: .leading, spacing: 2) {
                Text(proveedor.nombre)
                    .font(.body.weight(.semibold))
                Text("RUC \(proveedor.ruc)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 8)
            VStack(alignment: .trailing, spacing: 3) {
                Text(Formato.soles(proveedor.totalComprado))
                    .font(.subheadline.weight(.semibold))
                    .monospacedDigit()
                if porPagar > 0 {
                    Insignia(texto: "\(porPagar) por pagar", color: .peligro)
                } else {
                    Insignia(texto: "Al día", color: .correcto)
                }
            }
        }
        .padding(.vertical, 2)
        .accessibilityElement(children: .combine)
    }
}

/// Crear o editar un proveedor (solo supervisor).
struct ProveedorFormView: View {
    let proveedor: Proveedor?

    @Environment(\.modelContext) private var contexto
    @Environment(\.dismiss) private var dismiss

    @State private var nombre = ""
    @State private var ruc = ""

    private var rucValido: Bool { ruc.count == 11 && ruc.allSatisfy(\.isNumber) }
    private var esValido: Bool { !nombre.trimmingCharacters(in: .whitespaces).isEmpty && rucValido }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Nombre o razón social", text: $nombre)
                        .textInputAutocapitalization(.words)
                    TextField("RUC (11 dígitos)", text: $ruc)
                        .keyboardType(.numberPad)
                } header: {
                    Text("Datos del proveedor")
                } footer: {
                    if !ruc.isEmpty && !rucValido {
                        Text("El RUC debe tener 11 dígitos.").foregroundStyle(Color.peligro)
                    }
                }
            }
            .navigationTitle(proveedor == nil ? "Nuevo proveedor" : "Editar proveedor")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar", action: guardar).disabled(!esValido)
                }
            }
            .onAppear {
                guard let proveedor else { return }
                nombre = proveedor.nombre
                ruc = proveedor.ruc
            }
        }
        .presentationDetents([.medium])
    }

    private func guardar() {
        let nombreLimpio = nombre.trimmingCharacters(in: .whitespaces)
        if let proveedor {
            proveedor.nombre = nombreLimpio
            proveedor.ruc = ruc
        } else {
            contexto.insert(Proveedor(nombre: nombreLimpio, ruc: ruc))
        }
        contexto.guardar()
        dismiss()
    }
}
