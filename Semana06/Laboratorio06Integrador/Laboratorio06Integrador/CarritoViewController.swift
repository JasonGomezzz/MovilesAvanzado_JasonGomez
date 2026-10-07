//
//  CarritoViewController.swift
//  Laboratorio06Integrador
//
//  Created by Jason on 7/10/26.
//

// Desarrollado por: Jason Gomez
import UIKit

class CarritoViewController: UIViewController {

    // Llega desde el Catálogo en prepare(for:sender:): es EL MISMO carrito (Regla 2)
    var carrito: CarritoModel!

    @IBOutlet weak var lineasLabel: UILabel!
    @IBOutlet weak var importesLabel: UILabel!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var descuentoTituloLabel: UILabel!
    @IBOutlet weak var descuentoLabel: UILabel!
    @IBOutlet weak var igvLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var categoriaLabel: UILabel!

    // Esta pantalla solo muestra: todos los números los calcula CarritoModel (Regla 5)
    override func viewDidLoad() {
        super.viewDidLoad()
        if carrito.items.isEmpty {
            lineasLabel.text = "Tu carrito está vacío"
            importesLabel.text = ""
        } else {
            lineasLabel.text = carrito.textoDeLineas()
            importesLabel.text = carrito.textoDeImportes()
        }
        subtotalLabel.text = "S/ \(carrito.subtotal().conDecimales)"
        descuentoTituloLabel.text = carrito.textoDeDescuento()
        descuentoLabel.text = "-S/ \(carrito.montoDescuento().conDecimales)"
        igvLabel.text = "S/ \(carrito.igv().conDecimales)"
        totalLabel.text = "S/ \(carrito.total().conDecimales)"
        categoriaLabel.text = "Categoría: \(carrito.categoriaCliente())"
    }

    // El segue irDatosCliente sale del View Controller (no del botón) para poder
    // validar antes de navegar
    @IBAction func finalizarTapped(_ sender: UIButton) {
        if carrito.items.isEmpty {
            mostrarAlerta(titulo: "Carrito vacío",
                          mensaje: "Agrega al menos un producto antes de finalizar la compra.")
            return
        }
        performSegue(withIdentifier: "irDatosCliente", sender: nil)
    }
}
