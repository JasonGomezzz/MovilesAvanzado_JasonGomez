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

class SucursalMall: Sucursal {
    // FIX: agregamos override porque descuento() ya existe en la clase Sucursal.
    override func descuento() -> Double {
        return 0.12
    }
}

class SucursalExpress: Sucursal {
    let radioKm: Double

    init(nombre: String, ciudad: String, radioKm: Double) {
        self.radioKm = radioKm

        // FIX: inicializamos las propiedades heredadas mediante el inicializador de Sucursal.
        super.init(nombre: nombre, ciudad: ciudad)
    }
}

let sucursalMall = SucursalMall(nombre: "Mall del Sur", ciudad: "Lima")
let sucursalExpress = SucursalExpress(
    nombre: "Express Miraflores",
    ciudad: "Lima",
    radioKm: 8.0
)

print("===== Correcciones de herencia =====")
print("Descuento de \(sucursalMall.nombre): \(sucursalMall.descuento())")
print("Radio de \(sucursalExpress.nombre): \(sucursalExpress.radioKm) km")

let misteriosa: Sucursal = SucursalLima(nombre: "Lima Norte", ciudad: "Lima")
let montoMisterioso = 2000.0 * (1 - misteriosa.descuento())

print("===== Predicciones =====")
print("Predicción 1 - descuento: \(misteriosa.descuento())")
print("Predicción 2 - envío: \(misteriosa.costoEnvio(monto: montoMisterioso))")

// Se obtiene 0.1 porque Swift ejecuta el método sobrescrito de SucursalLima.
// Se obtiene 0.0 porque el monto con descuento es S/ 1800 y supera S/ 1500.

enum EstadoLibro {
    case disponible
    case prestado
}

struct Libro {
    let titulo: String
    let autor: String
    var estado: EstadoLibro = .disponible
}

class Biblioteca {
    var libros: [Libro] = []

    func agregar(libro: Libro) {
        libros.append(libro)
    }

    func prestar(titulo: String) -> Bool {
        for i in 0..<libros.count {
            if libros[i].titulo == titulo {
                if libros[i].estado == .disponible {
                    libros[i].estado = .prestado
                    print("Préstamo aprobado: \(titulo)")
                    return true
                }

                print("Error: \(titulo) ya está prestado")
                return false
            }
        }

        print("Error: no existe \(titulo)")
        return false
    }

    func devolver(titulo: String) -> Bool {
        for i in 0..<libros.count {
            if libros[i].titulo == titulo {
                if libros[i].estado == .prestado {
                    libros[i].estado = .disponible
                    print("Devolución registrada: \(titulo)")
                    return true
                }

                print("Error: \(titulo) no está prestado")
                return false
            }
        }

        print("Error: no existe \(titulo)")
        return false
    }

    func inventario() {
        print("===== INVENTARIO =====")

        for libro in libros {
            var estadoTexto = ""

            switch libro.estado {
            case .disponible:
                estadoTexto = "disponible"
            case .prestado:
                estadoTexto = "prestado"
            }

            print("\(libro.titulo) (\(libro.autor)) - \(estadoTexto)")
        }
    }
}

let biblioteca = Biblioteca()

biblioteca.agregar(
    libro: Libro(titulo: "Cien años de soledad", autor: "Gabriel García Márquez")
)
biblioteca.agregar(
    libro: Libro(titulo: "La ciudad y los perros", autor: "Mario Vargas Llosa")
)
biblioteca.agregar(
    libro: Libro(titulo: "El Quijote", autor: "Miguel de Cervantes")
)

print("===== Caso 2A: Biblioteca =====")
_ = biblioteca.prestar(titulo: "La ciudad y los perros")
_ = biblioteca.prestar(titulo: "La ciudad y los perros")
_ = biblioteca.devolver(titulo: "La ciudad y los perros")
_ = biblioteca.prestar(titulo: "El Quijote")
_ = biblioteca.prestar(titulo: "El Principito")
biblioteca.inventario()

struct CursoLibre {
    let nombre: String
    let precio: Double
}

struct DetalleMatricula {
    let curso: CursoLibre
    let cantidad: Int
}

struct AlumnoCursos {
    let nombre: String
    let dni: String
    let esAlumnoTecsup: Bool
}

class MatriculaCursos {
    let alumno: AlumnoCursos
    var detalles: [DetalleMatricula] = []

    init(alumno: AlumnoCursos) {
        self.alumno = alumno
    }

    func agregar(curso: CursoLibre, cantidad: Int) {
        detalles.append(DetalleMatricula(curso: curso, cantidad: cantidad))
    }

    func cantidadCursos() -> Int {
        var cantidadTotal = 0

        for detalle in detalles {
            cantidadTotal += detalle.cantidad
        }

        return cantidadTotal
    }

    func subtotal() -> Double {
        var acumulado = 0.0

        for detalle in detalles {
            acumulado += detalle.curso.precio * Double(detalle.cantidad)
        }

        return acumulado
    }

    func mostrarComprobante() {
        let montoSubtotal = subtotal()
        let igv = montoSubtotal * 0.18
        let totalConIgv = montoSubtotal + igv
        let aplicaDescuento = cantidadCursos() >= 3
        let descuentoCursos = aplicaDescuento ? totalConIgv * 0.10 : 0.0
        let descuentoTecsup = aplicaDescuento && alumno.esAlumnoTecsup ? 400.0 : 0.0
        let totalFinal = totalConIgv - descuentoCursos - descuentoTecsup

        print("===== MATRÍCULA DE CURSOS LIBRES =====")
        print("Alumno: \(alumno.nombre)")
        print("DNI: \(alumno.dni)")
        print("Alumno Tecsup: \(alumno.esAlumnoTecsup ? "Sí" : "No")")

        for detalle in detalles {
            let importe = detalle.curso.precio * Double(detalle.cantidad)
            print(
                "\(detalle.curso.nombre) x\(detalle.cantidad): "
                    + String(format: "S/ %.2f", importe)
            )
        }

        print(String(format: "Subtotal: S/ %.2f", montoSubtotal))
        print(String(format: "IGV (18%%): S/ %.2f", igv))
        print(String(format: "Total con IGV: S/ %.2f", totalConIgv))
        print(String(format: "Descuento por 3 o más cursos: S/ %.2f", descuentoCursos))
        print(String(format: "Descuento alumno Tecsup: S/ %.2f", descuentoTecsup))
        print(String(format: "Total final: S/ %.2f", totalFinal))
    }
}

let matricula = MatriculaCursos(
    alumno: AlumnoCursos(nombre: "Juan León", dni: "78965412", esAlumnoTecsup: true)
)

matricula.agregar(
    curso: CursoLibre(nombre: "Swift Avanzado", precio: 450.0),
    cantidad: 1
)
matricula.agregar(
    curso: CursoLibre(nombre: "IA con Python", precio: 650.0),
    cantidad: 2
)
matricula.agregar(
    curso: CursoLibre(nombre: "Diseño UX/UI", precio: 500.0),
    cantidad: 1
)

matricula.mostrarComprobante()
