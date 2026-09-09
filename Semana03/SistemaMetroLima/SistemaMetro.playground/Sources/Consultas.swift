// Desarrollado por: Jason Gomez

import Foundation

public func normalizarTexto(_ texto: String) -> String {
    texto
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .folding(
            options: [.diacriticInsensitive, .caseInsensitive],
            locale: Locale(identifier: "es_PE")
        )
        .lowercased()
}

private func prioridadEstado(_ estado: EstadoServicio) -> Int {
    switch estado {
    case .operativa:
        return 3
    case .enConstruccion:
        return 2
    case .planificada:
        return 1
    }
}

private func combinarEstaciones(_ primera: Estacion, _ segunda: Estacion) -> Estacion {
    let estacionPrincipal = prioridadEstado(primera.estado) >= prioridadEstado(segunda.estado)
        ? primera
        : segunda
    var estadosPorLinea = primera.estadosPorLinea

    for (linea, estado) in segunda.estadosPorLinea {
        estadosPorLinea[linea] = estado
    }

    var conexiones: [Conexion] = []
    var conexionesRegistradas: Set<String> = []

    for conexion in primera.conexiones + segunda.conexiones {
        let clave = normalizarTexto(
            "\(conexion.sistema)|\(conexion.estacion)|\(conexion.estado.rawValue)"
        )

        if conexionesRegistradas.insert(clave).inserted {
            conexiones.append(conexion)
        }
    }

    return Estacion(
        codigo: estacionPrincipal.codigo,
        nombre: estacionPrincipal.nombre,
        lineas: Array(Set(primera.lineas + segunda.lineas)).sorted(),
        ubicacion: estacionPrincipal.ubicacion,
        distrito: estacionPrincipal.distrito,
        estado: estacionPrincipal.estado,
        estadosPorLinea: estadosPorLinea,
        tieneAscensor: primera.tieneAscensor || segunda.tieneAscensor,
        accesoAlternativo: estacionPrincipal.accesoAlternativo
            ?? primera.accesoAlternativo
            ?? segunda.accesoAlternativo,
        conexiones: conexiones
    )
}

public let catalogoEstaciones: [String: Estacion] = {
    var catalogo: [String: Estacion] = [:]

    let todasLasEstaciones = estacionesRegistradasLinea1
        + estacionesRegistradasLinea2
        + estacionesRegistradasLinea3
        + estacionesRegistradasLinea4

    for estacion in todasLasEstaciones {
        let clave = normalizarTexto(estacion.nombre)

        if let estacionExistente = catalogo[clave] {
            catalogo[clave] = combinarEstaciones(estacionExistente, estacion)
        } else {
            catalogo[clave] = estacion
        }
    }

    return catalogo
}()

public func buscarEstacion(nombre: String) -> [Estacion] {
    let consulta = normalizarTexto(nombre)

    guard !consulta.isEmpty else {
        return []
    }

    if let coincidenciaExacta = catalogoEstaciones[consulta] {
        return [coincidenciaExacta]
    }

    return catalogoEstaciones.values
        .filter { normalizarTexto($0.nombre).contains(consulta) }
        .sorted { $0.nombre.localizedCaseInsensitiveCompare($1.nombre) == .orderedAscending }
}

public func buscarEstacionExacta(nombre: String) -> Estacion? {
    catalogoEstaciones[normalizarTexto(nombre)]
}

public func estacionesDeLinea(_ linea: Int) -> [Estacion] {
    switch linea {
    case 1:
        return estacionesRegistradasLinea1
    case 2:
        return estacionesRegistradasLinea2
    case 3:
        return estacionesRegistradasLinea3
    case 4:
        return estacionesRegistradasLinea4
    default:
        return []
    }
}

public func consultarLinea(_ numero: Int) -> LineaMetro? {
    lineasMetro[numero]
}

public func descripcionLinea(_ linea: LineaMetro) -> String {
    var detalles = [
        "Línea: \(linea.nombre)",
        "Estado: \(linea.estado.rawValue)",
        "Corredor: \(linea.corredor)",
        "Distritos de referencia: \(linea.distritos.joined(separator: ", "))"
    ]

    if let horizonte = linea.horizonte {
        detalles.append("Horizonte referencial: \(horizonte)")
    }

    let estaciones = estacionesDeLinea(linea.numero)
    if linea.tieneCatalogoEstaciones {
        detalles.append("Estaciones registradas: \(estaciones.count)")
    } else {
        detalles.append("Estaciones registradas: catálogo oficial definitivo no disponible")
    }

    detalles.append("Observación: \(linea.observacion)")
    return detalles.joined(separator: "\n")
}

public func consultarAccesibilidad(nombre: String) -> String {
    guard let estacion = buscarEstacionExacta(nombre: nombre) else {
        return "No se encontró la estación indicada."
    }

    if estacion.tieneAscensor {
        if estacion.estado == .operativa {
            return "La estación cuenta con ascensor disponible."
        }

        return "La estación contempla ascensores como infraestructura prevista, pero todavía no se encuentra operativa."
    }

    if let accesoAlternativo = estacion.accesoAlternativo {
        return "La estación no cuenta con ascensor. Acceso alternativo: \(accesoAlternativo)."
    }

    return "La estación no registra ascensor ni un acceso alternativo."
}

public func consultarConexiones(nombre: String) -> [Conexion] {
    buscarEstacionExacta(nombre: nombre)?.conexiones ?? []
}

public func descripcionEstacion(_ estacion: Estacion) -> String {
    let lineas = estacion.lineas.sorted().map { numero -> String in
        let estado = estacion.estadosPorLinea[numero] ?? estacion.estado
        return "Línea \(numero) (\(estado.rawValue))"
    }

    var detalles: [String] = []
    detalles.append("Estación: \(estacion.nombre)")

    if let codigo = estacion.codigo {
        detalles.append("Código: \(codigo)")
    }

    detalles.append("Líneas y estados: \(lineas.joined(separator: ", "))")
    detalles.append("Ubicación: \(estacion.ubicacion)")
    detalles.append("Distrito: \(estacion.distrito)")
    detalles.append("Estado: \(estacion.estado.rawValue)")
    detalles.append("Accesibilidad: \(consultarAccesibilidad(nombre: estacion.nombre))")

    if estacion.conexiones.isEmpty {
        detalles.append("Conexiones: No registra conexiones directas.")
    } else {
        detalles.append("Conexiones:")

        for conexion in estacion.conexiones {
            detalles.append(
                "- \(conexion.sistema), estación \(conexion.estacion) "
                    + "(\(conexion.estado.rawValue)): \(conexion.detalle)."
            )
        }
    }

    return detalles.joined(separator: "\n")
}
