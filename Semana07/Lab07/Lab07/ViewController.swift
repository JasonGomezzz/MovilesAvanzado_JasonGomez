//
//  ViewController.swift
//  Lab07
//
//  Created by Jason on 14/10/26.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // 1. Lista de Profesores con sus respectivas imágenes (Paso 17)
    var listaProfesores = [
        Profesor(nombre: "Jaime Gomez", cargo: "Coordinador de Software", foto: UIImage(named: "avatar1")),
        Profesor(nombre: "Jaime Farfan", cargo: "Docente de Software TC", foto: UIImage(named: "avatar2")),
        Profesor(nombre: "Juan León", cargo: "Docente de Software TC", foto: UIImage(named: "avatar4")),
        Profesor(nombre: "Silvia Montoya", cargo: "Docente de Software TC", foto: UIImage(named: "avatar3")),
        Profesor(nombre: "Theobaldo Diaz", cargo: "Docente de Software TC", foto: UIImage(named: "avatar5")),
        Profesor(nombre: "Elliot Garamendi", cargo: "Docente de Software TC", foto: UIImage(named: "avatar4")),
        Profesor(nombre: "Edwin Huerto", cargo: "Docente de Redes TC", foto: UIImage(named: "avatar2"))
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Configuración adicional si fuera necesaria
    }

    // 2. Cantidad de filas que tendrá la tabla
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaProfesores.count
    }

    // 3. Configuración y reutilización de cada celda con imagen (Paso 18)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda")!
        cell.textLabel?.text = listaProfesores[indexPath.row].nombre
        cell.detailTextLabel?.text = String(listaProfesores[indexPath.row].cargo)
        cell.imageView?.image = listaProfesores[indexPath.row].foto!
        return cell
    }

}
