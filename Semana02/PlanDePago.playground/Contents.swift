import Foundation
//Plan de pago por cuotas con intereses

print("ingrese el nombre del producto")
let producto = readLine() ?? ""
print("ingrese el precio del producto")
let precio = Double(readLine() ?? "0") ?? 0.0
print("ingrese la cantidad de producto")
let cantidad = Int(readLine() ?? "0") ?? 0

let montoTotalCompra = precio * Double(cantidad)
print("Monto total de la compra: \(montoTotalCompra)")

var greeting = "Hello, playground"
