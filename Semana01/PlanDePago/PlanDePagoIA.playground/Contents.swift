import UIKit // Permite utilizar herramientas básicas del ecosistema iOS.

let nombreProductoIA = "Laptop" // Guarda el nombre del producto.
let precioUnitarioIA = 2500.00 // Define el precio de una unidad.
let cantidadIA = 2 // Indica cuántas unidades se compran.
let planCuotasIA = 12 // Establece el plan de 6, 12 o 24 cuotas.
let cuotasPagadasIA = 3 // Indica cuántas cuotas ya fueron pagadas.
let mesPagoAdelantadoIA = 3 // Define el mes del pago adelantado.
let montoPagoAdelantadoIA = 1000.00 // Define el importe adicional del adelanto.

let fechaInicioIA = Calendar.current.date(
    from: DateComponents(year: 2026, month: 9, day: 26)
)! // Establece el 26/09/2026 como fecha inicial.

let montoCompraIA = precioUnitarioIA * Double(cantidadIA) // Multiplica precio por cantidad.

var porcentajeInteresIA: Double? // Almacena el interés correspondiente al plan.

func completarIA(_ texto: String, hasta longitud: Int) -> String { // Recibe un texto y una longitud.
    return texto.padding(
        toLength: longitud,
        withPad: " ",
        startingAt: 0
    ) // Agrega espacios para alinear las columnas.
}

switch planCuotasIA { // Evalúa el plan seleccionado.
case 6:
    porcentajeInteresIA = 0.20 // Aplica 20% para seis cuotas.
case 12:
    porcentajeInteresIA = 0.40 // Aplica 40% para doce cuotas.
case 24:
    porcentajeInteresIA = 0.60 // Aplica 60% para veinticuatro cuotas.
default:
    porcentajeInteresIA = nil // Marca como inválido cualquier otro valor.
}

