//
//  ViewController.swift
//  Lab07B
//
//  Created by Jason on 14/10/26.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Arreglos paralelos: el nombre y la imagen de cada persona comparten el mismo índice
    var personasArreglo = ["Jaime Gomez", "Juan León", "Silvia Montoya", "Theo Diaz", "Elliot Garamendi"]
    var personasImagenarreglo = ["avatar1", "avatar2", "avatar3", "avatar4", "avatar5"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // Cantidad de filas que tendrá la tabla
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personasArreglo.count
    }

    // Reutiliza la celda personalizada "miCell" y le asigna el nombre y la imagen
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "miCell") as? PersonasTableViewCell else {
            return UITableViewCell()
        }
        cell.personaNombre.text = personasArreglo[indexPath.row]
        cell.PersonaImagen.image = UIImage(named: personasImagenarreglo[indexPath.row])
        return cell
    }

    // Al seleccionar una fila se muestra una alerta con el nombre del docente
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alerta = UIAlertController(title: "El docente que seleccionó es:",
                                       message: personasArreglo[indexPath.row],
                                       preferredStyle: .alert)
        // Botón OK que cierra la alerta
        alerta.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alerta, animated: true, completion: nil)
    }

}
