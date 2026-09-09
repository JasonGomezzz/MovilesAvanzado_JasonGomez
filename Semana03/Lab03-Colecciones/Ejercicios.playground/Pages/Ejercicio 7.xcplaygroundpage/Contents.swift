// Desarrollado por: Jason Gomez

import Foundation // Importa herramientas para formatear los precios y valores monetarios.

print("========== EJERCICIO 7: INVENTARIO CON MENÚ ==========") // Muestra el título principal del ejercicio.

var cantidadProductos = 0 // Guarda la cantidad válida de productos que se registrarán.
repeat { // Repite la solicitud hasta recibir una cantidad mayor que cero.
    print("Ingrese la cantidad de productos:", terminator: " ") // Solicita el número de productos del inventario.
    let entradaCantidad = readLine() ?? "" // Lee la cantidad escrita o usa una cadena vacía.
    if let cantidadValida = Int(entradaCantidad), cantidadValida > 0 { // Comprueba que la entrada sea un entero positivo.
        cantidadProductos = cantidadValida // Conserva la cantidad válida de productos.
    } else { // Atiende una cantidad vacía, no numérica o menor que uno.
        print("Entrada inválida. Ingrese un número entero mayor que cero.") // Explica cómo corregir la cantidad.
    } // Finaliza la validación de la cantidad.
} while cantidadProductos == 0 // Continúa mientras no exista una cantidad válida.

var preciosPorProducto: [String: Double] = [:] // Relaciona cada producto con su precio unitario.
var stockPorProducto: [String: Int] = [:] // Relaciona cada producto con su cantidad disponible.

for numeroProducto in 1...cantidadProductos { // Repite el registro para cada producto solicitado.
    var nombreProducto = "" // Prepara el nombre del producto actual.
    repeat { // Repite la solicitud mientras el nombre sea inválido o esté repetido.
        print("Nombre del producto \(numeroProducto):", terminator: " ") // Solicita el nombre del producto actual.
        nombreProducto = readLine() ?? "" // Lee el nombre o usa una cadena vacía.
        if nombreProducto.isEmpty { // Comprueba si no se escribió ningún nombre.
            print("El nombre no puede estar vacío.") // Informa que debe escribirse un nombre.
        } else if preciosPorProducto[nombreProducto] != nil { // Comprueba si el producto ya fue registrado.
            print("El producto ya existe. Ingrese otro nombre.") // Evita reemplazar un producto existente.
        } // Finaliza la validación del nombre.
    } while nombreProducto.isEmpty || preciosPorProducto[nombreProducto] != nil // Continúa hasta obtener un nombre nuevo y no vacío.

    var precioValido: Double? = nil // Representa un precio pendiente de validación.
    repeat { // Repite la lectura hasta recibir un precio mayor que cero.
        print("Precio de \(nombreProducto): S/.", terminator: " ") // Solicita el precio unitario del producto.
        let entradaPrecio = readLine() ?? "" // Lee el precio escrito o usa una cadena vacía.
        if let precioConvertido = Double(entradaPrecio), precioConvertido > 0 { // Valida que el precio sea numérico y positivo.
            precioValido = precioConvertido // Conserva el precio que superó la validación.
        } else { // Atiende un precio vacío, no numérico, igual a cero o negativo.
            print("Precio inválido. Ingrese un valor mayor que cero.") // Explica la condición de un precio válido.
        } // Finaliza la validación del precio.
    } while precioValido == nil // Continúa mientras todavía no exista un precio válido.

    var stockValido: Int? = nil // Representa una cantidad de stock pendiente de validación.
    repeat { // Repite la lectura hasta recibir un stock igual o mayor que cero.
        print("Stock de \(nombreProducto):", terminator: " ") // Solicita la cantidad disponible del producto.
        let entradaStock = readLine() ?? "" // Lee el stock escrito o usa una cadena vacía.
        if let stockConvertido = Int(entradaStock), stockConvertido >= 0 { // Valida que el stock sea un entero no negativo.
            stockValido = stockConvertido // Conserva el stock que superó la validación.
        } else { // Atiende un stock vacío, decimal, no numérico o negativo.
            print("Stock inválido. Ingrese un número entero desde cero.") // Explica la condición de un stock válido.
        } // Finaliza la validación del stock.
    } while stockValido == nil // Continúa mientras todavía no exista un stock válido.

    preciosPorProducto[nombreProducto] = precioValido ?? 0 // Guarda el precio validado en su diccionario.
    stockPorProducto[nombreProducto] = stockValido ?? 0 // Guarda el stock validado en su diccionario.
} // Finaliza el registro de todos los productos.

