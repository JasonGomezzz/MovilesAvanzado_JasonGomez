//
//  Utilidades.swift
//  Laboratorio06Integrador
//
//  Created by Jason on 7/10/26.
//

// Desarrollado por: Jason Gomez
import UIKit

extension Double {
    // 2000 -> "2000.00": siempre dos decimales y con punto, como en la boleta del enunciado
    var conDecimales: String {
        return String(format: "%.2f", self)
    }
}

extension UIViewController {
    // Alerta de un solo botón, la usan varias pantallas para mostrar sus errores
    func mostrarAlerta(titulo: String, mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alerta, animated: true)
    }
}

// Textos del carrito que comparten el Carrito y la Boleta. Los números ya vienen
// calculados por CarritoModel; aquí solo se arman las cadenas para las etiquetas.
extension CarritoModel {
    // Una línea por producto, p. ej. "Refrigeradora x1"
    func textoDeLineas() -> String {
        var lineas: [String] = []
        for item in items {
            lineas.append("\(item.producto.nombre) x\(item.cantidad)")
        }
        return lineas.joined(separator: "\n")
    }

    // El importe de cada línea, en el mismo orden, para la columna de la derecha
    func textoDeImportes() -> String {
        var importes: [String] = []
        for item in items {
            importes.append("S/ \(item.subtotal().conDecimales)")
        }
        return importes.joined(separator: "\n")
    }

    // "Descuento (10%)": el porcentaje cambia según el tramo del subtotal
    func textoDeDescuento() -> String {
        let porcentaje = Int((porcentajeDescuento() * 100).rounded())
        return "Descuento (\(porcentaje)%)"
    }
}
