//
//  CulturaTableViewCell.swift
//  Lab07Culturas
//
//  Created by Jason on 14/10/26.
//

// Desarrollado por: Jason Gomez
import UIKit

class CulturaTableViewCell: UITableViewCell {

    // Controles de la celda prototipo "culturaCell", enlazados desde el storyboard
    @IBOutlet weak var imagenImageView: UIImageView!
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        imagenImageView.layer.cornerRadius = 8
        imagenImageView.clipsToBounds = true
        // La imagen es decorativa: VoiceOver ya lee el nombre de la cultura
        imagenImageView.isAccessibilityElement = false
    }

    // La celda sabe pintar una cultura; el controlador solo se la entrega
    func configurar(con cultura: Cultura) {
        imagenImageView.image = UIImage(named: cultura.imagen)
        nombreLabel.text = cultura.nombre
        regionLabel.text = cultura.region
    }
}
