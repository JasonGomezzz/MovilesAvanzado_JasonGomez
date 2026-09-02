import UIKit

// EJERCICIO 1: CONDICIONALES

let notaEjemplo = 15.0

if notaEjemplo >= 13.0 {
    print("Aprobado con \(notaEjemplo)")
} else {
    print("Desaprobado con \(notaEjemplo)")
}

// TODO 1: Mayoría de edad

let edad = 17

// Escribe aquí un if/else para comprobar si edad es mayor o igual a 18.

// TODO 2: Clasificación de nota

let miNota = 16.0

// Clasifica miNota como:
// Excelente: 18 a 20
// Bueno: 15 a 17
// Aprobado: 13 a 14
// Desaprobado: 0 a 12

// TODO 3: Número positivo, negativo o cero

let numero = -5

// Escribe aquí un if/else if/else.

// FIX 1: Temperatura

let temperatura = 35

// Corrige la estructura para mostrar:
// Hace calor, Clima agradable o Hace frío.

// FIX 2: Saldo

let saldo = 100.0
let compra = 150.0

// Comprueba si el saldo permite realizar la compra.
// Si no alcanza, muestra cuánto dinero falta.

// FIX 3: Hora

let hora = 25

// Clasifica la hora como:
// Buenos días, Buenas tardes, Buenas noches o Hora inválida.

// PREDICT 1

let x = 10

if x > 5 && x < 20 {
    print("Dentro del rango")
} else {
    print("Fuera del rango")
}

// Escribe aquí tu predicción.

// PREDICT 2

let y = 15

if y > 20 {
    print("Mayor que 20")
} else if y > 10 {
    print("Mayor que 10")
} else if y > 5 {
    print("Mayor que 5")
}

// Escribe qué imprime y por qué solo entra en una condición.

// PREDICT 3

let esLunes = true
let llueve = false

if esLunes && llueve {
    print("Lunes lluvioso")
} else if esLunes || llueve {
    print("Es lunes O llueve")
} else {
    print("Ni lunes ni llueve")
}

// Escribe aquí tu predicción.
