// Desarrollado por: Jason Gomez

import Foundation

// ========================================
// EJERCICIO 1 - ARRAYS
// ========================================

// ===== TODO 1: Registro de 5 alumnos =====

var alumnos: [String] = []

for i in 1...5 {
    print("Nombre del alumno \(i):")
    let nombre = readLine() ?? ""
    alumnos.append(nombre)
}

print("\nAlumnos registrados: \(alumnos)")


// ===== TODO 2: Buscar un alumno =====

print("\nBuscar alumno:")
let buscar = readLine() ?? ""

if alumnos.contains(buscar) {
    print("\(buscar) está en la lista")
} else {
    print("\(buscar) NO está en la lista")
}


// ===== TODO 3: Notas con clasificación =====

var notasClase: [Double] = []

for i in 1...5 {
    print("Nota del alumno \(i):")
    let nota = Double(readLine() ?? "") ?? 0
    notasClase.append(nota)
}

var aprobados = 0
var desaprobados = 0
var sumaNotas = 0.0

for nota in notasClase {
    sumaNotas += nota

    if nota >= 13 {
        aprobados += 1
    } else {
        desaprobados += 1
    }
}

if !notasClase.isEmpty {
    let promedio = sumaNotas / Double(notasClase.count)

    print("\nPromedio: \(promedio)")
    print("Aprobados: \(aprobados)")
    print("Desaprobados: \(desaprobados)")
}


// ========================================
// FIX: 3 ERRORES
// ========================================

// FIX 1

var frutas = ["Manzana", "Plátano", "Naranja"]

// ERROR ORIGINAL:
// frutas.append(7)
//
// El Array contiene String, por eso no puede recibir un Int.

frutas.append("Mandarina")

print("\nFrutas: \(frutas)")


// FIX 2

var colores = ["Rojo", "Azul", "Verde"]

// Se cambia let por var porque el Array será modificado.

colores.append("Amarillo")

print("Colores: \(colores)")


// FIX 3

let numeros = [10, 20, 30, 40, 50]

// numeros[5] genera error porque el último índice válido es 4.

print("Último número: \(numeros[4])")


// ========================================
// PREDICT
// ========================================

var lista = [1, 2, 3, 4, 5]

lista.remove(at: 0)
lista.append(6)

print(lista)

// PREDICT 1:
// [2, 3, 4, 5, 6]

print(lista.count)

// PREDICT 2:
// 5


var nombres = ["Ana", "Carlos", "Beto"]

print(nombres.sorted())

// PREDICT 3:
// ["Ana", "Beto", "Carlos"]

print(nombres)

// PREDICT 4:
// ["Ana", "Carlos", "Beto"]
//
// sorted() crea un nuevo Array ordenado.
// No modifica el Array original.
