import UIKit // Permite utilizar herramientas básicas del ecosistema iOS.

let nombreProductoIA = "Laptop" // Guarda el nombre del producto seleccionado.
let precioUnitarioIA = 2500.00 // Define el precio correspondiente a una unidad.
let cantidadIA = 2 // Indica cuántas unidades se están comprando.
let planCuotasIA = 12 // Establece el plan seleccionado: 6, 12 o 24 cuotas.
let cuotasPagadasIA = 3 // Simula cuántas cuotas ya fueron pagadas.

let fechaInicioIA = Calendar.current.date(
    from: DateComponents(year: 2026, month: 9, day: 26)
)! // Establece el 26/09/2026 como fecha inicial del cronograma.

let montoCompraIA = precioUnitarioIA * Double(cantidadIA) // Calcula precio por cantidad.

var porcentajeInteresIA: Double? // Almacena el interés solamente si el plan es válido.

func completarIA(_ texto: String, hasta longitud: Int) -> String { // Recibe un texto y el espacio asignado.
    return texto.padding(
        toLength: longitud,
        withPad: " ",
        startingAt: 0
    ) // Agrega espacios para alinear las columnas.
}

switch planCuotasIA { // Evalúa cuál de los tres planes fue seleccionado.
case 6:
    porcentajeInteresIA = 0.20 // Asigna 20% de interés para seis cuotas.
case 12:
    porcentajeInteresIA = 0.40 // Asigna 40% de interés para doce cuotas.
case 24:
    porcentajeInteresIA = 0.60 // Asigna 60% de interés para veinticuatro cuotas.
default:
    porcentajeInteresIA = nil // Marca como inválido cualquier plan diferente.
}

if nombreProductoIA.trimmingCharacters(in: .whitespaces).isEmpty { // Verifica que exista un nombre.
    print("Error: debe ingresar el nombre del producto.") // Informa el error encontrado.
} else if precioUnitarioIA <= 0 { // Comprueba que el precio sea positivo.
    print("Error: el precio unitario debe ser mayor que cero.") // Informa el precio inválido.
} else if cantidadIA <= 0 { // Comprueba que la cantidad sea positiva.
    print("Error: la cantidad debe ser mayor que cero.") // Informa la cantidad inválida.
} else if cuotasPagadasIA < 0 || cuotasPagadasIA > planCuotasIA { // Valida el progreso de pagos.
    print("Error: la cantidad de cuotas pagadas no es válida.") // Informa el progreso inválido.
} else if let porcentajeInteresIA { // Continúa solamente cuando el plan es válido.
    let montoInteresIA = montoCompraIA * porcentajeInteresIA // Calcula el importe del interés.
    let montoFinalIA = montoCompraIA + montoInteresIA // Suma la compra y el interés.
    let montoCuotaIA = montoFinalIA / Double(planCuotasIA) // Divide el total entre las cuotas.
    let cuotasPendientesIA = planCuotasIA - cuotasPagadasIA // Calcula las cuotas pendientes.

    let formatoFechaIA = DateFormatter() // Crea el formato para mostrar las fechas.
    formatoFechaIA.dateFormat = "dd/MM/yyyy" // Establece día, mes y año.

    let calendarioIA = Calendar.current // Permite avanzar un mes por cada cuota.

    print("")
    print("==========================================================================")
    print("                          PLAN DE PAGO CON IA")
    print("==========================================================================")
    print("Producto: \(nombreProductoIA)")
    print("Precio unitario: S/. \(String(format: "%.2f", precioUnitarioIA))")
    print("Cantidad: \(cantidadIA)")
    print("Monto de compra: S/. \(String(format: "%.2f", montoCompraIA))")
    print("--------------------------------------------------------------------------")
    print("Interés: \(Int(porcentajeInteresIA * 100))%")
    print("Cuotas: \(planCuotasIA)")
    print("Monto de cuota: S/. \(String(format: "%.2f", montoCuotaIA))")
    print("Monto final: S/. \(String(format: "%.2f", montoFinalIA))")
    print("--------------------------------------------------------------------------")
    print("PROGRESO DEL PLAN")
    print("Has pagado \(cuotasPagadasIA) de \(planCuotasIA) cuotas.")
    print("Te faltan \(cuotasPendientesIA) cuotas por pagar.")
    print("--------------------------------------------------------------------------")

    let encabezadoIA =
        completarIA("Mes", hasta: 6) +
        completarIA("Fecha", hasta: 14) +
        completarIA("Monto inicial", hasta: 19) +
        completarIA("Pago", hasta: 15) +
        completarIA("Saldo", hasta: 17) +
        "Estado" // Construye el encabezado de la tabla.

    print(encabezadoIA) // Muestra las columnas del cronograma.

    var saldoPendienteIA = montoFinalIA // Inicializa el saldo total del financiamiento.

    for mesIA in 1...planCuotasIA { // Recorre cada cuota del plan.
        let saldoInicialIA = saldoPendienteIA // Guarda el saldo antes del pago.
        let pagoIA = min(montoCuotaIA, saldoPendienteIA) // Evita pagar más que el saldo.
        let fechaCuotaIA = calendarioIA.date(
            byAdding: .month,
            value: mesIA - 1,
            to: fechaInicioIA
        )! // Calcula la fecha correspondiente al mes.

        let estadoIA = mesIA <= cuotasPagadasIA ? "Pagada" : "Pendiente" // Determina el estado.

        saldoPendienteIA -= pagoIA // Resta la cuota del saldo pendiente.

        if saldoPendienteIA < 0.01 { // Comprueba si queda un residuo decimal.
            saldoPendienteIA = 0 // Deja el último saldo exactamente en cero.
        }

        let textoMesIA = "\(mesIA)" // Convierte el número del mes en texto.
        let textoFechaIA = formatoFechaIA.string(from: fechaCuotaIA) // Convierte la fecha.
        let textoMontoIA = "S/. \(String(format: "%.2f", saldoInicialIA))" // Formatea el saldo inicial.
        let textoPagoIA = "S/. \(String(format: "%.2f", pagoIA))" // Formatea la cuota.
        let textoSaldoIA = "S/. \(String(format: "%.2f", saldoPendienteIA))" // Formatea el saldo restante.

        let filaIA =
            completarIA(textoMesIA, hasta: 6) +
            completarIA(textoFechaIA, hasta: 14) +
            completarIA(textoMontoIA, hasta: 19) +
            completarIA(textoPagoIA, hasta: 15) +
            completarIA(textoSaldoIA, hasta: 17) +
            estadoIA // Construye una fila alineada.

        print(filaIA) // Muestra la cuota correspondiente.
    }

    print("==========================================================================")
} else { // Atiende un plan que no sea 6, 12 o 24.
    print("Error: solamente puede elegir planes de 6, 12 o 24 cuotas.") // Informa los planes aceptados.
}
