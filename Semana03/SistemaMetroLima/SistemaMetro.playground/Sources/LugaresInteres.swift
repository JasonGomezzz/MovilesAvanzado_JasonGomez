// Desarrollado por: Jason Gomez

import Foundation

public let lugaresInteresRegistrados: [LugarInteres] = [
    LugarInteres(
        nombre: "Estadio Nacional",
        estacionRecomendada: "Estación Central",
        indicacionesFinales: [
            "Realizar la conexión con el Metropolitano en la Estación Central.",
            "Viajar por el Metropolitano hasta la estación Estadio Nacional.",
            "Caminar desde la estación del Metropolitano hasta el Estadio Nacional."
        ]
    ),
    LugarInteres(
        nombre: "Gamarra",
        estacionRecomendada: "Gamarra",
        indicacionesFinales: [
            "Salir de la estación Gamarra hacia el emporio comercial."
        ]
    ),
    LugarInteres(
        nombre: "Museo de la Nación",
        estacionRecomendada: "La Cultura",
        indicacionesFinales: [
            "Salir de la estación La Cultura hacia la avenida Javier Prado Este.",
            "Caminar hacia la sede del Ministerio de Cultura."
        ]
    ),
    LugarInteres(
        nombre: "Mercado Mayorista de Santa Anita",
        estacionRecomendada: "Mercado Santa Anita",
        indicacionesFinales: [
            "Salir de la estación Mercado Santa Anita hacia la avenida Separadora Industrial.",
            "Continuar hacia el Mercado Mayorista de Santa Anita."
        ]
    ),
    LugarInteres(
        nombre: "Plaza de Armas de Ate",
        estacionRecomendada: "Municipalidad de Ate",
        indicacionesFinales: [
            "Salir de la estación Municipalidad de Ate frente a la plaza de Armas."
        ]
    )
]

public let catalogoLugaresInteres: [String: LugarInteres] = {
    var catalogo: [String: LugarInteres] = [:]

    for lugar in lugaresInteresRegistrados {
        catalogo[normalizarTexto(lugar.nombre)] = lugar
    }

    return catalogo
}()

public func buscarLugarInteres(nombre: String) -> [LugarInteres] {
    let consulta = normalizarTexto(nombre)

    guard !consulta.isEmpty else {
        return []
    }

    if let coincidenciaExacta = catalogoLugaresInteres[consulta] {
        return [coincidenciaExacta]
    }

    return catalogoLugaresInteres.values
        .filter { normalizarTexto($0.nombre).contains(consulta) }
        .sorted { $0.nombre.localizedCaseInsensitiveCompare($1.nombre) == .orderedAscending }
}

public func recomendarLugar(desde origen: String, hacia nombreLugar: String) -> ResultadoRuta? {
    guard
        let lugar = catalogoLugaresInteres[normalizarTexto(nombreLugar)],
        let ruta = calcularRuta(desde: origen, hasta: lugar.estacionRecomendada)
    else {
        return nil
    }

    var advertencias = ruta.advertencias

    if lugar.nombre == "Estadio Nacional" {
        advertencias.append(
            "La conexión entre la Línea 2 y el Metropolitano en la Estación Central está planificada."
        )
    }

    return ResultadoRuta(
        origen: ruta.origen,
        destino: lugar.nombre,
        estaciones: ruta.estaciones,
        transbordos: ruta.transbordos,
        advertencias: advertencias,
        indicacionesFinales: lugar.indicacionesFinales
    )
}
