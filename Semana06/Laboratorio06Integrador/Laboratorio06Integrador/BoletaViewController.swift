//
//  BoletaViewController.swift
//  Laboratorio06Integrador
//
//  Created by Jason on 7/10/26.
//

// Desarrollado por: Jason Gomez
import UIKit

class BoletaViewController: UIViewController {

    // Llegan desde Datos del cliente en prepare(for:sender:)
    var carrito: CarritoModel!
    var cliente: ClienteModel!

    @IBOutlet weak var clienteLabel: UILabel!
    @IBOutlet weak var lineasLabel: UILabel!
    @IBOutlet weak var importesLabel: UILabel!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var descuentoTituloLabel: UILabel!
    @IBOutlet weak var descuentoLabel: UILabel!
    @IBOutlet weak var igvLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Solo se cierra con el botón "Cerrar": si se pudiera deslizar hacia abajo,
        // la compra ya confirmada quedaría a medias en la pantalla de atrás
        isModalInPresentation = true

        // Primero se dibuja la boleta con los datos del carrito...
        clienteLabel.text = "\(cliente.Nombre) \(cliente.Apellido) (\(carrito.categoriaCliente())) · DNI \(cliente.Dni)"
        lineasLabel.text = carrito.textoDeLineas()
        importesLabel.text = carrito.textoDeImportes()
        subtotalLabel.text = "S/ \(carrito.subtotal().conDecimales)"
        descuentoTituloLabel.text = carrito.textoDeDescuento()
        descuentoLabel.text = "-S/ \(carrito.montoDescuento().conDecimales)"
        igvLabel.text = "S/ \(carrito.igv().conDecimales)"
        totalLabel.text = "S/ \(carrito.total().conDecimales)"

        // ...y recién entonces se confirma la compra (Regla 9): baja el stock de cada
        // producto y el carrito queda vacío
        carrito.confirmarCompra()
    }

    // Reto 1: al cerrar la boleta se vuelve directo al Catálogo.
    // La boleta se presenta desde una pantalla que vive dentro del Navigation Controller,
    // así que su presentingViewController es ese Navigation Controller.
    @IBAction func cerrarTapped(_ sender: UIButton) {
        let navegacion = presentingViewController as? UINavigationController
        dismiss(animated: true) {
            // Cuando el modal termina de cerrarse se desapila todo hasta el Catálogo
            navegacion?.popToRootViewController(animated: true)
        }
    }
}
