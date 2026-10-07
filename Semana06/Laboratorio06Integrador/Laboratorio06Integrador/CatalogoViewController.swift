//
//  CatalogoViewController.swift
//  Laboratorio06Integrador
//
//  Created by Jason on 7/10/26.
//

// Desarrollado por: Jason Gomez
import UIKit

class CatalogoViewController: UIViewController {

    // Los datos fijos del caso (Regla 1)
    //
    // Prueba final (Regla 10): agregar un quinto producto, el Microondas.
    // ¿Cuántos cambios hicieron falta?
    //  - Storyboard: 1. Un botón nuevo dentro del stack view, con Tag 4 y conectado a la
    //    misma acción productoTapped. El stack acomoda solo al resto y el segue
    //    verDetalle se reutiliza, no se dibuja otro.
    //  - Código: 1. La línea del Microondas en este array. Lo demás (prepare, Detalle,
    //    Carrito y Boleta) no cambia porque todo parte de productos[boton.tag].
    let productos: [Producto] = [
        Producto(nombre: "Refrigeradora", precio: 2000, stock: 5),
        Producto(nombre: "Licuadora", precio: 250, stock: 10),
        Producto(nombre: "Laptop", precio: 3500, stock: 3),
        Producto(nombre: "Cocina", precio: 1200, stock: 4),
        Producto(nombre: "Microondas", precio: 450, stock: 6)
    ]

    // El carrito se crea UNA sola vez, aquí (Regla 2)
    let carrito = CarritoModel()

    @IBOutlet weak var verCarritoButton: UIButton!

    // Los botones de producto apuntan a esta MISMA acción.
    // En el Inspector de Atributos, el Tag de cada botón vale 0, 1, 2, 3 y 4,
    // igual que la posición del producto en el array `productos`.
    @IBAction func productoTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "verDetalle", sender: sender)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verDetalle" {
            let boton = sender as! UIButton
            let destino = segue.destination as! DetalleViewController
            destino.producto = productos[boton.tag]  // elige el producto según el tag
            destino.carrito = carrito                // el MISMO objeto, no una copia
        }
        // B1: el carrito también viaja al Carrito
        if segue.identifier == "verCarrito" {
            let destino = segue.destination as! CarritoViewController
            destino.carrito = carrito
        }
    }

    // B2: se ejecuta cada vez que vuelves a esta pantalla, a diferencia de viewDidLoad
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        verCarritoButton.setTitle("Ver carrito (\(carrito.cantidadTotal()))", for: .normal)
    }
}
