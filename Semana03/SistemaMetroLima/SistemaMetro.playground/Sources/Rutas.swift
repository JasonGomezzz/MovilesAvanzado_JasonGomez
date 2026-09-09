// Desarrollado por: Jason Gomez

import Foundation

private func recorridoDeLinea(_ linea: Int) -> [String] {
    switch linea {
    case 1:
        return recorridoLinea1
    case 2:
        return recorridoLinea2
    default:
        return []
    }
}

private func tramo(
    en recorrido: [String],
    desde origen: String,
    hasta destino: String
) -> [String]? {
    guard
        let posicionOrigen = recorrido.firstIndex(of: origen),
        let posicionDestino = recorrido.firstIndex(of: destino)
    else {
        return nil
    }

    if posicionOrigen <= posicionDestino {
        return Array(recorrido[posicionOrigen...posicionDestino])
    }

    return Array(recorrido[posicionDestino...posicionOrigen].reversed())
}

private func recorridoParaRutaDirecta(
    linea: Int,
    origen: Estacion,
    destino: Estacion
) -> [String] {
    let recorridoCompleto = recorridoDeLinea(linea)

    guard origen.estado == .operativa, destino.estado == .operativa else {
        return recorridoCompleto
    }

    return recorridoCompleto.filter { nombre in
        buscarEstacionExacta(nombre: nombre)?.estado == .operativa
    }
}

private func crearAdvertencias(
    estaciones: [String],
    incluyeTransbordoPlanificado: Bool
) -> [String] {
    var noOperativas: [String] = []

    for nombre in estaciones {
        guard let estacion = buscarEstacionExacta(nombre: nombre) else {
            continue
        }

        if estacion.estado != .operativa && !noOperativas.contains(estacion.nombre) {
            noOperativas.append(estacion.nombre)
        }
    }

    var advertencias: [String] = []

    if !noOperativas.isEmpty {
        advertencias.append(
            "La ruta incluye estaciones que todavía no están operativas: "
                + noOperativas.joined(separator: ", ")
                + "."
        )
    }

    if incluyeTransbordoPlanificado {
        advertencias.append(
            "El intercambio entre las líneas 1 y 2 en 28 de Julio está planificado y aún no está disponible."
        )
    }

    return advertencias
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
                incluyeTransbordoPlanificado: false
            )
        )
    }

    for linea in origen.lineas {
        if destino.lineas.contains(linea) {
            let recorrido = recorridoParaRutaDirecta(
                linea: linea,
                origen: origen,
                destino: destino
            )

            guard let estaciones = tramo(
                en: recorrido,
                desde: origen.nombre,
                hasta: destino.nombre
            ) else {
                return nil
            }

            return ResultadoRuta(
                origen: origen.nombre,
                destino: destino.nombre,
                estaciones: estaciones,
                advertencias: crearAdvertencias(
                    estaciones: estaciones,
                    incluyeTransbordoPlanificado: false
                )
            )
        }
    }

    guard
        let lineaOrigen = origen.lineas.first,
        let lineaDestino = destino.lineas.first,
        [lineaOrigen, lineaDestino].allSatisfy({ $0 == 1 || $0 == 2 }),
        lineaOrigen != lineaDestino,
        let primerTramo = tramo(
            en: recorridoDeLinea(lineaOrigen),
            desde: origen.nombre,
            hasta: estacion28DeJulio.nombre
        ),
        let segundoTramo = tramo(
            en: recorridoDeLinea(lineaDestino),
            desde: estacion28DeJulio.nombre,
            hasta: destino.nombre
        )
    else {
        return nil
    }

    let estaciones = primerTramo + segundoTramo.dropFirst()
    let transbordo = "Cambiar de Línea \(lineaOrigen) a Línea \(lineaDestino) en 28 de Julio."

    return ResultadoRuta(
        origen: origen.nombre,
        destino: destino.nombre,
        estaciones: estaciones,
        transbordos: [transbordo],
        advertencias: crearAdvertencias(
            estaciones: estaciones,
            incluyeTransbordoPlanificado: true
        )
    )
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
