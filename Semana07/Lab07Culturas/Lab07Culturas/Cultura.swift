//
//  Cultura.swift
//  Lab07Culturas
//
//  Created by Jason on 14/10/26.
//

// Desarrollado por: Jason Gomez
import Foundation

// Una cultura es un dato de solo lectura: se usa `struct` porque el detalle recibe su propia
// copia y nunca necesita modificar la que está en la lista.
struct Cultura {
    let nombre: String
    let region: String
    let descripcion: String
    // Nombre del imageset dentro de Assets. El modelo guarda el nombre y no la UIImage
    // para no depender de UIKit; cada pantalla carga la imagen cuando la necesita.
    let imagen: String
}
