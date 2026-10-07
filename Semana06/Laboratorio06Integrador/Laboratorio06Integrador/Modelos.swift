//
//  Modelos.swift
//  Laboratorio06Integrador
//
//  Created by Jason on 7/10/26.
//

// Desarrollado por: Jason Gomez
import UIKit

// Producto es una clase: el Catálogo, el Detalle y el Carrito comparten LA MISMA
// instancia, así que cuando baja el stock de una compra se ve en todas las pantallas.
class Producto {
    let nombre: String
    let precio: Double
    var stock: Int

    init(nombre: String, precio: Double, stock: Int) {
        self.nombre = nombre
        self.precio = precio
        self.stock = stock
    }
}

class ItemCarrito {
    let producto: Producto
    var cantidad: Int

    init(producto: Producto, cantidad: Int) {
        self.producto = producto
        self.cantidad = cantidad
    }

    // Cada línea sabe calcular su propio subtotal
    func subtotal() -> Double {
        return producto.precio * Double(cantidad)
    }
}

class CarritoModel {
    var items: [ItemCarrito] = []

    // IGV (18 %). Se aplica sobre el monto que ya tiene el descuento (Regla 6).
    let tasaIGV = 0.18

    // Cantidad de un producto que ya está en el carrito (0 si todavía no está).
    // Se compara con === (misma instancia) y no por nombre.
    func cantidadEnCarrito(de producto: Producto) -> Int {
        for item in items where item.producto === producto {
            return item.cantidad
        }
        return 0
    }

    // A1: agrega un producto al carrito.
    // - Devuelve false y NO agrega nada si (lo que ya hay + lo nuevo) supera el stock.
    // - Si el producto ya está en el carrito, suma a su línea (no crea una línea repetida).
    // - Si no está, crea un ItemCarrito nuevo y devuelve true.
    func agregar(producto: Producto, cantidad: Int) -> Bool {
        // Una cantidad de 0 o negativa no tiene sentido (el stepper del Detalle empieza en 1)
        if cantidad <= 0 {
            return false
        }
        // Regla 8: se cuenta lo que ya hay en el carrito, no solo la cantidad nueva
        if cantidadEnCarrito(de: producto) + cantidad > producto.stock {
            return false
        }
        for item in items where item.producto === producto {
            item.cantidad += cantidad
            return true
        }
        items.append(ItemCarrito(producto: producto, cantidad: cantidad))
        return true
    }

    // A2: suma de los subtotales de cada línea
    func subtotal() -> Double {
        var suma = 0.0
        for item in items {
            suma += item.subtotal()
        }
        return suma
    }

    // A3: porcentaje de descuento según el tramo del subtotal (Regla 6)
    func porcentajeDescuento() -> Double {
        let subtotal = self.subtotal()
        if subtotal >= 5000 {
            return 0.15
        } else if subtotal >= 2000 {
            return 0.10
        } else if subtotal >= 500 {
            return 0.05
        } else {
            return 0.0
        }
    }

    // A4: suma de las cantidades de todas las líneas
    func cantidadTotal() -> Int {
        var total = 0
        for item in items {
            total += item.cantidad
        }
        return total
    }

    // A5: deja el carrito sin líneas
    func vaciar() {
        items.removeAll()
    }

    // Regla 5: los demás cálculos también viven en el modelo, no en los ViewController.

    func montoDescuento() -> Double {
        return subtotal() * porcentajeDescuento()
    }

    // Subtotal ya descontado: es la base sobre la que se calcula el IGV
    func montoConDescuento() -> Double {
        return subtotal() - montoDescuento()
    }

    func igv() -> Double {
        return montoConDescuento() * tasaIGV
    }

    func total() -> Double {
        return montoConDescuento() + igv()
    }

    // Regla 7: categoría del cliente según el subtotal, sin decimales
    func categoriaCliente() -> String {
        switch Int(subtotal()) {
        case ..<500:
            return "Regular"
        case 500..<2000:
            return "Frecuente"
        case 2000..<5000:
            return "VIP"
        default:
            return "Premium"
        }
    }

    // Regla 9: al confirmar la compra baja el stock de cada producto y el carrito queda vacío
    func confirmarCompra() {
        for item in items {
            item.producto.stock -= item.cantidad
        }
        vaciar()
    }
}
