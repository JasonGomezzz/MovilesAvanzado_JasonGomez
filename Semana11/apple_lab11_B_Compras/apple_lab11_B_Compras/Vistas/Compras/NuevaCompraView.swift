import SwiftData
import SwiftUI

/// B5 · Nueva compra. La registra el comprador; el total decide si se aprueba sola o queda pendiente.
struct NuevaCompraView: View {
    @Environment(Sesion.self) private var sesion
    @Environment(\.modelContext) private var contexto

    @Query(sort: \Proveedor.nombre) private var proveedores: [Proveedor]
    @Query(sort: \Producto.nombre) private var productos: [Producto]

    @State private var proveedor: Proveedor?
    @State private var producto: Producto?
    @State private var cantidadTexto = ""
    @State private var costoTexto = ""
    @State private var alCredito = false
    @State private var resultado: AvisoAlerta?
    @State private var errorTexto: String?
    @State private var registradas = 0
    @FocusState private var enfocado: Bool

    private var cantidad: Int? {
        Int(cantidadTexto.trimmingCharacters(in: .whitespaces)).flatMap { $0 > 0 ? $0 : nil }
    }

    private var costo: Double? {
        Formato.numero(costoTexto).flatMap { $0 > 0 ? $0 : nil }
    }

    private var desglose: DesgloseCompra? {
        guard let cantidad, let costo else { return nil }
        return DesgloseCompra(cantidad: cantidad, costoUnitario: costo)
    }

    private var puedeEnviar: Bool {
        proveedor != nil && producto != nil && desglose != nil
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Proveedor", selection: $proveedor) {
                        Text("Elegir…").tag(Proveedor?.none)
                        ForEach(proveedores) { Text($0.nombre).tag(Proveedor?.some($0)) }
                    }
                    .pickerStyle(.navigationLink)

                    Picker("Producto", selection: $producto) {
                        Text("Elegir…").tag(Producto?.none)
                        ForEach(productos) { Text($0.nombre).tag(Producto?.some($0)) }
                    }
                    .pickerStyle(.navigationLink)

                    LabeledContent("Cantidad") {
                        TextField("0", text: $cantidadTexto)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(maxWidth: 120)
                            .focused($enfocado)
                    }
                    LabeledContent("Costo unitario (S/)") {
                        TextField("0.00", text: $costoTexto)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(maxWidth: 120)
                            .focused($enfocado)
                    }
                } footer: {
                    if let producto {
                        Text("Stock actual \(producto.stock) u. · costo promedio \(Formato.soles(producto.costoPromedio))")
                    }
                }

                Section {
                    Picker("Forma de pago", selection: $alCredito) {
                        Text("Contado").tag(false)
                        Text("Crédito 30 días").tag(true)
                    }
                    .pickerStyle(.segmented)
                    .listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
                }

                Section("Resumen (calculado)") {
                    FilaMonto(titulo: "Subtotal", valor: desglose?.subtotal)
                    FilaMonto(titulo: "IGV 18 %", valor: desglose?.igv)
                    FilaMonto(titulo: "Total", valor: desglose?.total, destacado: true)
                }

                if desglose?.requiereAprobacion == true {
                    Section {
                        Label {
                            Text("Supera S/ 5,000: quedará **pendiente de aprobación** del supervisor. No cambia stock ni costo promedio todavía.")
                                .font(.footnote)
                        } icon: {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(Color.aviso)
                        }
                        .listRowBackground(Color(red: 1.0, green: 0.78, blue: 0.25).opacity(0.2))
                    }
                    .transition(.opacity)
                }

                if let errorTexto {
                    Section { MensajeError(texto: errorTexto) }
                }

                Section {
                    Button(desglose?.requiereAprobacion == true ? "Enviar a aprobación" : "Registrar compra",
                           action: enviar)
                        .buttonStyle(BotonPrincipal())
                        .disabled(!puedeEnviar)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                }
            }
            .animation(.easeOut(duration: 0.2), value: desglose?.requiereAprobacion)
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("Nueva compra")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) { MenuCuenta() }
                // El teclado numérico no tiene tecla de retorno: se agrega "Listo".
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Listo") { enfocado = false }
                }
            }
            .onChange(of: producto) { _, nuevo in
                // Se sugiere el costo promedio actual; el comprador lo puede cambiar.
                if let nuevo { costoTexto = Formato.decimal(nuevo.costoPromedio) }
            }
            .alert(item: $resultado) { Alert(title: Text($0.titulo), message: Text($0.mensaje)) }
            .sensoryFeedback(.success, trigger: registradas)
        }
    }

    private func enviar() {
        guard let comprador = sesion.usuario, let proveedor, let producto, let cantidad, let costo else { return }
        errorTexto = nil
        enfocado = false

        let antes = (stock: producto.stock, costo: producto.costoPromedio)
        do {
            let compra = try ReglasCompra.registrar(comprador: comprador, proveedor: proveedor, producto: producto,
                                                    cantidad: cantidad, costoUnitario: costo,
                                                    alCredito: alCredito, en: contexto)
            registradas += 1
            if compra.estadoCompra == .aprobada {
                resultado = AvisoAlerta(
                    titulo: "Compra registrada",
                    mensaje: "Total \(Formato.soles(compra.total)). Stock \(antes.stock) → \(producto.stock). "
                        + "Costo promedio \(Formato.soles(antes.costo)) → \(Formato.soles(producto.costoPromedio)). "
                        + (alCredito ? "Vence el \(Formato.fechaCompleta(compra.vence ?? .now))." : "Pagada al contado."))
            } else {
                resultado = AvisoAlerta(
                    titulo: "Enviada a aprobación",
                    mensaje: "Total \(Formato.soles(compra.total)). Supera S/ 5,000, así que el supervisor debe aprobarla. El stock y el costo promedio no cambian todavía.")
            }
            limpiar()
        } catch {
            errorTexto = error.localizedDescription
        }
    }

    private func limpiar() {
        proveedor = nil
        producto = nil
        cantidadTexto = ""
        costoTexto = ""
        alCredito = false
    }
}

private struct FilaMonto: View {
    let titulo: String
    let valor: Double?
    var destacado = false

    var body: some View {
        LabeledContent {
            Text(valor.map { Formato.soles($0) } ?? "S/ –")
                .monospacedDigit()
                .fontWeight(destacado ? .bold : .regular)
                .foregroundStyle(valor == nil ? .tertiary : .primary)
        } label: {
            Text(titulo).fontWeight(destacado ? .semibold : .regular)
        }
    }
}
