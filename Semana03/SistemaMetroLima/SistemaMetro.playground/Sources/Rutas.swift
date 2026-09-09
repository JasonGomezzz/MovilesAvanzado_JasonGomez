// Desarrollado por: Jason Gomez

import Foundation

private struct EnlaceRuta {
    let destino: String
    let linea: Int
}

private let recorridosPorLinea: [Int: [String]] = [
    1: recorridoLinea1,
    2: recorridoLinea2,
    3: recorridoLinea3,
    4: recorridoLinea4
]

private func agregarEnlace(
    desde origen: String,
    hasta destino: String,
    linea: Int,
    en red: inout [String: [EnlaceRuta]]
) {
    let enlaceIda = EnlaceRuta(destino: destino, linea: linea)
    let enlaceVuelta = EnlaceRuta(destino: origen, linea: linea)

    if red[origen, default: []].contains(where: {
        $0.destino == destino && $0.linea == linea
    }) == false {
        red[origen, default: []].append(enlaceIda)
    }

    if red[destino, default: []].contains(where: {
        $0.destino == origen && $0.linea == linea
    }) == false {
        red[destino, default: []].append(enlaceVuelta)
    }
}

private let redMetro: [String: [EnlaceRuta]] = {
    var red: [String: [EnlaceRuta]] = [:]

    for linea in recorridosPorLinea.keys.sorted() {
        guard let recorrido = recorridosPorLinea[linea], recorrido.count > 1 else {
            continue
        }

        for posicion in 0..<(recorrido.count - 1) {
            agregarEnlace(
                desde: recorrido[posicion],
                hasta: recorrido[posicion + 1],
                linea: linea,
                en: &red
            )
        }
    }

    agregarEnlace(
        desde: "Gamarra",
        hasta: "Miguel Grau",
        linea: 1,
        en: &red
    )

    return red
}()

private func estadoDeEstacion(_ nombre: String, en linea: Int) -> EstadoServicio? {
    buscarEstacionExacta(nombre: nombre)?.estadosPorLinea[linea]
}

private func crearTransbordos(
    estaciones: [String],
    lineasDeTramos: [Int]
) -> [String] {
    guard lineasDeTramos.count > 1 else {
        return []
    }

    var transbordos: [String] = []

    for posicion in 1..<lineasDeTramos.count {
        let lineaAnterior = lineasDeTramos[posicion - 1]
        let lineaSiguiente = lineasDeTramos[posicion]

        if lineaAnterior != lineaSiguiente {
            transbordos.append(
                "Cambiar de Línea \(lineaAnterior) a Línea \(lineaSiguiente) en \(estaciones[posicion])."
            )
        }
    }

    return transbordos
}

private func crearAdvertencias(
    estaciones: [String],
    lineasDeTramos: [Int]
) -> [String] {
    var estacionesNoOperativas: [String] = []

    if lineasDeTramos.isEmpty, let estacion = estaciones.first,
       buscarEstacionExacta(nombre: estacion)?.estado != .operativa {
        estacionesNoOperativas.append(estacion)
    }

    for posicion in lineasDeTramos.indices {
        let linea = lineasDeTramos[posicion]
        let estacionesDelTramo = [estaciones[posicion], estaciones[posicion + 1]]

        for nombre in estacionesDelTramo {
            if estadoDeEstacion(nombre, en: linea) != .operativa,
               estacionesNoOperativas.contains(nombre) == false {
                estacionesNoOperativas.append(nombre)
            }
        }
    }

    var advertencias: [String] = []

    if estacionesNoOperativas.isEmpty == false {
        advertencias.append(
            "La ruta incluye infraestructura que todavía no está operativa: "
                + estacionesNoOperativas.joined(separator: ", ")
                + "."
        )
    }

    guard lineasDeTramos.count > 1 else {
        return advertencias
    }

    for posicion in 1..<lineasDeTramos.count {
        let lineaAnterior = lineasDeTramos[posicion - 1]
        let lineaSiguiente = lineasDeTramos[posicion]

        guard lineaAnterior != lineaSiguiente else {
            continue
        }

        let nombreIntercambio = estaciones[posicion]
        let estadoAnterior = estadoDeEstacion(nombreIntercambio, en: lineaAnterior)
        let estadoSiguiente = estadoDeEstacion(nombreIntercambio, en: lineaSiguiente)

        if estadoAnterior != .operativa || estadoSiguiente != .operativa {
            advertencias.append(
                "El intercambio de Línea \(lineaAnterior) a Línea \(lineaSiguiente) "
                    + "en \(nombreIntercambio) todavía no está disponible."
            )
        }
    }

    return advertencias
}

