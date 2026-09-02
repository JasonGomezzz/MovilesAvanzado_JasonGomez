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
