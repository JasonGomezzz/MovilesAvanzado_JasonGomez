//
//  NuevaVentaViewController.swift
//  Laboratorio06
//
//  Created by Jason on 06/10/26.
//

import UIKit

class NuevaVentaViewController: UIViewController {

    @IBOutlet weak var tfElectrodomestico: UITextField!
    @IBOutlet weak var tfPrecio: UITextField!
    @IBOutlet weak var tfCantidad: UITextField!
    @IBOutlet weak var tfMeses: UITextField!
    @IBOutlet weak var tfInteres: UITextField!
    @IBOutlet weak var lblError: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblError.text = ""
    }

    // Un texto vacío o inválido toma un valor que datosValidos() descarta
    func datosValidos() -> Bool {
        let precioUnitario = Double(self.tfPrecio.text ?? "") ?? 0
        let cantidad = Int(self.tfCantidad.text ?? "") ?? 0
        let meses = Int(self.tfMeses.text ?? "") ?? 0
        let tasaInteresMensual = Double(self.tfInteres.text ?? "") ?? -1

        if (self.tfElectrodomestico.text ?? "") == "" {
            return false
        }
        return precioUnitario > 0 && cantidad > 0 && meses > 0 && tasaInteresMensual >= 0
    }

    // Aplica las fórmulas del enunciado y arma el VentaModel con los resultados
    func calcularVenta() -> VentaModel {
        let precioUnitario = Double(self.tfPrecio.text ?? "") ?? 0
        let cantidad = Double(Int(self.tfCantidad.text ?? "") ?? 0)
        let meses = Double(Int(self.tfMeses.text ?? "") ?? 0)
        let tasaInteresMensual = Double(self.tfInteres.text ?? "") ?? 0

        let subtotal = precioUnitario * cantidad
        let igv = subtotal * 0.18
        let base = subtotal + igv
        let intereses = base * (tasaInteresMensual / 100) * meses
        let total = base + intereses
        let cuota = total / meses

        return VentaModel(
            pSubtotal: subtotal,
            pIgv: igv,
            pBase: base,
            pIntereses: intereses,
            pTotal: total,
            pCuota: cuota
        )
    }

    // El segue showResultado solo se ejecuta si los datos son válidos
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showResultado" {
            if self.datosValidos() {
                self.lblError.text = ""
                return true
            }
            self.lblError.text = "Completa todos los campos. Precio, cantidad y meses deben ser mayores que 0."
            return false
        }
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResultado" {
            let oPantallaResultado = segue.destination as! ResultadoViewController
            oPantallaResultado.pVenta = self.calcularVenta()
        }
    }
}
