//
//  main.swift
//  Verificación de las reglas del formulario sin abrir el simulador.
//  Ejecutar:  ./Verificacion/ejecutar.sh
//
//  Cada caso prueba una regla distinta (no se repiten reglas con otros valores).
//

import Foundation

var passed = 0
var failed = 0

func check(_ id: String, _ description: String, _ result: String?, expectsError: Bool, contains fragment: String? = nil) {
    let ok: Bool
    if expectsError {
        ok = result != nil && (fragment == nil || result!.contains(fragment!))
    } else {
        ok = result == nil
    }
    if ok { passed += 1 } else { failed += 1 }
    let shown = result ?? "válido"
    print("\(ok ? "OK  " : "FALLA") \(id) \(description) -> \(shown)")
}

let existing = [
    User(id: 1, name: "Leanne Graham", email: "Sincere@april.biz"),
    User(id: 2, name: "Ervin Howell", email: "Shanna@melissa.tv")
]

print("== Nombre ==")
check("N01", "vacío o solo espacios", UserValidator.nameError("   "), expectsError: true, contains: "Escribe el nombre")
check("N02", "texto de relleno 'xxx'", UserValidator.nameError("xxx"), expectsError: true, contains: "no es un nombre real")
check("N03", "una sola palabra 'Jason'", UserValidator.nameError("Jason"), expectsError: true, contains: "nombre y apellido")
check("N04", "con números 'Juan123 Pérez'", UserValidator.nameError("Juan123 Pérez"), expectsError: true, contains: "solo letras")
check("N05", "letra repetida 'Juaaan Pérez'", UserValidator.nameError("Juaaan Pérez"), expectsError: true, contains: "relleno")
check("N06", "sin vocales 'Jkl Mnb'", UserValidator.nameError("Jkl Mnb"), expectsError: true, contains: "no parece")
check("N07", "más de 60 caracteres", UserValidator.nameError(String(repeating: "Ana ", count: 20)), expectsError: true, contains: "Máximo")
check("N08", "nombre con tilde y ñ 'José Peña'", UserValidator.nameError("José Peña"), expectsError: false)
check("N09", "nombre de la API con prefijo 'Mrs. Dennis Schulist'", UserValidator.nameError("Mrs. Dennis Schulist"), expectsError: false)
check("N10", "nombre de la API con inicial 'Nicholas Runolfsdottir V'", UserValidator.nameError("Nicholas Runolfsdottir V"), expectsError: false)
check("N11", "punto en medio 'Ana torres.gomez'", UserValidator.nameError("Ana torres.gomez"), expectsError: true, contains: "no parece")
check("N12", "apellido compuesto 'Lucía Ruiz-Díaz'", UserValidator.nameError("Lucía Ruiz-Díaz"), expectsError: false)

print("== Correo ==")
check("E01", "vacío", UserValidator.emailError("", others: existing), expectsError: true, contains: "Escribe el correo")
check("E02", "sin dominio 'jason@'", UserValidator.emailError("jason@", others: existing), expectsError: true, contains: "forma")
check("E03", "doble punto 'jason..gomez@tecsup.edu.pe'", UserValidator.emailError("jason..gomez@tecsup.edu.pe", others: existing), expectsError: true, contains: "forma")
check("E04", "correo de prueba 'test@test.com'", UserValidator.emailError("test@test.com", others: existing), expectsError: true, contains: "de prueba")
check("E05", "duplicado con otra mayúscula 'sincere@APRIL.biz'", UserValidator.emailError("sincere@APRIL.biz", others: existing), expectsError: true, contains: "Leanne Graham")
check("E06", "correo válido con subdominio", UserValidator.emailError("jason.gomez@tecsup.edu.pe", others: existing), expectsError: false)

print("== Normalización ==")
let normalized = UserValidator.normalizeName("  juan   pérez  ")
print("\(normalized == "Juan Pérez" ? "OK  " : "FALLA") Z01 '  juan   pérez  ' se guarda como '\(normalized)'")
if normalized == "Juan Pérez" { passed += 1 } else { failed += 1 }
let keepCase = UserValidator.normalizeName("Clementina DuBuque")
print("\(keepCase == "Clementina DuBuque" ? "OK  " : "FALLA") Z02 respeta mayúsculas internas -> '\(keepCase)'")
if keepCase == "Clementina DuBuque" { passed += 1 } else { failed += 1 }

print("\nResultado: \(passed) correctos, \(failed) con falla")
exit(failed == 0 ? 0 : 1)
