//
//  PagoInstructoresView.swift
//  Semana08
//
//  Pantalla para calcular el pago mensual de un instructor.
//

import SwiftUI

struct PagoInstructoresView: View {
    @State private var horasTexto = ""
    @State private var sistema: SistemaPension = .onp
    @State private var resultado: ResultadoPago?
    @State private var error: String?

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                Text("Pago de Instructores")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)

                Text("S/ 50 por hora · máximo 23 horas semanales")
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                TextField("Horas semanales", text: $horasTexto)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)

                Picker("Sistema de pensiones", selection: $sistema) {
                    ForEach(SistemaPension.allCases) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented)

                Button(action: calcular) {
                    Text("Calcular pago")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }

                if let error { Text(error).foregroundStyle(.red) }

                if let r = resultado {
                    VStack(alignment: .leading, spacing: 8) {
                        fila("Sueldo bruto", r.sueldoBruto)
                        fila("Descuento \(sistema == .onp ? "ONP" : "AFP")", -r.pension)
                        fila("Impuesto a la renta (5ta)", -r.impuestoRenta)
                        Divider()
                        HStack {
                            Text("Sueldo neto").font(.title3.bold())
                            Spacer()
                            Text("S/ \(r.sueldoNeto, specifier: "%.2f")").font(.title3.bold())
                        }
                        Text("ESSALUD (9%, lo paga el empleador): S/ \(r.essalud, specifier: "%.2f")")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .padding()
        }
        .navigationTitle("Instructores")
        .navigationBarTitleDisplayMode(.inline)
    }

    func fila(_ titulo: String, _ valor: Double) -> some View {
        HStack {
            Text(titulo)
            Spacer()
            Text("S/ \(valor, specifier: "%.2f")")
        }
    }

    func calcular() {
        guard let horas = Double(horasTexto), horas > 0 else {
            error = "Ingrese las horas semanales (mayor a 0)."
            resultado = nil
            return
        }
        guard horas <= PagoInstructoresCalculadora.horasMaximas else {
            error = "El máximo permitido es 23 horas semanales."
            resultado = nil
            return
        }
        error = nil
        resultado = PagoInstructoresCalculadora.calcular(horasSemanales: horas, sistema: sistema)
    }
}

#Preview {
    NavigationStack { PagoInstructoresView() }
}
