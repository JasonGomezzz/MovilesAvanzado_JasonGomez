//
//  DatosClienteViewController.swift
//  Laboratorio06Integrador
//
//  Created by Jason on 7/10/26.
//

// Desarrollado por: Jason Gomez
import UIKit

class DatosClienteViewController: UIViewController {

    // Llega desde el Carrito en prepare(for:sender:)
    var carrito: CarritoModel!

    @IBOutlet weak var apellidosTextField: UITextField!
    @IBOutlet weak var nombresTextField: UITextField!
    @IBOutlet weak var dniTextField: UITextField!

    // El segue verBoleta sale del View Controller (no del botón) para poder
    // validar antes de presentar la boleta
    @IBAction func confirmarTapped(_ sender: UIButton) {
        let apellidos = (apellidosTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let nombres = (nombresTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let dni = (dniTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        // Regla 8: los tres campos son obligatorios
        if apellidos.isEmpty || nombres.isEmpty || dni.isEmpty {
            mostrarAlerta(titulo: "Datos incompletos",
                          mensaje: "Completa apellidos, nombres y DNI para continuar.")
            return
        }

        // Regla 8: el DNI tiene exactamente 8 dígitos
        if !esDniValido(dni) {
            mostrarAlerta(titulo: "DNI inválido",
                          mensaje: "El DNI debe tener exactamente 8 dígitos numéricos.")
            return
        }

        // El cliente viaja en `sender` y prepare lo recoge. El código es fijo (1):
        // la tienda atiende a un solo cliente por compra y no hay base de datos.
        let cliente = ClienteModel(pCodigo: 1, pApellido: apellidos, pNombre: nombres, pDni: dni)
        performSegue(withIdentifier: "verBoleta", sender: cliente)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verBoleta" {
            let destino = segue.destination as! BoletaViewController
            destino.carrito = carrito              // el MISMO carrito de todo el recorrido
            destino.cliente = sender as? ClienteModel
        }
    }

    // Exactamente 8 caracteres y todos entre "0" y "9" (así no pasan letras ni
    // otros símbolos que Character.isNumber también aceptaría)
    private func esDniValido(_ dni: String) -> Bool {
        return dni.count == 8 && dni.allSatisfy { ("0"..."9").contains($0) }
    }
}
