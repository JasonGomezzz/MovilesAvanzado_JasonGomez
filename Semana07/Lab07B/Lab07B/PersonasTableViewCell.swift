//
//  PersonasTableViewCell.swift
//  Lab07B
//
//  Created by Jason on 14/10/26.
//

import UIKit

class PersonasTableViewCell: UITableViewCell {

    // Controles de la celda prototipo "miCell" enlazados desde el storyboard
    @IBOutlet weak var PersonaImagen: UIImageView!
    @IBOutlet weak var personaNombre: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
