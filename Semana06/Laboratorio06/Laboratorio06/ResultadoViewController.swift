//
//  ResultadoViewController.swift
//  Laboratorio06
//
//  Created by Jason on 06/10/26.
//

import UIKit

class ResultadoViewController: UIViewController {

    var pVenta: VentaModel = VentaModel()

    @IBOutlet weak var lblSubtotal: UILabel!
    @IBOutlet weak var lblIgv: UILabel!
    @IBOutlet weak var lblBase: UILabel!
    @IBOutlet weak var lblIntereses: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblCuota: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
