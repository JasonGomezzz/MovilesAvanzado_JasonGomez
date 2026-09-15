// Desarrollado por: Jason Gomez

// Importamos Foundation para disponer de las funciones básicas de Swift.
import Foundation

// Declaramos los dos estados permitidos para un libro.
enum EstadoLibro {
    // Indicamos que el libro puede ser prestado.
    case disponible
    // Indicamos que el libro ya se encuentra prestado.
    case prestado
// Cerramos la declaración del enum.
}

// Definimos el libro como una estructura de datos de tipo valor.
struct Libro {
    // Guardamos el título sin permitir que cambie.
    let titulo: String
    // Guardamos el nombre del autor sin permitir que cambie.
    let autor: String
    // Guardamos un estado modificable que inicia como disponible.
    var estado: EstadoLibro = .disponible
// Cerramos la declaración de la estructura.
}

// Definimos la biblioteca como clase para compartir una misma colección de libros.
class Biblioteca {
    // Creamos un arreglo modificable que comienza vacío.
    var libros: [Libro] = []

    // Declaramos la función que incorpora un libro al arreglo.
    func agregar(libro: Libro) {
        // Añadimos el libro recibido al final de la colección.
        libros.append(libro)
    // Cerramos la función agregar.
    }

    // Declaramos la función que intenta prestar un libro por su título.
    func prestar(titulo: String) -> Bool {
        // Recorremos cada posición válida del arreglo mediante su índice.
        for i in 0..<libros.count {
            // Comparamos el título almacenado con el título solicitado.
            if libros[i].titulo == titulo {
                // Verificamos que el libro encontrado esté disponible.
                if libros[i].estado == .disponible {
                    // Modificamos directamente el estado del libro dentro del arreglo.
                    libros[i].estado = .prestado
                    // Informamos que el préstamo fue aprobado.
                    print("Préstamo aprobado: \(titulo)")
                    // Devolvemos verdadero porque la operación se completó.
                    return true
                // Cerramos la validación del estado disponible.
                }

                // Informamos que el libro encontrado ya estaba prestado.
                print("Error: \(titulo) ya está prestado")
                // Devolvemos falso porque no se realizó otro préstamo.
                return false
            // Cerramos la comparación del título.
            }
        // Cerramos el recorrido por los libros.
        }

        // Informamos que ningún libro tuvo el título solicitado.
        print("Error: no existe \(titulo)")
        // Devolvemos falso porque el libro no fue encontrado.
        return false
    // Cerramos la función prestar.
    }

    // Declaramos la función que intenta devolver un libro por su título.
    func devolver(titulo: String) -> Bool {
        // Recorremos cada posición válida del arreglo mediante su índice.
        for i in 0..<libros.count {
            // Comparamos el título almacenado con el título solicitado.
            if libros[i].titulo == titulo {
                // Verificamos que el libro encontrado esté prestado.
                if libros[i].estado == .prestado {
                    // Modificamos directamente el estado del libro dentro del arreglo.
                    libros[i].estado = .disponible
                    // Informamos que la devolución fue registrada.
                    print("Devolución registrada: \(titulo)")
                    // Devolvemos verdadero porque la operación se completó.
                    return true
                // Cerramos la validación del estado prestado.
                }

                // Informamos que el libro encontrado no estaba prestado.
                print("Error: \(titulo) no está prestado")
                // Devolvemos falso porque no se realizó una devolución.
                return false
            // Cerramos la comparación del título.
            }
        // Cerramos el recorrido por los libros.
        }

        // Informamos que ningún libro tuvo el título solicitado.
        print("Error: no existe \(titulo)")
        // Devolvemos falso porque el libro no fue encontrado.
        return false
    // Cerramos la función devolver.
    }

    // Declaramos la función que muestra todos los libros y sus estados.
    func inventario() {
        // Imprimimos el encabezado solicitado para el inventario.
        print("===== INVENTARIO =====")

        // Recorremos todos los libros almacenados.
        for libro in libros {
            // Creamos un texto vacío que recibirá el estado en español.
            var estadoTexto = ""

            // Evaluamos el estado mediante una estructura switch.
            switch libro.estado {
            // Atendemos el caso en que el libro está disponible.
            case .disponible:
                // Asignamos el texto correspondiente al estado disponible.
                estadoTexto = "disponible"
            // Atendemos el caso en que el libro está prestado.
            case .prestado:
                // Asignamos el texto correspondiente al estado prestado.
                estadoTexto = "prestado"
            // Cerramos la evaluación del estado.
            }

            // Mostramos el título, el autor y el estado del libro.
            print("\(libro.titulo) (\(libro.autor)) - \(estadoTexto)")
        // Cerramos el recorrido del inventario.
        }
    // Cerramos la función inventario.
    }
// Cerramos la declaración de la clase.
}

// Creamos la biblioteca que conservará el estado de todos los préstamos.
let biblioteca = Biblioteca()

// Agregamos el primer libro solicitado en la simulación.
biblioteca.agregar(
    // Creamos el libro con su título y autor.
    libro: Libro(titulo: "Cien años de soledad", autor: "Gabriel García Márquez")
// Cerramos la llamada para agregar el primer libro.
)
// Agregamos el segundo libro solicitado en la simulación.
biblioteca.agregar(
    // Creamos el libro con su título y autor.
    libro: Libro(titulo: "La ciudad y los perros", autor: "Mario Vargas Llosa")
// Cerramos la llamada para agregar el segundo libro.
)
// Agregamos el tercer libro solicitado en la simulación.
biblioteca.agregar(
    // Creamos el libro con su título y autor.
    libro: Libro(titulo: "El Quijote", autor: "Miguel de Cervantes")
// Cerramos la llamada para agregar el tercer libro.
)

// Prestamos el segundo libro y descartamos el valor booleano devuelto.
_ = biblioteca.prestar(titulo: "La ciudad y los perros")
// Intentamos prestar nuevamente el mismo libro.
_ = biblioteca.prestar(titulo: "La ciudad y los perros")
// Devolvemos el libro que estaba prestado.
_ = biblioteca.devolver(titulo: "La ciudad y los perros")
// Prestamos el tercer libro de la colección.
_ = biblioteca.prestar(titulo: "El Quijote")
// Intentamos prestar un título que no existe en la colección.
_ = biblioteca.prestar(titulo: "El Principito")
// Mostramos el estado final de todos los libros.
biblioteca.inventario()
