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

public let catalogoEstaciones: [String: Estacion] = {
    var catalogo: [String: Estacion] = [:]

    for estacion in estacionesRegistradasLinea1 + estacionesRegistradasLinea2 {
        catalogo[normalizarTexto(estacion.nombre)] = estacion
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
    default:
        return []
    }
}

public func consultarAccesibilidad(nombre: String) -> String {
    guard let estacion = buscarEstacionExacta(nombre: nombre) else {
        return "No se encontró la estación indicada."
    }

    if estacion.tieneAscensor {
        if estacion.estado == .operativa {
            return "La estación cuenta con ascensor disponible."
        }

        return "La estación contempla ascensores, pero todavía no se encuentra operativa."
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
    var lineas: [String] = []

    for linea in estacion.lineas {
        lineas.append("Línea \(linea)")
    }

    var detalles: [String] = []
    detalles.append("Estación: \(estacion.nombre)")

    if let codigo = estacion.codigo {
        detalles.append("Código: \(codigo)")
    }

    detalles.append("Línea: \(lineas.joined(separator: ", "))")
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
