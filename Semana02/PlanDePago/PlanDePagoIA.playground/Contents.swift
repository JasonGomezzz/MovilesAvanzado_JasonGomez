import UIKit // Permite utilizar herramientas básicas del ecosistema iOS.

let nombreProductoIA = "Laptop" // Guarda el nombre del producto seleccionado.
let precioUnitarioIA = 2500.00 // Define el precio correspondiente a una unidad.
let cantidadIA = 2 // Indica cuántas unidades se están comprando.
let planCuotasIA = 12 // Establece el plan seleccionado: 6, 12 o 24 cuotas.
let cuotasPagadasIA = 3 // Simula cuántas cuotas ya fueron pagadas.
let fechaInicioIA = Date() // Utiliza la fecha actual como inicio del cronograma.

let montoCompraIA = precioUnitarioIA * Double(cantidadIA) // Calcula precio por cantidad.

var porcentajeInteresIA: Double? // Almacena el interés solamente si el plan es válido.

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
    let cuotasPendientesIA = planCuotasIA - cuotasPagadasIA // Calcula las cuotas que faltan.

    let formatoFechaIA = DateFormatter() // Crea el formato utilizado para mostrar las fechas.
    formatoFechaIA.dateFormat = "dd/MM/yyyy" // Establece día, mes y año.
    let calendarioIA = Calendar.current // Permite avanzar un mes en cada cuota.

    print("========== PLAN DE PAGO CON IA ==========") // Muestra el encabezado.
    print("Producto: \(nombreProductoIA)") // Muestra el producto.
    print("Precio unitario: S/. \(String(format: "%.2f", precioUnitarioIA))") // Muestra el precio.
    print("Cantidad: \(cantidadIA)") // Muestra la cantidad.
    print("Monto de compra: S/. \(String(format: "%.2f", montoCompraIA))") // Muestra el subtotal.
    print("Interés: \(Int(porcentajeInteresIA * 100))%") // Muestra el porcentaje elegido.
    print("Cuotas: \(planCuotasIA)") // Muestra la cantidad total de cuotas.
    print("Monto de cuota: S/. \(String(format: "%.2f", montoCuotaIA))") // Muestra la cuota.
    print("Monto final: S/. \(String(format: "%.2f", montoFinalIA))") // Muestra el total.
    print("Progreso: pagaste \(cuotasPagadasIA) de \(planCuotasIA) cuotas.") // Muestra el progreso.
    print("Cuotas pendientes: \(cuotasPendientesIA)") // Muestra cuántas cuotas faltan.

    print("\nMes\tFecha\t\tMonto inicial\tPago\t\tEstado") // Imprime las columnas.

    var saldoPendienteIA = montoFinalIA // Inicializa el saldo completo del financiamiento.

    for mesIA in 1...planCuotasIA { // Recorre cada mes del financiamiento.
        let saldoInicialIA = saldoPendienteIA // Conserva el saldo antes de pagar.
        let pagoIA = min(montoCuotaIA, saldoPendienteIA) // Evita pagar más que el saldo restante.
        let fechaCuotaIA = calendarioIA.date(byAdding: .month, value: mesIA - 1, to: fechaInicioIA)! // Calcula la fecha.
        let estadoIA = mesIA <= cuotasPagadasIA ? "Pagada" : "Pendiente" // Identifica el estado.

        saldoPendienteIA -= pagoIA // Resta la cuota mensual al saldo pendiente.

        if saldoPendienteIA < 0.01 { // Corrige posibles decimales residuales.
            saldoPendienteIA = 0 // Deja el último saldo exactamente en cero.
        }

        print("\(mesIA)\t\(formatoFechaIA.string(from: fechaCuotaIA))\tS/. \(String(format: "%.2f", saldoInicialIA))\tS/. \(String(format: "%.2f", pagoIA))\t\(estadoIA)") // Muestra la fila.
    }
} else { // Atiende un plan que no sea 6, 12 o 24.
    print("Error: solamente puede elegir planes de 6, 12 o 24 cuotas.") // Informa los valores aceptados.
}
