//
//  DetalleViewController.swift
//  Laboratorio06Integrador
//
//  Created by Jason on 7/10/26.
//

// Desarrollado por: Jason Gomez
import UIKit

class DetalleViewController: UIViewController {

    // Llegan desde el Catálogo en prepare(for:sender:), ANTES de viewDidLoad.
    // En prepare los IBOutlet todavía son nil: por eso aquí solo se guardan los datos
    // y las etiquetas se llenan en viewDidLoad.
    var producto: Producto!
    var carrito: CarritoModel!

    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var precioLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var cantidadLabel: UILabel!
    @IBOutlet weak var cantidadStepper: UIStepper!

    override func viewDidLoad() {
        super.viewDidLoad()
        nombreLabel.text = producto.nombre
        precioLabel.text = "S/ \(producto.precio.conDecimales)"
        stockLabel.text = "\(producto.stock)"
        cantidadStepper.value = 1
        cantidadLabel.text = "1"
    }

    // El stepper no se limita al stock a propósito: la validación es la del modelo
    // (Regla 8) y se avisa con una alerta al intentar agregar de más.
    @IBAction func cantidadCambio(_ sender: UIStepper) {
        cantidadLabel.text = "\(Int(sender.value))"
    }

    @IBAction func agregarTapped(_ sender: UIButton) {
        let cantidad = Int(cantidadStepper.value)
        if carrito.agregar(producto: producto, cantidad: cantidad) {
            // Agregado: se vuelve al Catálogo, que actualiza "Ver carrito (n)" en viewWillAppear
            navigationController?.popViewController(animated: true)
        } else {
            let enCarrito = carrito.cantidadEnCarrito(de: producto)
            let disponibles = producto.stock - enCarrito
            mostrarAlerta(titulo: "Stock insuficiente",
                          mensaje: "Pediste \(cantidad) de \(producto.nombre), pero solo quedan \(disponibles) disponibles (stock \(producto.stock), ya tienes \(enCarrito) en el carrito).")
        }
    }
}
