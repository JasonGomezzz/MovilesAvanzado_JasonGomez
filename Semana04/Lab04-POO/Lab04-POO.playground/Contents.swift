// Desarrollado por: Jason Gomez

import Foundation

print("Laboratorio 04 - Programación Orientada a Objetos en Swift")

enum CategoriaElectro {
    case lineaBlanca
    case tecnologia
    case pequenos
}

struct Electrodomestico {
    let nombre: String
    let marca: String
    let precioLista: Double
    let categoria: CategoriaElectro
}

class Sucursal {
    let nombre: String
    let ciudad: String

    init(nombre: String, ciudad: String) {
        self.nombre = nombre
        self.ciudad = ciudad
    }

    func descuento() -> Double {
        return 0.05
    }

    func costoEnvio(monto: Double) -> Double {
        return 30.0
    }

    func cotizar(item: Electrodomestico) {
        let precioConDescuento = item.precioLista * (1 - descuento())
        let envio = costoEnvio(monto: precioConDescuento)
        let total = precioConDescuento + envio

        print(
            "\(nombre): \(item.nombre) -> S/ \(precioConDescuento) "
                + "+ envío S/ \(envio) = S/ \(total)"
        )
    }
}
