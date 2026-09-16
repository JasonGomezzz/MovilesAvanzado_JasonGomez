// Desarrollado por: Jason Gomez

import Foundation

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

        print(String(format: "Cantidad de cursos: %d", cantidadCursos()))
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
