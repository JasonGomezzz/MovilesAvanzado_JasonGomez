//
//  Cultura+Datos.swift
//  Lab07Culturas
//
//  Created by Jason on 14/10/26.
//

// Desarrollado por: Jason Gomez
import Foundation

extension Cultura {

    // Las ocho culturas del caso, en orden cronológico. Es la ÚNICA fuente de datos:
    // la lista y el detalle leen de aquí, así que agregar una cultura nueva es agregar
    // un elemento a este arreglo y un imageset en Assets con el mismo nombre de `imagen`.
    static let todas: [Cultura] = [
        Cultura(nombre: "Caral",
                region: "Lima (valle de Supe)",
                descripcion: "Considerada la civilización más antigua de América, floreció hace unos 5 000 años (3000–1800 a. C.). Su ciudad sagrada tiene pirámides escalonadas, plazas circulares hundidas y una agricultura con riego. Fue declarada Patrimonio Mundial por la UNESCO en 2009.",
                imagen: "caral"),
        Cultura(nombre: "Chavín",
                region: "Áncash (Chavín de Huántar)",
                descripcion: "Cultura formativa que se desarrolló entre 1200 y 200 a. C. Su centro ceremonial, Chavín de Huántar, guarda galerías subterráneas y el Lanzón monolítico. Su arte, con felinos, serpientes y aves estilizados, influyó en gran parte de los Andes.",
                imagen: "chavin"),
        Cultura(nombre: "Paracas",
                region: "Ica (península de Paracas)",
                descripcion: "Se desarrolló entre 700 a. C. y 200 d. C. en el desierto costero del sur. Es famosa por sus mantos funerarios bordados con colores intensos y por practicar trepanaciones y deformaciones del cráneo.",
                imagen: "paracas"),
        Cultura(nombre: "Nazca",
                region: "Ica (provincia de Nasca)",
                descripcion: "Prosperó entre 100 a. C. y 800 d. C. Dibujó en el desierto los gigantescos geoglifos de las Líneas de Nasca (colibrí, mono, araña) y construyó acueductos subterráneos llamados puquios. También destacó por su cerámica polícroma.",
                imagen: "nazca"),
        Cultura(nombre: "Moche",
                region: "La Libertad y Lambayeque",
                descripcion: "Cultura de la costa norte que floreció entre 100 y 800 d. C. Levantó las huacas del Sol y de la Luna, y en Sipán se halló la tumba del Señor de Sipán. Se destacó por su metalurgia en oro y por sus ceramios retrato.",
                imagen: "moche"),
        Cultura(nombre: "Wari",
                region: "Ayacucho",
                descripcion: "Primer gran imperio andino, desarrollado entre 600 y 1000 d. C. con capital cerca de la actual Ayacucho. Expandió su dominio por la sierra y la costa con caminos, centros administrativos y terrazas de cultivo, y destacó por sus finos tejidos.",
                imagen: "wari"),
        Cultura(nombre: "Chimú",
                region: "La Libertad (Chan Chan)",
                descripcion: "Reino de la costa norte entre 900 y 1470 d. C., con capital en Chan Chan, la ciudad de adobe más grande de América. Sus muros se decoran con frisos de peces, olas y rombos. Fueron grandes orfebres hasta que los incas los conquistaron.",
                imagen: "chimu"),
        Cultura(nombre: "Inca",
                region: "Cusco (capital del Tahuantinsuyo)",
                descripcion: "Imperio andino que alcanzó su máximo esplendor entre 1438 y 1533 d. C., con capital en Cusco. Construyó Machu Picchu, el Qhapaq Ñan y andenes de cultivo, y gobernaba el Tahuantinsuyo bajo el mando del Sapa Inca. Su lengua principal era el quechua.",
                imagen: "inca")
    ]
}