private func reconstruirRuta(
    origen: String,
    destino: String,
    anteriores: [String: (estacion: String, linea: Int)]
) -> ResultadoRuta? {
    var estacionesInvertidas = [destino]
    var lineasInvertidas: [Int] = []
    var actual = destino

    while actual != origen {
        guard let pasoAnterior = anteriores[actual] else {
            return nil
        }

        lineasInvertidas.append(pasoAnterior.linea)
        actual = pasoAnterior.estacion
        estacionesInvertidas.append(actual)
    }

    let estacionesOrdenadas = Array(estacionesInvertidas.reversed())
    let lineasOrdenadas = Array(lineasInvertidas.reversed())

    return ResultadoRuta(
        origen: origen,
        destino: destino,
        estaciones: estacionesOrdenadas,
        transbordos: crearTransbordos(
            estaciones: estacionesOrdenadas,
            lineasDeTramos: lineasOrdenadas
        ),
        advertencias: crearAdvertencias(
            estaciones: estacionesOrdenadas,
            lineasDeTramos: lineasOrdenadas
        )
    )
}

public func calcularRuta(desde origenIngresado: String, hasta destinoIngresado: String) -> ResultadoRuta? {
    guard
        let origen = buscarEstacionExacta(nombre: origenIngresado),
        let destino = buscarEstacionExacta(nombre: destinoIngresado)
    else {
        return nil
    }

    if origen.nombre == destino.nombre {
        return ResultadoRuta(
            origen: origen.nombre,
            destino: destino.nombre,
            estaciones: [origen.nombre],
            advertencias: crearAdvertencias(
                estaciones: [origen.nombre],
                lineasDeTramos: []
            )
        )
    }

    var cola = [origen.nombre]
    var posicionActual = 0
    var visitadas: Set<String> = [origen.nombre]
    var anteriores: [String: (estacion: String, linea: Int)] = [:]

    while posicionActual < cola.count {
        let estacionActual = cola[posicionActual]
        posicionActual += 1

        for enlace in redMetro[estacionActual, default: []] {
            guard visitadas.insert(enlace.destino).inserted else {
                continue
            }

            anteriores[enlace.destino] = (estacionActual, enlace.linea)

            if enlace.destino == destino.nombre {
                return reconstruirRuta(
                    origen: origen.nombre,
                    destino: destino.nombre,
                    anteriores: anteriores
                )
            }

            cola.append(enlace.destino)
        }
    }

    return nil
}

public func descripcionRuta(_ ruta: ResultadoRuta) -> String {
    var contenido: [String] = []
    contenido.append("Origen: \(ruta.origen)")
    contenido.append("Destino: \(ruta.destino)")
    contenido.append("Recorrido: \(ruta.estaciones.joined(separator: " -> "))")

    for transbordo in ruta.transbordos {
        contenido.append("Transbordo: \(transbordo)")
    }

    for indicacion in ruta.indicacionesFinales {
        contenido.append("Indicación: \(indicacion)")
    }

    for advertencia in ruta.advertencias {
        contenido.append("Advertencia: \(advertencia)")
    }

    return contenido.joined(separator: "\n")
}
