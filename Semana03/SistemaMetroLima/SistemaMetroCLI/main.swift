// Desarrollado por: Jason Gomez

import Foundation
import MetroCore

private let separador = String(repeating: "=", count: 70)

private func leerTextoNoVacio(_ mensaje: String) -> String? {
    while true {
        print(mensaje, terminator: " ")

        guard let entrada = readLine() else {
            return nil
        }

        let texto = entrada.trimmingCharacters(in: .whitespacesAndNewlines)

        if !texto.isEmpty {
            return texto
        }

        print("La entrada no puede estar vacía. Intente nuevamente.")
    }
}

private func mostrarMenu() {
    print("\n\(separador)")
    print(tituloSistema.uppercased())
    print(separador)
    print("1. Buscar estación")
    print("2. Ver información y estaciones por línea")
    print("3. Consultar accesibilidad")
    print("4. Consultar conexiones")
    print("5. Calcular ruta entre estaciones")
    print("6. Buscar lugar de interés")
    print("7. Salir")
    print(separador)
    print("Seleccione una opción:", terminator: " ")
}

private func mostrarEstaciones(_ estaciones: [Estacion], linea: Int) {
    print("\nEstaciones de la Línea \(linea):")

    for (indice, estacion) in estaciones.enumerated() {
        let codigo = estacion.codigo.map { " [\($0)]" } ?? ""
        print("\(indice + 1). \(estacion.nombre)\(codigo) - \(estacion.estado.rawValue)")
    }
}

private func ejecutarBusqueda() {
    guard let nombre = leerTextoNoVacio("Ingrese el nombre de la estación:") else {
        return
    }

    let resultados = buscarEstacion(nombre: nombre)

    if resultados.isEmpty {
        print("No se encontraron estaciones para la búsqueda ingresada.")
    } else if resultados.count == 1, let estacion = resultados.first {
        print("\n\(descripcionEstacion(estacion))")
    } else {
        print("\nSe encontraron varias coincidencias:")

        for estacion in resultados {
            print("- \(estacion.nombre)")
        }
    }
}

private func ejecutarListadoPorLinea() {
    print("\nLíneas disponibles: 1, 2, 3, 4, 5 y 6")

    guard let entrada = leerTextoNoVacio("Ingrese el número de línea:") else {
        return
    }

    guard let linea = Int(entrada), let informacion = consultarLinea(linea) else {
        print("La línea ingresada no es válida. Solo puede elegir del 1 al 6.")
        return
    }

    print("\n\(descripcionLinea(informacion))")

    let estaciones = estacionesDeLinea(linea)
    if estaciones.isEmpty {
        print("No se listan estaciones porque todavía no existe un catálogo oficial definitivo.")
        return
    }

    mostrarEstaciones(estaciones, linea: linea)
}

private func ejecutarConsultaAccesibilidad() {
    guard let nombre = leerTextoNoVacio("Ingrese el nombre exacto de la estación:") else {
        return
    }

    print(consultarAccesibilidad(nombre: nombre))
}

private func ejecutarConsultaConexiones() {
    guard let nombre = leerTextoNoVacio("Ingrese el nombre exacto de la estación:") else {
        return
    }

    guard let estacion = buscarEstacionExacta(nombre: nombre) else {
        print("No se encontró la estación indicada.")
        return
    }

    let conexiones = consultarConexiones(nombre: estacion.nombre)

    if conexiones.isEmpty {
        print("La estación \(estacion.nombre) no registra conexiones directas con otro sistema.")
        return
    }

    print("\nConexiones de \(estacion.nombre):")

    for conexion in conexiones {
        print("- \(conexion.sistema), estación \(conexion.estacion)")
        print("  Estado: \(conexion.estado.rawValue)")
        print("  Detalle: \(conexion.detalle)")
    }
}

private func ejecutarCalculoRuta() {
    guard
        let origen = leerTextoNoVacio("Ingrese la estación de origen:"),
        let destino = leerTextoNoVacio("Ingrese la estación de destino:")
    else {
        return
    }

    guard let ruta = calcularRuta(desde: origen, hasta: destino) else {
        print("No fue posible calcular la ruta. Verifique los nombres ingresados.")
        return
    }

    print("\n\(descripcionRuta(ruta))")
}

private func ejecutarRecomendacion() {
    print("\nLugares disponibles:")

    for lugar in lugaresInteresRegistrados {
        print("- \(lugar.nombre)")
    }

    guard
        let origen = leerTextoNoVacio("Ingrese la estación de origen:"),
        let consulta = leerTextoNoVacio("Ingrese el lugar de interés:")
    else {
        return
    }

    let coincidencias = buscarLugarInteres(nombre: consulta)

    guard coincidencias.count == 1, let lugar = coincidencias.first else {
        print("No se encontró un único lugar de interés con ese nombre.")
        return
    }

    guard let ruta = recomendarLugar(desde: origen, hacia: lugar.nombre) else {
        print("No fue posible crear la recomendación. Verifique la estación de origen.")
        return
    }

    print("\n\(descripcionRuta(ruta))")
}

print(tituloSistema)
print("Consulte las seis líneas, estaciones, conexiones, accesibilidad y rutas.")

var aplicacionActiva = true

while aplicacionActiva {
    mostrarMenu()

    guard let opcion = readLine() else {
        print("\nEntrada finalizada. Cerrando el sistema.")
        break
    }

    switch opcion.trimmingCharacters(in: .whitespacesAndNewlines) {
    case "1":
        ejecutarBusqueda()
    case "2":
        ejecutarListadoPorLinea()
    case "3":
        ejecutarConsultaAccesibilidad()
    case "4":
        ejecutarConsultaConexiones()
    case "5":
        ejecutarCalculoRuta()
    case "6":
        ejecutarRecomendacion()
    case "7":
        aplicacionActiva = false
        print("Gracias por utilizar el sistema de consulta del Metro de Lima.")
    default:
        print("Opción no válida. Elija un número del 1 al 7.")
    }
}
