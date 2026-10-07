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