var continuarEnMenu = true // Controla la repetición del menú principal.
while continuarEnMenu { // Mantiene el sistema activo hasta que el usuario seleccione salir.
    print("\n========== MENÚ DE INVENTARIO ==========") // Muestra el encabezado del menú.
    print("1. Ver inventario") // Presenta la opción para listar todos los productos.
    print("2. Buscar producto") // Presenta la opción para consultar un producto específico.
    print("3. Mostrar productos con stock bajo") // Presenta la opción para revisar existencias menores que cinco.
    print("4. Calcular valor total del inventario") // Presenta la opción para calcular precio por stock.
    print("5. Salir") // Presenta la opción para terminar el programa.
    print("Seleccione una opción:", terminator: " ") // Solicita una opción del menú.
    let opcion = readLine() ?? "" // Lee la opción o usa una cadena vacía.

    switch opcion { // Selecciona la acción correspondiente a la opción escrita.
    case "1": // Atiende la consulta de todo el inventario.
        print("\n---------- INVENTARIO COMPLETO ----------") // Muestra el título del reporte general.
        for nombreProducto in preciosPorProducto.keys.sorted() { // Recorre los productos en orden alfabético.
            let precioProducto = preciosPorProducto[nombreProducto] ?? 0 // Recupera el precio del producto actual.
            let stockProducto = stockPorProducto[nombreProducto] ?? 0 // Recupera el stock del producto actual.
            let precioFormateado = String(format: "%.2f", precioProducto) // Convierte el precio a un texto con dos decimales.
            print("\(nombreProducto) | Precio: S/. \(precioFormateado) | Stock: \(stockProducto)") // Muestra los datos completos del producto.
        } // Finaliza el reporte del inventario.
    case "2": // Atiende la búsqueda de un producto específico.
        print("Ingrese el nombre del producto:", terminator: " ") // Solicita el nombre que se buscará.
        let nombreBuscado = readLine() ?? "" // Lee el nombre buscado o usa una cadena vacía.
        var productoEncontrado = "" // Guarda el nombre real cuando exista una coincidencia.
        for nombreProducto in preciosPorProducto.keys { // Recorre las claves para realizar una búsqueda flexible.
            if nombreProducto.lowercased() == nombreBuscado.lowercased() { // Compara los nombres sin distinguir mayúsculas y minúsculas.
                productoEncontrado = nombreProducto // Conserva el nombre almacenado originalmente.
            } // Finaliza la comparación del nombre actual.
        } // Finaliza la búsqueda dentro de las claves.
        if productoEncontrado.isEmpty { // Comprueba si no se encontró ninguna coincidencia.
            print("Producto no encontrado.") // Informa que el producto no pertenece al inventario.
        } else { // Atiende una búsqueda que encontró el producto.
            let precioProducto = preciosPorProducto[productoEncontrado] ?? 0 // Recupera el precio del producto encontrado.
            let stockProducto = stockPorProducto[productoEncontrado] ?? 0 // Recupera el stock del producto encontrado.
            print("Producto: \(productoEncontrado)") // Muestra el nombre original del producto.
            print("Precio: S/. \(String(format: "%.2f", precioProducto))") // Muestra el precio con dos decimales.
            print("Stock: \(stockProducto)") // Muestra las unidades disponibles.
        } // Finaliza el resultado de la búsqueda.
    case "3": // Atiende la consulta de productos con stock bajo.
        print("\n---------- PRODUCTOS CON STOCK BAJO ----------") // Muestra el título del reporte de stock bajo.
        var existenProductosConStockBajo = false // Indica si se encontró al menos un producto con menos de cinco unidades.
        for nombreProducto in stockPorProducto.keys.sorted() { // Recorre los productos en orden alfabético.
            let stockProducto = stockPorProducto[nombreProducto] ?? 0 // Recupera el stock del producto actual.
            if stockProducto < 5 { // Comprueba si el producto tiene menos de cinco unidades.
                print("\(nombreProducto): \(stockProducto) unidades") // Muestra el producto que necesita reposición.
                existenProductosConStockBajo = true // Registra que el reporte encontró un producto.
            } // Finaliza la comprobación del stock actual.
        } // Finaliza el recorrido del stock.
        if !existenProductosConStockBajo { // Comprueba si ningún producto tiene stock bajo.
            print("No existen productos con stock bajo.") // Informa que todas las existencias son suficientes.
        } // Finaliza la comprobación del reporte vacío.
    case "4": // Atiende el cálculo del valor total del inventario.
        var valorTotalInventario = 0.0 // Prepara el acumulador del valor de todos los productos.
        for nombreProducto in preciosPorProducto.keys { // Recorre todos los productos registrados.
            let precioProducto = preciosPorProducto[nombreProducto] ?? 0 // Recupera el precio del producto actual.
            let stockProducto = stockPorProducto[nombreProducto] ?? 0 // Recupera el stock del producto actual.
            valorTotalInventario += precioProducto * Double(stockProducto) // Suma el precio multiplicado por las unidades disponibles.
        } // Finaliza el cálculo del valor del inventario.
        print("Valor total del inventario: S/. \(String(format: "%.2f", valorTotalInventario))") // Muestra el valor monetario con dos decimales.
    case "5": // Atiende la solicitud de salida del sistema.
        continuarEnMenu = false // Cambia el control para detener el ciclo del menú.
        print("Programa finalizado.") // Confirma que el usuario salió correctamente.
    default: // Atiende una opción vacía o diferente de uno a cinco.
        print("Opción inválida. Seleccione un número del 1 al 5.") // Explica cuáles son las opciones permitidas.
    } // Finaliza la selección de la opción del menú.
} // Finaliza el sistema interactivo de inventario.
