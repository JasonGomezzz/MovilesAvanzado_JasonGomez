//
//  ViewController.swift
//  Laboratorio06
//
//  Created by Jason on 30/09/26.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tfApellido: UITextField!
    @IBOutlet weak var tfNombre: UITextField!
    @IBOutlet weak var tfDni: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func btnContinuar(_ sender: Any) {
        let oCliente = ClienteModel(
            pCodigo: 0,
            pApellido: self.tfApellido.text ?? "",
            pNombre: self.tfNombre.text ?? "",
            pDni: self.tfDni.text ?? ""
        )
        
        let osb = UIStoryboard(name: "Main", bundle: nil)
        let oPantalla2 = osb.instantiateViewController(identifier: "ViewController2") as! ViewController2
        oPantalla2.pCliente = oCliente
        self.present(oPantalla2, animated: true, completion: nil)
    }
}
