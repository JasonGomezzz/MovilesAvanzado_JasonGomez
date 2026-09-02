import UIKit // Importa las herramientas básicas disponibles en un Playground de iOS.

let producto1 = "Laptop" // Guarda el nombre del primer producto.
let precio1 = 3500.0 // Guarda el precio unitario de la laptop.
let cantidad1 = 1 // Guarda la cantidad comprada de laptops.

let producto2 = "Mouse" // Guarda el nombre del segundo producto.
let precio2 = 45.50 // Guarda el precio unitario del mouse.
let cantidad2 = 2 // Guarda la cantidad comprada de mouses.

let producto3 = "Teclado" // Guarda el nombre del tercer producto.
let precio3 = 120.0 // Guarda el precio unitario del teclado.
let cantidad3 = 1 // Guarda la cantidad comprada de teclados.

let producto4 = "Monitor" // Guarda el nombre del cuarto producto.
let precio4 = 890.0 // Guarda el precio unitario del monitor.
let cantidad4 = 1 // Guarda la cantidad comprada de monitores.

let producto5 = "USB Cable" // Guarda el nombre del quinto producto.
let precio5 = 15.0 // Guarda el precio unitario del cable USB.
let cantidad5 = 3 // Guarda la cantidad comprada de cables USB.

let codigoCupon = "DESCUENTO20" // Simula el código de cupón ingresado por el cliente.

let datosValidos = precio1 >= 0 && precio2 >= 0 && precio3 >= 0 && precio4 >= 0 && precio5 >= 0 && cantidad1 > 0 && cantidad2 > 0 && cantidad3 > 0 && cantidad4 > 0 && cantidad5 > 0 // Verifica que ningún precio sea negativo y que todas las cantidades sean mayores que cero.

if !datosValidos { // Comprueba si se encontró algún precio o cantidad inválida.
    print("Error: los precios deben ser positivos y las cantidades mayores que cero.") // Muestra un mensaje cuando los datos no cumplen las reglas.
} else { // Continúa con la compra solamente cuando todos los datos son válidos.
    let subtotal1 = precio1 * Double(cantidad1) // Multiplica el precio de la laptop por su cantidad.
    let subtotal2 = precio2 * Double(cantidad2) // Multiplica el precio del mouse por su cantidad.
    let subtotal3 = precio3 * Double(cantidad3) // Multiplica el precio del teclado por su cantidad.
    let subtotal4 = precio4 * Double(cantidad4) // Multiplica el precio del monitor por su cantidad.
    let subtotal5 = precio5 * Double(cantidad5) // Multiplica el precio del cable USB por su cantidad.

    let descuentoCantidad1 = cantidad1 >= 3 ? subtotal1 * 0.05 : 0 // Aplica 5% de descuento a la laptop si se compran tres o más.
    let descuentoCantidad2 = cantidad2 >= 3 ? subtotal2 * 0.05 : 0 // Aplica 5% de descuento al mouse si se compran tres o más.
    let descuentoCantidad3 = cantidad3 >= 3 ? subtotal3 * 0.05 : 0 // Aplica 5% de descuento al teclado si se compran tres o más.
    let descuentoCantidad4 = cantidad4 >= 3 ? subtotal4 * 0.05 : 0 // Aplica 5% de descuento al monitor si se compran tres o más.
    let descuentoCantidad5 = cantidad5 >= 3 ? subtotal5 * 0.05 : 0 // Aplica 5% de descuento al cable USB porque se compraron tres unidades.

    let subtotalConCantidad = subtotal1 - descuentoCantidad1 + subtotal2 - descuentoCantidad2 + subtotal3 - descuentoCantidad3 + subtotal4 - descuentoCantidad4 + subtotal5 - descuentoCantidad5 // Suma los subtotales después de aplicar los descuentos por cantidad.

    var porcentajeDescuento = 0.0 // Inicializa el porcentaje de descuento general en cero.
    if subtotalConCantidad >= 5000 { // Comprueba si la compra alcanza cinco mil soles.
        porcentajeDescuento = 0.15 // Aplica 15% de descuento a compras de cinco mil soles o más.
    } else if subtotalConCantidad >= 2000 { // Comprueba si la compra alcanza dos mil soles.
        porcentajeDescuento = 0.10 // Aplica 10% de descuento a compras desde dos mil soles.
    } else if subtotalConCantidad >= 500 { // Comprueba si la compra alcanza quinientos soles.
        porcentajeDescuento = 0.05 // Aplica 5% de descuento a compras desde quinientos soles.
    } // Finaliza la selección del descuento general.

    let descuentoGeneral = subtotalConCantidad * porcentajeDescuento // Calcula el dinero descontado según el monto de compra.
    let totalConDescuento = subtotalConCantidad - descuentoGeneral // Resta el descuento general al subtotal.
    let descuentoCupon = codigoCupon == "DESCUENTO20" ? totalConDescuento * 0.20 : 0 // Aplica 20% adicional únicamente cuando el cupón es correcto.
    let subtotalFinal = totalConDescuento - descuentoCupon // Resta el descuento del cupón.
    let igv = subtotalFinal * 0.18 // Calcula el IGV del 18% sobre el subtotal final.
    let totalConIGV = subtotalFinal + igv // Suma el IGV al monto descontado.
    let costoEnvio = totalConIGV > 3000 ? 0.0 : 25.0 // Hace gratuito el envío si el total supera tres mil soles.
    let totalPagar = totalConIGV + costoEnvio // Agrega el costo de envío al total.
    let puntosGanados = Int(totalConIGV / 100) // Otorga un punto por cada cien soles de compra.

    print("========== CARRITO MEJORADO ==========") // Imprime el encabezado del ticket.
    print("\(producto1) x\(cantidad1): S/. \(subtotal1)") // Muestra la laptop y su subtotal.
    print("\(producto2) x\(cantidad2): S/. \(subtotal2)") // Muestra el mouse y su subtotal.
    print("\(producto3) x\(cantidad3): S/. \(subtotal3)") // Muestra el teclado y su subtotal.
    print("\(producto4) x\(cantidad4): S/. \(subtotal4)") // Muestra el monitor y su subtotal.
    print("\(producto5) x\(cantidad5): S/. \(subtotal5)") // Muestra el cable USB y su subtotal.
    print("Descuento por cantidad: S/. \(descuentoCantidad1 + descuentoCantidad2 + descuentoCantidad3 + descuentoCantidad4 + descuentoCantidad5)") // Muestra la suma de descuentos por cantidad.
    print("Descuento general: S/. \(descuentoGeneral)") // Muestra el descuento aplicado por el monto total.
    print("Descuento del cupón: S/. \(descuentoCupon)") // Muestra el descuento adicional del cupón.
    print("IGV: S/. \(igv)") // Muestra el impuesto calculado.
    print("Envío: S/. \(costoEnvio)") // Muestra cero si el envío es gratuito o veinticinco si se cobra.
    print("TOTAL: S/. \(totalPagar)") // Muestra el monto final que debe pagar el cliente.
    print("Puntos ganados: \(puntosGanados)") // Muestra los puntos de fidelidad obtenidos.
} // Finaliza el bloque que procesa una compra válida.

