// Desarrollado por: Jason Gomez

import Foundation // Importa herramientas para formatear números decimales.

print("========== EJERCICIO 6: GESTIÓN DE NOTAS ==========") // Muestra el título principal del ejercicio.

var cantidadAlumnos = 0 // Guarda la cantidad válida de alumnos que se registrarán.
repeat { // Repite la solicitud hasta recibir una cantidad mayor que cero.
    print("Ingrese la cantidad de alumnos:", terminator: " ") // Solicita el número de alumnos.
    let entradaCantidad = readLine() ?? "" // Lee la cantidad escrita o usa una cadena vacía.
    if let cantidadValida = Int(entradaCantidad), cantidadValida > 0 { // Comprueba que la entrada sea un entero positivo.
        cantidadAlumnos = cantidadValida // Conserva la cantidad válida de alumnos.
    } else { // Atiende una cantidad vacía, no numérica o menor que uno.
        print("Entrada inválida. Ingrese un número entero mayor que cero.") // Explica cómo corregir la cantidad.
    } // Finaliza la validación de la cantidad.
} while cantidadAlumnos == 0 // Continúa mientras no exista una cantidad válida.

var notasPorAlumno: [String: [Double]] = [:] // Relaciona el nombre de cada alumno con sus tres notas.

for numeroAlumno in 1...cantidadAlumnos { // Repite el registro para cada alumno solicitado.
    var nombreAlumno = "" // Prepara el nombre del alumno actual.
    repeat { // Repite la solicitud mientras el nombre sea inválido o esté repetido.
        print("Nombre del alumno \(numeroAlumno):", terminator: " ") // Solicita el nombre del alumno actual.
        nombreAlumno = readLine() ?? "" // Lee el nombre o usa una cadena vacía.
        if nombreAlumno.isEmpty { // Comprueba si no se escribió ningún nombre.
            print("El nombre no puede estar vacío.") // Informa que debe escribirse un nombre.
        } else if notasPorAlumno[nombreAlumno] != nil { // Comprueba si el nombre ya pertenece a otro registro.
            print("El alumno ya fue registrado. Ingrese otro nombre.") // Evita reemplazar las notas de un alumno existente.
        } // Finaliza la validación del nombre.
    } while nombreAlumno.isEmpty || notasPorAlumno[nombreAlumno] != nil // Continúa hasta obtener un nombre nuevo y no vacío.

    var notasAlumno: [Double] = [] // Guarda temporalmente las tres notas del alumno actual.
    for numeroNota in 1...3 { // Solicita exactamente tres notas para el alumno.
        var notaValida: Double? = nil // Representa una nota pendiente de validación.
        repeat { // Repite la lectura hasta recibir una nota entre cero y veinte.
            print("Nota \(numeroNota) de \(nombreAlumno):", terminator: " ") // Solicita una nota específica del alumno.
            let entradaNota = readLine() ?? "" // Lee la nota escrita o usa una cadena vacía.
            if let notaConvertida = Double(entradaNota), notaConvertida >= 0, notaConvertida <= 20 { // Valida que la nota sea numérica y pertenezca al rango permitido.
                notaValida = notaConvertida // Conserva la nota que superó la validación.
            } else { // Atiende una nota vacía, no numérica o fuera del rango.
                print("Nota inválida. Ingrese un valor entre 0 y 20.") // Explica el rango correcto de notas.
            } // Finaliza la validación de la nota.
        } while notaValida == nil // Continúa mientras todavía no exista una nota válida.
        notasAlumno.append(notaValida ?? 0) // Agrega la nota validada al arreglo del alumno.
    } // Finaliza el registro de las tres notas.

    notasPorAlumno[nombreAlumno] = notasAlumno // Guarda el alumno y sus notas en el diccionario principal.
} // Finaliza el registro de todos los alumnos.

var promediosPorAlumno: [String: Double] = [:] // Relaciona cada alumno con el promedio de sus notas.
var sumaPromedios = 0.0 // Acumula los promedios para calcular el promedio general.
var cantidadAprobados = 0 // Cuenta los alumnos cuyo promedio es trece o mayor.
var alumnoNotaMasAlta = "" // Guarda el nombre del alumno que obtuvo la nota individual más alta.
var notaMasAlta = -1.0 // Comienza por debajo de cualquier nota permitida.
var alumnoNotaMasBaja = "" // Guarda el nombre del alumno que obtuvo la nota individual más baja.
var notaMasBaja = 21.0 // Comienza por encima de cualquier nota permitida.

