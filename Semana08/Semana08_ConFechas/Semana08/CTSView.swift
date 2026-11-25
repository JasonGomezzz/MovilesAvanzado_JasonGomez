//
//  CTSView.swift
//  Semana08
//
//  Pantalla para calcular la CTS. Meses y días salen de las fechas.
//

import SwiftUI

struct CTSView: View {
    // semestre y fechas
    @State private var semestre: SemestreCTS
    @State private var anio: Int
    @State private var ingreso: Date
    @State private var dejoDeTrabajar = false
    @State private var cese: Date
    // datos del trabajador
    @State private var jornadaCompleta = true
    @State private var tieneHijos = false
    @State private var sueldoTexto = ""
    // extras, faltas y licencias
    @State private var tipoExtra: TipoExtra = .horas
    @State private var horasInicialesTexto = ""
    @State private var horasAdicionalesTexto = ""
    @State private var diasExtrasTexto = ""
    @State private var mesesConExtras = 0
    @State private var faltasTexto = ""
    @State private var licenciasTexto = ""
    // resultado y mensaje de error
    @State private var montoExtras = 0.0
    @State private var resultado: ResultadoCTS?
    @State private var error: String?

    /// Arranca en el semestre vigente hoy y con ingreso al inicio de la gratificación
    init() {
        let c = Fechas.calendario.dateComponents([.year, .month], from: Date())
        let sem: SemestreCTS
        let a: Int
        switch c.month! {
        case 5...10: sem = .mayOct; a = c.year!
        case 11, 12: sem = .novAbr; a = c.year!
        default: sem = .novAbr; a = c.year! - 1
        }
        _semestre = State(initialValue: sem)
        _anio = State(initialValue: a)
        _ingreso = State(initialValue: sem.periodoGratificacion(anio: a).inicio)
        _cese = State(initialValue: sem.periodoCTS(anio: a).fin)
    }

    var anios: [Int] {
        let actual = Fechas.calendario.component(.year, from: Date())
        return Array((actual - 2)...(actual + 1))
    }

