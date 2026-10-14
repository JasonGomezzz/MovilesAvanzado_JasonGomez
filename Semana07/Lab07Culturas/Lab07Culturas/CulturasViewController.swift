//
//  CulturasViewController.swift
//  Lab07Culturas
//
//  Created by Jason on 14/10/26.
//

// Desarrollado por: Jason Gomez
import UIKit

// Pantalla 1: lista de culturas peruanas en un UITableView
class CulturasViewController: UIViewController, UITableViewDataSource {

    let culturas = Cultura.todas

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // El botón de regreso del detalle dice "Culturas" en vez del título largo
        navigationItem.backButtonTitle = "Culturas"
    }

    // Al volver desde el detalle la fila queda sin resaltar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let seleccionada = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: seleccionada, animated: animated)
        }
    }

    // Cantidad de filas que tendrá la tabla
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return culturas.count
    }

    // Reutiliza la celda "culturaCell" y le entrega la cultura de esa fila
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let celda = tableView.dequeueReusableCell(withIdentifier: "culturaCell", for: indexPath) as? CulturaTableViewCell else {
            return UITableViewCell()
        }
        celda.configurar(con: culturas[indexPath.row])
        return celda
    }
}