print("\n========== RESULTADOS POR ALUMNO ==========") // Separa el registro del reporte individual.

for nombreAlumno in notasPorAlumno.keys.sorted() { // Recorre los alumnos en orden alfabético.
    let notasAlumno = notasPorAlumno[nombreAlumno] ?? [] // Recupera las notas asociadas al alumno actual.
    var sumaNotas = 0.0 // Prepara la suma de las notas del alumno.
    for nota in notasAlumno { // Recorre las tres notas almacenadas.
        sumaNotas += nota // Acumula cada nota para obtener el promedio.
        if nota > notaMasAlta { // Comprueba si se encontró una nueva nota individual máxima.
            notaMasAlta = nota // Actualiza la nota más alta conocida.
            alumnoNotaMasAlta = nombreAlumno // Guarda el nombre del alumno que obtuvo la nota más alta.
        } // Finaliza la actualización de la nota máxima.
        if nota < notaMasBaja { // Comprueba si se encontró una nueva nota individual mínima.
            notaMasBaja = nota // Actualiza la nota más baja conocida.
            alumnoNotaMasBaja = nombreAlumno // Guarda el nombre del alumno que obtuvo la nota más baja.
        } // Finaliza la actualización de la nota mínima.
    } // Finaliza la suma de notas del alumno.
    let promedioAlumno = sumaNotas / Double(notasAlumno.count) // Divide la suma entre la cantidad de notas.
    promediosPorAlumno[nombreAlumno] = promedioAlumno // Guarda el promedio calculado en el diccionario.
    sumaPromedios += promedioAlumno // Acumula el promedio dentro de las estadísticas generales.

    var clasificacion = "" // Prepara la clasificación académica del alumno.
    switch promedioAlumno { // Selecciona la clasificación según el promedio obtenido.
    case 18...20: // Atiende los promedios desde dieciocho hasta veinte.
        clasificacion = "Excelente" // Asigna la clasificación académica más alta.
    case 15..<18: // Atiende los promedios desde quince hasta menos de dieciocho.
        clasificacion = "Bueno" // Asigna la clasificación académica buena.
    case 13..<15: // Atiende los promedios desde trece hasta menos de quince.
        clasificacion = "Aprobado" // Indica que el alumno alcanzó la nota aprobatoria.
    default: // Atiende todos los promedios menores que trece.
        clasificacion = "Desaprobado" // Indica que el alumno no alcanzó la nota aprobatoria.
    } // Finaliza la selección de la clasificación.

    if promedioAlumno >= 13 { // Comprueba si el alumno está aprobado.
        cantidadAprobados += 1 // Incrementa el contador de alumnos aprobados.
    } // Finaliza el conteo de aprobados.

    let promedioFormateado = String(format: "%.2f", promedioAlumno) // Convierte el promedio a un texto con dos decimales.
    print("\(nombreAlumno): promedio \(promedioFormateado) - \(clasificacion)") // Muestra el promedio y la clasificación del alumno.
} // Finaliza el reporte individual.

let promedioGeneral = sumaPromedios / Double(cantidadAlumnos) // Calcula el promedio de todos los alumnos.
let porcentajeAprobados = Double(cantidadAprobados) / Double(cantidadAlumnos) * 100 // Calcula qué porcentaje de alumnos aprobó.

print("\n========== ESTADÍSTICAS GENERALES ==========") // Muestra el encabezado de las estadísticas.
print("Promedio general: \(String(format: "%.2f", promedioGeneral))") // Muestra el promedio general con dos decimales.
print("Nota más alta: \(alumnoNotaMasAlta) con \(String(format: "%.2f", notaMasAlta))") // Muestra la calificación individual más alta y quién la obtuvo.
print("Nota más baja: \(alumnoNotaMasBaja) con \(String(format: "%.2f", notaMasBaja))") // Muestra la calificación individual más baja y quién la obtuvo.
print("Porcentaje de aprobados: \(String(format: "%.2f", porcentajeAprobados))%") // Muestra el porcentaje de alumnos aprobados.

let alumnosOrdenados = promediosPorAlumno.sorted { $0.value > $1.value } // Ordena los alumnos desde el promedio más alto al más bajo.

print("\n========== ORDEN POR PROMEDIO ==========") // Muestra el encabezado del ranking académico.
for (indice, alumno) in alumnosOrdenados.enumerated() { // Recorre los promedios ordenados junto con su posición.
    print("\(indice + 1). \(alumno.key): \(String(format: "%.2f", alumno.value))") // Muestra la posición, el nombre y el promedio.
} // Finaliza la presentación del ranking.