print("\n========== JUEGO DE ADIVINANZA ==========") // Imprime el título que separa el juego del ejercicio anterior.

let numeroSecreto = 42 // Define el número fijo que el jugador debe adivinar.
let intento1 = 20 // Simula el primer número elegido por el jugador.
let intento2 = 50 // Simula el segundo número elegido por el jugador.
let intento3 = 35 // Simula el tercer número elegido por el jugador.
let intento4 = 42 // Simula el cuarto intento, que coincide con el número secreto.
let intento5 = 60 // Simula un quinto intento disponible si los anteriores fallan.

var numeroIntento = 1 // Lleva la cuenta del intento que se está evaluando.
var intentoActual = intento1 // Comienza el juego utilizando el primer intento.
var adivinado = false // Indica que al inicio todavía no se encontró el número secreto.
while numeroIntento <= 5 && !adivinado { // Repite el proceso mientras haya intentos disponibles.
    print("Intento \(numeroIntento): \(intentoActual)") // Muestra el intento evaluado.

    if intentoActual == numeroSecreto { // Comprueba si encontró el número secreto.
        print("¡Correcto!") // Informa que la respuesta es correcta.
        print("Adivinaste en \(numeroIntento) intentos.") // Muestra cuántos intentos utilizó.
        adivinado = true // Detiene el juego al marcar el número como adivinado.
    } else if intentoActual > numeroSecreto { // Comprueba si el valor es mayor al número secreto.
        print("Muy alto") // Indica que debe intentar con un valor menor.
    } else { // Se ejecuta cuando el valor es menor al número secreto.
        print("Muy bajo") // Indica que debe intentar con un valor mayor.
    } // Finaliza la comparación.

    if !adivinado { // Prepara otro intento solamente si todavía no acertó.
        numeroIntento += 1 // Avanza al siguiente número de intento.

        switch numeroIntento { // Selecciona el valor que corresponde al siguiente intento.
        case 2: // Atiende el segundo intento.
            intentoActual = intento2 // Utiliza el valor del segundo intento.
        case 3: // Atiende el tercer intento.
            intentoActual = intento3 // Utiliza el valor del tercer intento.
        case 4: // Atiende el cuarto intento.
            intentoActual = intento4 // Utiliza el valor del cuarto intento.
        case 5: // Atiende el quinto intento.
            intentoActual = intento5 // Utiliza el valor del quinto intento.
        default: // Atiende cualquier número fuera de los cinco intentos.
            break // No realiza ninguna otra modificación.
        } // Finaliza el switch.
    } // Finaliza la preparación del siguiente intento.
} // Finaliza el while.

if !adivinado { // Verifica si agotó los intentos sin acertar.
    print("Perdiste. El número era: \(numeroSecreto)") // Muestra el número secreto al perder.
} // Finaliza la validación de derrota.