    // cálculos automáticos a partir de las fechas
    var periodoCTS: (inicio: Date, fin: Date) { semestre.periodoCTS(anio: anio) }
    var periodoGrat: (inicio: Date, fin: Date) { semestre.periodoGratificacion(anio: anio) }
    var ceseOpcional: Date? { dejoDeTrabajar ? cese : nil }
    var servicioCTS: TiempoServicio? {
        Fechas.servicio(ingreso: ingreso, inicio: periodoCTS.inicio, fin: periodoCTS.fin, cese: ceseOpcional)
    }
    var mesesGratificacion: Int {
        Fechas.servicio(ingreso: ingreso, inicio: periodoGrat.inicio, fin: periodoGrat.fin, cese: ceseOpcional)?.meses ?? 0
    }
    /// Los meses con extras no pueden superar los meses en que trabajó
    var maxMesesExtras: Int {
        guard let s = servicioCTS else { return 0 }
        return min(s.meses + (s.dias > 0 ? 1 : 0), CTSCalculadora.mesesSemestre)
    }
    var asignacion: Double { tieneHijos ? CTSCalculadora.asignacionFamiliar : 0 }

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                Text("Calculadora de CTS")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)

                Picker("Semestre", selection: $semestre) {
                    ForEach(SemestreCTS.allCases) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented)

                HStack {
                    Text("Año en que inicia el semestre")
                    Spacer()
                    Picker("Año", selection: $anio) {
                        ForEach(anios, id: \.self) { Text(String($0)).tag($0) }
                    }
                }

                Text("Del \(fmt(periodoCTS.inicio)) al \(fmt(periodoCTS.fin)) · depósito hasta el \(semestre.deposito)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                DatePicker("Fecha de ingreso", selection: $ingreso, displayedComponents: .date)
                Toggle("Ya dejó de trabajar (fecha de cese)", isOn: $dejoDeTrabajar)
                if dejoDeTrabajar {
                    DatePicker("Fecha de cese", selection: $cese, displayedComponents: .date)
                }

                Toggle("Jornada de 4 horas diarias o más", isOn: $jornadaCompleta)
                campo("Sueldo mensual S/.", texto: $sueldoTexto)
                Toggle("Tiene hijos menores de 18 años", isOn: $tieneHijos)
                if tieneHijos {
                    Text("Asignación familiar: S/ \(asignacion, specifier: "%.2f") (10% de la RMV de S/ \(CTSCalculadora.rmv, specifier: "%.0f"))")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                extrasSeccion

                campo("Faltas injustificadas (días)", texto: $faltasTexto, teclado: .numberPad)
                campo("Licencias sin goce de haber (días)", texto: $licenciasTexto, teclado: .numberPad)

                resumenAutomatico

                Text("Las vacaciones y las licencias con goce cuentan como tiempo trabajado: no se descuentan.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                Button(action: calcular) {
                    Text("Calcular CTS")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }

                if let error {
                    Text(error).foregroundStyle(.red)
                }

                if let r = resultado {
                    detalle(r)
                }
            }
            .padding()
        }
        .onChange(of: maxMesesExtras) {
            mesesConExtras = min(mesesConExtras, maxMesesExtras)
        }
        .navigationTitle("CTS")
        .navigationBarTitleDisplayMode(.inline)
    }

    var extrasSeccion: some View {
        VStack(spacing: 10) {
            Picker("Tipo de extra", selection: $tipoExtra) {
                ForEach(TipoExtra.allCases) { Text($0.rawValue).tag($0) }
            }
            .pickerStyle(.segmented)

            if tipoExtra == .horas {
                campo("Horas extras dentro de las 2 primeras del día (25%)", texto: $horasInicialesTexto)
                campo("Horas extras desde la tercera hora del día (35%)", texto: $horasAdicionalesTexto)
            } else {
                campo("Total de días extras en el semestre", texto: $diasExtrasTexto, teclado: .numberPad)
            }

            Stepper("Meses con horas o días extras: \(mesesConExtras)",
                    value: $mesesConExtras, in: 0...maxMesesExtras)
            Text("\(tipoExtra.nota). Escriba solo números (totales del semestre). Cuentan si hubo en al menos 3 meses: se suma 1/6 del pago total. Máximo: los meses trabajados.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }

    /// Datos que se calculan solos con las fechas
    var resumenAutomatico: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Calculado automáticamente").font(.subheadline.bold())
            if let s = servicioCTS {
                fila("Meses completos en el semestre", "\(s.meses)")
                fila("Días adicionales", "\(s.dias)")
                if s.meses == 0 {
                    Text("Menos de 1 mes de servicio en el semestre: verifique si corresponde CTS.")
                        .font(.footnote)
                        .foregroundStyle(.orange)
                }
            } else {
                Text("No corresponde CTS en este semestre: ingresó después del cierre o dejó de trabajar antes del inicio.")
                    .foregroundStyle(.red)
            }
            fila("Meses para la gratificación de \(semestre.gratificacion)", "\(mesesGratificacion)")
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    func campo(_ titulo: String, texto: Binding<String>, teclado: UIKeyboardType = .decimalPad) -> some View {
        TextField(titulo, text: texto)
            .textFieldStyle(.roundedBorder)
            .keyboardType(teclado)
    }

    func detalle(_ r: ResultadoCTS) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            filaMonto("Asignación familiar", r.asignacionFamiliar)
            filaMonto("Pago de \(tipoExtra.rawValue.lowercased())", montoExtras)
            filaMonto("Promedio de extras (1/6)", r.promedioExtras)
            filaMonto("Gratificación de \(semestre.gratificacion) (calculada)", r.gratificacion)
            filaMonto("1/6 de gratificación", r.sextoGratificacion)
            filaMonto("Remuneración computable", r.remuneracionComputable)
            filaMonto("Por \(servicioCTS?.meses ?? 0) mes(es)", r.montoPorMeses)
            filaMonto("Por \(servicioCTS?.dias ?? 0) día(s)", r.montoPorDias)
            filaMonto("Descuento por faltas y licencias", r.descuentoDias == 0 ? 0 : -r.descuentoDias)
            Divider()
            HStack {
                Text("CTS a depositar").font(.title3.bold())
                Spacer()
                Text("S/ \(r.total, specifier: "%.2f")").font(.title3.bold())
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    func fila(_ titulo: String, _ valor: String) -> some View {
        HStack {
            Text(titulo)
            Spacer()
            Text(valor).bold()
        }
    }

    func filaMonto(_ titulo: String, _ valor: Double) -> some View {
        HStack {
            Text(titulo)
            Spacer()
            Text("S/ \(valor, specifier: "%.2f")")
        }
    }

    func fmt(_ fecha: Date) -> String {
        fecha.formatted(.dateTime.day().month(.twoDigits).year())
    }

    /// Vacío cuenta como 0; si hay letras u otros símbolos devuelve nil
    func leer(_ texto: String) -> Double? {
        let t = texto.trimmingCharacters(in: .whitespaces)
        return t.isEmpty ? 0 : Double(t)
    }

    func fallo(_ mensaje: String) {
        error = mensaje
        resultado = nil
    }

    func calcular() {
        guard jornadaCompleta else {
            return fallo("No corresponde CTS: la jornada es menor a 4 horas diarias.")
        }
        guard let sueldo = Double(sueldoTexto), sueldo > 0 else {
            return fallo("Ingrese un sueldo válido mayor a 0.")
        }
        if dejoDeTrabajar, cese < ingreso {
            return fallo("La fecha de cese no puede ser anterior a la de ingreso.")
        }
        guard let servicio = servicioCTS else {
            return fallo("No corresponde CTS en este semestre: ingresó después del cierre o dejó de trabajar antes del inicio.")
        }
        guard let horasIniciales = leer(horasInicialesTexto),
              let horasAdicionales = leer(horasAdicionalesTexto),
              let diasExtras = leer(diasExtrasTexto),
              let faltasValor = leer(faltasTexto),
              let licenciasValor = leer(licenciasTexto) else {
            return fallo("Use solo números en los campos (sin letras como 30D o 6H).")
        }
        guard horasIniciales >= 0, horasAdicionales >= 0, diasExtras >= 0,
              faltasValor >= 0, licenciasValor >= 0 else {
            return fallo("Ningún valor puede ser negativo.")
        }
        guard faltasValor == faltasValor.rounded(), licenciasValor == licenciasValor.rounded() else {
            return fallo("Las faltas y licencias deben ser días enteros.")
        }
        let descontados = Int(faltasValor) + Int(licenciasValor)
        let diasTrabajados = servicio.meses * 30 + servicio.dias
        guard descontados <= diasTrabajados else {
            return fallo("Las faltas y licencias no pueden superar los días trabajados (\(diasTrabajados)).")
        }

        let hayExtras: Bool
        switch tipoExtra {
        case .horas:
            hayExtras = horasIniciales + horasAdicionales > 0
            let maxHoras = CTSCalculadora.horasExtrasSemanales * Double(diasTrabajados) / 7
            guard horasIniciales + horasAdicionales <= maxHoras else {
                return fallo("Las horas extras superan el máximo de 12 por semana (\(Int(maxHoras)) horas en este período).")
            }
        case .dias:
            hayExtras = diasExtras > 0
            guard diasExtras == diasExtras.rounded(), diasExtras <= Double(diasTrabajados) else {
                return fallo("Los días extras deben ser enteros y no superar los días trabajados (\(diasTrabajados)).")
            }
        }
        guard !hayExtras || mesesConExtras > 0 else {
            return fallo("Indique en cuántos meses del semestre hubo horas o días extras.")
        }

        error = nil
        montoExtras = CTSCalculadora.montoExtras(tipo: tipoExtra, horasIniciales: horasIniciales,
                                                 horasAdicionales: horasAdicionales,
                                                 dias: diasExtras, sueldo: sueldo)
        resultado = CTSCalculadora.calcular(sueldo: sueldo,
                                            asignacionFamiliar: asignacion,
                                            extrasTotal: montoExtras,
                                            mesesConExtras: mesesConExtras,
                                            mesesGratificacion: mesesGratificacion,
                                            meses: servicio.meses,
                                            dias: servicio.dias,
                                            diasDescontados: descontados)
    }
}

#Preview {
    NavigationStack { CTSView() }
}
