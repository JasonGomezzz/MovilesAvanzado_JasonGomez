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
if edad >= 18 {
    print("Es mayor de edad")
} else {
    print("Es menor de edad")
}
// Escribe aquí un if/else para comprobar si edad es mayor o igual a 18.

// TODO 2: Clasificación de nota

let miNota = 16.0

if miNota >= 18 {
    print("Excelente")
} else if miNota >= 15 {
    print("Bueno")
} else if miNota >= 13 {
    print("Aprobado")
} else {
    print("Desaprobado")
}

// Clasifica miNota como:
// Excelente: 18 a 20
// Bueno: 15 a 17
// Aprobado: 13 a 14
// Desaprobado: 0 a 12

// TODO 3: Número positivo, negativo o cero

let numero = -5

if numero > 0 {
    print("El número es positivo")
} else if numero < 0 {
    print("El número es negativo")
} else {
    print("El número es cero")
}

// Escribe aquí un if/else if/else.

// FIX 1: Temperatura

let temperatura = 35

if temperatura > 30 {
    print("Hace calor")
} else if temperatura > 20 {
    print("Clima agradable")
} else {
    print("Hace frío")
}

// Corrige la estructura para mostrar:
// Hace calor, Clima agradable o Hace frío.

// FIX 2: Saldo

let saldo = 100.0
let compra = 150.0

if saldo >= compra {
    print("Compra realizada")
} else {
    print("Saldo insuficiente: te faltan \(compra - saldo)")
}

// Comprueba si el saldo permite realizar la compra.
// Si no alcanza, muestra cuánto dinero falta.

// FIX 3: Hora

let hora = 25

if hora >= 0 && hora < 12 {
    print("Buenos días")
} else if hora >= 12 && hora < 18 {
    print("Buenas tardes")
} else if hora >= 18 && hora <= 23 {
    print("Buenas noches")
} else {
    print("Hora inválida")
}

// Clasifica la hora como:
// Buenos días, Buenas tardes, Buenas noches o Hora inválida.

// PREDICT 1: Imprime "Dentro del rango" porque 10 es mayor que 5 y menor que 20.

let x = 10

if x > 5 && x < 20 {
    print("Dentro del rango")
} else {
    print("Fuera del rango")
}

// Escribe aquí tu predicción.

// PREDICT 2: Imprime "Mayor que 10". No imprime "Mayor que 5" porque el else if se detiene en la primera condición verdadera.

let y = 15

if y > 20 {
    print("Mayor que 20")
} else if y > 10 {
    print("Mayor que 10")
} else if y > 5 {
    print("Mayor que 5")
}

// Escribe qué imprime y por qué solo entra en una condición.

// PREDICT 3: Imprime "Es lunes O llueve" porque esLunes es true y se cumple la condición con ||.

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
