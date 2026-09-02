import UIKit

let nombreProducto = "Laptop"
let precioUnitario = 2500.00
let cantidad = 2
let planCuotas = 12

let montoCompra = precioUnitario * Double(cantidad)

var porcentajeInteres = 0.0
var planValido = true

switch planCuotas {
case 6:
    porcentajeInteres = 0.20
case 12:
    porcentajeInteres = 0.40
case 24:
    porcentajeInteres = 0.60
default:
    planValido = false
}

if precioUnitario <= 0 || cantidad <= 0 {
    print("Error: el precio y la cantidad deben ser mayores que cero.")
} else if !planValido {
    print("Error: solamente puede elegir 6, 12 o 24 cuotas.")
} else {
    let montoInteres = montoCompra * porcentajeInteres
    let montoFinal = montoCompra + montoInteres
    let montoCuota = montoFinal / Double(planCuotas)

    print("========== PLAN DE PAGO MANUAL ==========")
    print("Producto: \(nombreProducto)")
    print("Precio unitario: S/. \(String(format: "%.2f", precioUnitario))")
    print("Cantidad: \(cantidad)")
    print("Monto de compra: S/. \(String(format: "%.2f", montoCompra))")
    print("Interés: \(Int(porcentajeInteres * 100))%")
    print("Cuotas: \(planCuotas)")
    print("Monto de cuota: S/. \(String(format: "%.2f", montoCuota))")
    print("Monto final: S/. \(String(format: "%.2f", montoFinal))")
}

if precioUnitario > 0 && cantidad > 0 && planValido {
    let montoInteres = montoCompra * porcentajeInteres
    let montoFinal = montoCompra + montoInteres
    let montoCuota = montoFinal / Double(planCuotas)
    var saldoPendiente = montoFinal

    print("\nMes\tMonto inicial\tCuota mensual\tResta por pagar")

    for mes in 1...planCuotas {
        let saldoInicial = saldoPendiente
        let pago = min(montoCuota, saldoPendiente)
        saldoPendiente -= pago

        if saldoPendiente < 0.01 {
            saldoPendiente = 0
        }

        print("\(mes)\tS/. \(String(format: "%.2f", saldoInicial))\tS/. \(String(format: "%.2f", pago))\tS/. \(String(format: "%.2f", saldoPendiente))")
    }
}
