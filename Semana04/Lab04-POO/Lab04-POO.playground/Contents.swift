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
                + "+ envio S/ \(envio) = S/ \(total)"
        )
    }
}

class SucursalLima: Sucursal {
    override func descuento() -> Double {
        return 0.10
    }

    override func costoEnvio(monto: Double) -> Double {
        if monto >= 1500 {
            return 0.0
        }

        return 30.0
    }
}

class SucursalProvincia: Sucursal {
    override func costoEnvio(monto: Double) -> Double {
        let costoCalculado = monto * 0.08

        if costoCalculado < 50 {
            return 50.0
        }

        return costoCalculado
    }
}

class SucursalOutlet: Sucursal {
    override func descuento() -> Double {
        return 0.25
    }

    override func costoEnvio(monto: Double) -> Double {
        return 0.0
    }
}

class SucursalOnline: Sucursal {
    override func costoEnvio(monto: Double) -> Double {
        return 15.0
    }
}

let refrigeradora = Electrodomestico(
    nombre: "Refrigeradora",
    marca: "Samsung",
    precioLista: 2000.0,
    categoria: .lineaBlanca
)

let licuadora = Electrodomestico(
    nombre: "Licuadora",
    marca: "Oster",
    precioLista: 250.0,
    categoria: .pequenos
)

let sucursales: [Sucursal] = [
    SucursalLima(nombre: "Lima Centro", ciudad: "Lima"),
    SucursalProvincia(nombre: "Provincia Cusco", ciudad: "Cusco"),
    SucursalOutlet(nombre: "Outlet Ate", ciudad: "Lima")
]

let productos = [refrigeradora, licuadora]

for producto in productos {
    print("===== \(producto.nombre) (S/ \(producto.precioLista)) =====")

    for sucursal in sucursales {
        sucursal.cotizar(item: producto)
    }
}

let sucursalOnline = SucursalOnline(nombre: "Tienda Online", ciudad: "Lima")
let sucursalesConOnline: [Sucursal] = sucursales + [sucursalOnline]

print("===== Prueba de extensibilidad =====")
sucursalOnline.cotizar(item: refrigeradora)
print("Sucursales registradas después de la ampliación: \(sucursalesConOnline.count)")

// Se necesitaron seis líneas de código para agregar SucursalOnline y registrarla.
