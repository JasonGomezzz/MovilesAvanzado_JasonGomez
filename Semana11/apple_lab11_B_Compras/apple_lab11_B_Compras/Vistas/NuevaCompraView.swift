//
//  NuevaCompraView.swift
//  apple_lab11_B_Compras
//
//  Created by Jason on 17/11/26.
//

import SwiftUI
import SwiftData

// B5 · Nueva compra. Si el total es menor a S/ 5,000 se aprueba sola; si no, queda pendiente.
struct NuevaCompraView: View {
    @Environment(Sesion.self) private var sesion
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \Proveedor.nombre) private var proveedores: [Proveedor]
    @Query(sort: \Producto.nombre) private var productos: [Producto]

    @State private var proveedor: Proveedor?
    @State private var producto: Producto?
    @State private var cantidad = ""
    @State private var costo = ""
    @State private var alCredito = false
    @State private var mensaje = ""
    @State private var mostrarMensaje = false
    @FocusState private var escribiendo: Bool

    // Lo que escribió el usuario, convertido a número (nil si todavía no es válido)
    var cantidadNumero: Int? {
        if let n = Int(cantidad), n > 0 { return n }
        return nil
    }
    var costoNumero: Double? {
        if let c = leerNumero(costo), c > 0 { return c }
        return nil
    }

    // Subtotal, IGV y total (solo cuando cantidad y costo son válidos)
    var calculo: (subtotal: Double, igv: Double, total: Double)? {
        if let c = cantidadNumero, let k = costoNumero {
            return Compra.calcular(cantidad: c, costoUnitario: k)
        }
        return nil
    }

    var necesitaAprobacion: Bool {
        if let calculo = calculo { return calculo.total >= Compra.limiteAprobacion }
        return false
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Proveedor", selection: $proveedor) {
                        Text("Elegir...").tag(Proveedor?.none)
                        ForEach(proveedores) { p in
                            Text(p.nombre).tag(Proveedor?.some(p))
                        }
                    }
                    Picker("Producto", selection: $producto) {
                        Text("Elegir...").tag(Producto?.none)
                        ForEach(productos) { p in
                            Text(p.nombre).tag(Producto?.some(p))
                        }
                    }
                    HStack {
                        Text("Cantidad")
                        TextField("0", text: $cantidad)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .focused($escribiendo)
                    }
                    HStack {
                        Text("Costo unitario (S/)")
                        TextField("0.00", text: $costo)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .focused($escribiendo)
                    }
                } footer: {
                    if let producto = producto {
                        Text("Stock actual \(producto.stock) u. · costo promedio \(soles(producto.costoPromedio))")
                    }
                }

                Section {
                    Picker("Forma de pago", selection: $alCredito) {
                        Text("Contado").tag(false)
                        Text("Crédito 30 días").tag(true)
                    }
                    .pickerStyle(.segmented)
                }

                Section("Resumen (calculado)") {
                    HStack {
                        Text("Subtotal")
                        Spacer()
                        Text(calculo != nil ? soles(calculo!.subtotal) : "S/ -")
                    }
                    HStack {
                        Text("IGV 18 %")
                        Spacer()
                        Text(calculo != nil ? soles(calculo!.igv) : "S/ -")
                    }
                    HStack {
                        Text("Total").bold()
                        Spacer()
                        Text(calculo != nil ? soles(calculo!.total) : "S/ -").bold()
                    }
                }

                // Aviso cuando el total llega a S/ 5,000
                if necesitaAprobacion {
                    Section {
                        Label("Supera S/ 5,000: quedará pendiente de aprobación del supervisor. No cambia stock ni costo promedio todavía.",
                              systemImage: "exclamationmark.triangle.fill")
                            .font(.footnote)
                            .foregroundStyle(.orange)
                    }
                }

                Section {
                    Button(necesitaAprobacion ? "Enviar a aprobación" : "Registrar compra") {
                        registrar()
                    }
                    .frame(maxWidth: .infinity)
                    .disabled(proveedor == nil || producto == nil || calculo == nil)
                }
            }
            .navigationTitle("Nueva compra")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    MenuAvatar()
                }
                // El teclado numérico no tiene tecla de retorno
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Listo") { escribiendo = false }
                }
            }
            .alert("Compra", isPresented: $mostrarMensaje) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(mensaje)
            }
        }
    }

    func registrar() {
        // Se necesitan todos los datos y el comprador de la sesión
        guard let comprador = sesion.usuario, let proveedor = proveedor, let producto = producto,
              let c = cantidadNumero, let k = costoNumero else { return }
        escribiendo = false

        let stockAntes = producto.stock
        let costoAntes = producto.costoPromedio

        let compra = Compra(cantidad: c, costoUnitario: k, alCredito: alCredito,
                            comprador: comprador, proveedor: proveedor, producto: producto)
        modelContext.insert(compra)

        if compra.necesitaAprobacion {
            // Queda Pendiente: no cambia nada más hasta que el supervisor la apruebe
            mensaje = "Total \(soles(compra.total)). Supera S/ 5,000: el supervisor debe aprobarla. El stock y el costo promedio no cambian todavía."
        } else {
            compra.aprobar()
            mensaje = "Total \(soles(compra.total)). Stock \(stockAntes) → \(producto.stock). Costo promedio \(soles(costoAntes)) → \(soles(producto.costoPromedio))."
            if compra.alCredito, let vence = compra.vence {
                mensaje += " Vence el \(fechaCorta(vence))."
            }
        }
        try? modelContext.save()
        mostrarMensaje = true

        // Se limpia el formulario
        self.proveedor = nil
        self.producto = nil
        cantidad = ""
        costo = ""
        alCredito = false
    }
}