if nombreProductoIA.trimmingCharacters(in: .whitespaces).isEmpty { // Valida el nombre.
    print("Error: debe ingresar el nombre del producto.") // Informa el error.
} else if precioUnitarioIA <= 0 { // Valida que el precio sea positivo.
    print("Error: el precio unitario debe ser mayor que cero.") // Informa el error.
} else if cantidadIA <= 0 { // Valida que la cantidad sea positiva.
    print("Error: la cantidad debe ser mayor que cero.") // Informa el error.
} else if cuotasPagadasIA < 0 || cuotasPagadasIA > planCuotasIA { // Valida las cuotas pagadas.
    print("Error: la cantidad de cuotas pagadas no es válida.") // Informa el error.
} else if mesPagoAdelantadoIA < 1 || mesPagoAdelantadoIA > planCuotasIA { // Valida el mes del adelanto.
    print("Error: el mes del pago adelantado no pertenece al plan.") // Informa el error.
} else if montoPagoAdelantadoIA < 0 { // Valida el monto adelantado.
    print("Error: el pago adelantado no puede ser negativo.") // Informa el error.
} else if let porcentajeInteresIA { // Continúa cuando el plan seleccionado es válido.
    let montoInteresIA = montoCompraIA * porcentajeInteresIA // Calcula el interés.
    let montoFinalIA = montoCompraIA + montoInteresIA // Suma compra e interés.
    let montoCuotaIA = montoFinalIA / Double(planCuotasIA) // Calcula la cuota mensual.
    let cuotasPendientesIA = planCuotasIA - cuotasPagadasIA // Calcula las cuotas pendientes.

    let formatoFechaIA = DateFormatter() // Crea un formato para las fechas.
    formatoFechaIA.dateFormat = "dd/MM/yyyy" // Establece día, mes y año.

    let calendarioIA = Calendar.current // Permite avanzar entre meses.

    print("")
    print("====================================================================================================")
    print("                                  PLAN DE PAGO CON IA")
    print("====================================================================================================")
    print("Producto: \(nombreProductoIA)")
    print("Precio unitario: S/. \(String(format: "%.2f", precioUnitarioIA))")
    print("Cantidad: \(cantidadIA)")
    print("Monto total de compra: S/. \(String(format: "%.2f", montoCompraIA))")
    print("----------------------------------------------------------------------------------------------------")
    print("Interés: \(Int(porcentajeInteresIA * 100))%")
    print("Plan seleccionado: \(planCuotasIA) cuotas")
    print("Monto de cuota: S/. \(String(format: "%.2f", montoCuotaIA))")
    print("Monto final: S/. \(String(format: "%.2f", montoFinalIA))")
    print("----------------------------------------------------------------------------------------------------")
    print("PROGRESO DEL PLAN")
    print("Has pagado \(cuotasPagadasIA) de \(planCuotasIA) cuotas.")
    print("Actualmente vas en la cuota \(cuotasPagadasIA).")
    print("Te faltan \(cuotasPendientesIA) cuotas del plan original.")
    print("----------------------------------------------------------------------------------------------------")
    print("PAGO ADELANTADO")
    print("Mes programado: \(mesPagoAdelantadoIA)")
    print("Monto adelantado: S/. \(String(format: "%.2f", montoPagoAdelantadoIA))")
    print("El adelanto reduce el saldo y permite terminar el plan antes.")
    print("----------------------------------------------------------------------------------------------------")

    let encabezadoIA =
        completarIA("Mes", hasta: 5) +
        completarIA("Fecha", hasta: 13) +
        completarIA("Monto inicial", hasta: 18) +
        completarIA("Cuota", hasta: 15) +
        completarIA("Adelanto", hasta: 15) +
        completarIA("Pago total", hasta: 16) +
        completarIA("Saldo", hasta: 17) +
        "Estado" // Construye las columnas del cronograma.

    print(encabezadoIA) // Imprime el encabezado.

    var saldoPendienteIA = montoFinalIA // Inicializa el saldo total.
    var ultimaCuotaIA = 0 // Guarda el último mes necesario para cancelar la deuda.

    for mesIA in 1...planCuotasIA { // Recorre las cuotas del plan.
        if saldoPendienteIA <= 0 { // Comprueba si la deuda ya terminó.
            break // Finaliza el ciclo cuando el saldo llega a cero.
        }

        let saldoInicialIA = saldoPendienteIA // Guarda el saldo antes del pago.
        let cuotaRegularIA = min(montoCuotaIA, saldoPendienteIA) // Calcula la cuota normal.

        var adelantoAplicadoIA = 0.0 // Inicializa en cero el adelanto del mes.

        if mesIA == mesPagoAdelantadoIA { // Comprueba si corresponde aplicar el adelanto.
            let saldoDespuesCuotaIA = max(
                0,
                saldoPendienteIA - cuotaRegularIA
            ) // Calcula el saldo que quedaría después de la cuota regular.

            adelantoAplicadoIA = min(
                montoPagoAdelantadoIA,
                saldoDespuesCuotaIA
            ) // Evita pagar más dinero que el saldo restante.
        }

        let pagoTotalIA = cuotaRegularIA + adelantoAplicadoIA // Suma cuota y adelanto.

        saldoPendienteIA -= pagoTotalIA // Resta el pago total del saldo.

        if saldoPendienteIA < 0.01 { // Comprueba residuos decimales.
            saldoPendienteIA = 0 // Deja el saldo exactamente en cero.
        }

        let fechaCuotaIA = calendarioIA.date(
            byAdding: .month,
            value: mesIA - 1,
            to: fechaInicioIA
        )! // Calcula la fecha mensual.

        var estadoIA = mesIA <= cuotasPagadasIA ? "Pagada" : "Pendiente" // Determina el estado.

        if mesIA == mesPagoAdelantadoIA && adelantoAplicadoIA > 0 { // Detecta el adelanto.
            estadoIA = "Pagada + adelanto" // Marca el pago extraordinario.
        }

        ultimaCuotaIA = mesIA // Actualiza el último mes utilizado.

        let filaIA =
            completarIA("\(mesIA)", hasta: 5) +
            completarIA(formatoFechaIA.string(from: fechaCuotaIA), hasta: 13) +
            completarIA("S/. \(String(format: "%.2f", saldoInicialIA))", hasta: 18) +
            completarIA("S/. \(String(format: "%.2f", cuotaRegularIA))", hasta: 15) +
            completarIA("S/. \(String(format: "%.2f", adelantoAplicadoIA))", hasta: 15) +
            completarIA("S/. \(String(format: "%.2f", pagoTotalIA))", hasta: 16) +
            completarIA("S/. \(String(format: "%.2f", saldoPendienteIA))", hasta: 17) +
            estadoIA // Construye una fila completa.

        print(filaIA) // Imprime la fila del cronograma.
    }

    print("----------------------------------------------------------------------------------------------------")
    print("RESULTADO DEL ADELANTO")
    print("El plan original tenía \(planCuotasIA) cuotas.")
    print("Con el adelanto, la deuda termina en la cuota \(ultimaCuotaIA).")
    print("Cuotas reducidas: \(planCuotasIA - ultimaCuotaIA).")
    print("====================================================================================================")
} else { // Atiende un plan diferente de 6, 12 o 24.
    print("Error: solamente puede elegir planes de 6, 12 o 24 cuotas.") // Informa los planes permitidos.
}
