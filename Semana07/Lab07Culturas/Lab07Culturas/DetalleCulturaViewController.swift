//
//  DetalleCulturaViewController.swift
//  Lab07Culturas
//
//  Created by Jason on 14/10/26.
//

// Desarrollado por: Jason Gomez
import UIKit

// Pantalla 2: detalle de la cultura seleccionada
class DetalleCulturaViewController: UIViewController {

    // Llega desde la lista en prepare(for:sender:), ANTES de viewDidLoad.
    // En prepare los IBOutlet todavía son nil: por eso aquí solo se guarda la cultura
    // y los controles se llenan en viewDidLoad.
    var cultura: Cultura?

    @IBOutlet weak var imagenImageView: UIImageView!
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var descripcionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let cultura = cultura else { return }
        title = cultura.nombre
        imagenImageView.image = UIImage(named: cultura.imagen)
        imagenImageView.isAccessibilityElement = true
        imagenImageView.accessibilityLabel = "Imagen representativa de la cultura \(cultura.nombre)"
        nombreLabel.text = cultura.nombre
        regionLabel.text = "Región: \(cultura.region)"
        descripcionLabel.text = cultura.descripcion
    }
}
