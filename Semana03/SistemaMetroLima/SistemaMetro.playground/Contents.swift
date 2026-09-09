// Desarrollado por: Jason Gomez

import Foundation

print(tituloSistema)
print("Pruebas de estaciones, conexiones, accesibilidad y rutas\n")

var pruebasCorrectas = 0
var pruebasFallidas = 0

func verificar(_ condicion: Bool, descripcion: String) {
    if condicion {
        pruebasCorrectas += 1
        print("[CORRECTO] \(descripcion)")
    } else {
        pruebasFallidas += 1
        print("[FALLÓ] \(descripcion)")
    }
}

func contarEstaciones(
    con estado: EstadoServicio,
    en estaciones: [Estacion]
) -> Int {
    var cantidad = 0

    for estacion in estaciones {
        if estacion.estado == estado {
            cantidad += 1
        }
    }

    return cantidad
}

verificar(
    catalogoEstaciones.count == 103,
    descripcion: "El catálogo ampliado contiene 103 estaciones únicas"
)
verificar(
    estacionesDeLinea(1).count == 27,
    descripcion: "La Línea 1 contiene 26 estaciones operativas y una futura"
)
verificar(
    contarEstaciones(con: .operativa, en: estacionesDeLinea(1)) == 26,
    descripcion: "La Línea 1 conserva 26 estaciones operativas"
)
verificar(
    estacionesDeLinea(2).count == 27,
    descripcion: "La Línea 2 contiene sus 27 estaciones"
)
verificar(
    contarEstaciones(con: .operativa, en: estacionesDeLinea(2)) == 5,
    descripcion: "La Línea 2 identifica sus 5 estaciones operativas"
)
verificar(
    estacionesDeLinea(3).count == 28,
    descripcion: "La Línea 3 contiene 28 estaciones de referencia"
)
verificar(
    contarEstaciones(con: .planificada, en: estacionesDeLinea(3)) == 28,
    descripcion: "Las estaciones de Línea 3 se identifican como planificadas"
)
verificar(
    estacionesDeLinea(4).count == 28,
    descripcion: "La Línea 4 reúne el ramal y el proyecto principal"
)
verificar(
    contarEstaciones(con: .enConstruccion, en: estacionesDeLinea(4)) == 8,
    descripcion: "El ramal de Línea 4 contiene 8 estaciones en construcción"
)
verificar(
    contarEstaciones(con: .planificada, en: estacionesDeLinea(4)) == 20,
    descripcion: "El proyecto principal de Línea 4 contiene 20 estaciones planificadas"
)
verificar(
    estacionesDeLinea(5).isEmpty && estacionesDeLinea(6).isEmpty,
    descripcion: "Las Líneas 5 y 6 no inventan catálogos de estaciones"
)
verificar(
    lineasMetro.count == 6,
    descripcion: "El sistema registra información de las seis líneas"
)
verificar(
    consultarLinea(5)?.tieneCatalogoEstaciones == false
        && consultarLinea(6)?.tieneCatalogoEstaciones == false,
    descripcion: "Las Líneas 5 y 6 informan que no tienen estaciones definitivas"
)
verificar(
    buscarEstacion(nombre: "miguel grau").first?.nombre == "Miguel Grau",
    descripcion: "La búsqueda ignora las mayúsculas"
)
verificar(
    buscarEstacion(nombre: "maria auxiliadora").first?.nombre == "María Auxiliadora",
    descripcion: "La búsqueda ignora las tildes"
)
verificar(
    buscarEstacion(nombre: "santa anita").count == 2,
    descripcion: "La búsqueda parcial encuentra varias coincidencias"
)
verificar(
    buscarEstacion(nombre: "").isEmpty,
    descripcion: "La búsqueda vacía no devuelve estaciones"
)
verificar(
    consultarAccesibilidad(nombre: "Pumacahua").contains("Salvaescaleras"),
    descripcion: "Pumacahua muestra su acceso alternativo"
)
verificar(
    consultarAccesibilidad(nombre: "Puerto del Callao").contains("todavía no se encuentra operativa"),
    descripcion: "Una estación en construcción no presenta su ascensor como disponible"
)
verificar(
    consultarConexiones(nombre: "Miguel Grau").isEmpty,
    descripcion: "Miguel Grau no muestra una conexión inexistente"
)
verificar(
    consultarConexiones(nombre: "28 de Julio").first?.estado == .planificada,
    descripcion: "28 de Julio muestra el intercambio planificado"
)
verificar(
    consultarConexiones(nombre: "Estación Central").first?.sistema == "Metropolitano",
    descripcion: "Estación Central muestra su futura conexión con el Metropolitano"
)
verificar(
    buscarEstacionExacta(nombre: "Cabitos")?.lineas == [1, 3],
    descripcion: "Cabitos combina la Línea 1 operativa y la Línea 3 planificada"
)
verificar(
    buscarEstacionExacta(nombre: "La Cultura")?.lineas == [1, 4],
    descripcion: "La Cultura registra el intercambio proyectado con Línea 4"
)
verificar(
    buscarEstacionExacta(nombre: "Carmen de la Legua")?.lineas == [2, 4],
    descripcion: "Carmen de la Legua combina las Líneas 2 y 4"
)

let rutaLinea1 = calcularRuta(desde: "Gamarra", hasta: "Miguel Grau")
verificar(
    rutaLinea1?.estaciones == ["Gamarra", "Miguel Grau"],
    descripcion: "La ruta operativa de Línea 1 omite la estación futura"
)

let rutaLinea2 = calcularRuta(desde: "Evitamiento", hasta: "Mercado Santa Anita")
verificar(
    rutaLinea2?.estaciones.count == 5 && rutaLinea2?.advertencias.isEmpty == true,
    descripcion: "La ruta operativa de Línea 2 recorre cinco estaciones"
)

let rutaConTransbordo = calcularRuta(desde: "Gamarra", hasta: "Mercado Santa Anita")
verificar(
    rutaConTransbordo?.transbordos.count == 1,
    descripcion: "La ruta entre líneas indica un transbordo"
)
verificar(
    rutaConTransbordo?.advertencias.count == 2,
    descripcion: "La ruta entre líneas advierte los tramos no operativos"
)
verificar(
    calcularRuta(desde: "Estación inexistente", hasta: "Gamarra") == nil,
    descripcion: "Una estación inexistente no genera una ruta"
)

let rutaLinea3 = calcularRuta(desde: "El Álamo", hasta: "Naranjal")
verificar(
    rutaLinea3?.estaciones.count == 5 && rutaLinea3?.advertencias.isEmpty == false,
    descripcion: "La Línea 3 calcula la ruta y advierte que es planificada"
)

let rutaLineas3Y4 = calcularRuta(desde: "Museo de Historia Natural", hasta: "Aeropuerto")
verificar(
    rutaLineas3Y4?.transbordos.count == 2,
    descripcion: "La red ampliada calcula una ruta con dos transbordos"
)
verificar(
    rutaLineas3Y4?.estaciones.last == "Aeropuerto",
    descripcion: "La ruta ampliada llega a la estación Aeropuerto"
)
verificar(
    lugaresInteresRegistrados.count == 5,
    descripcion: "El sistema contiene cinco lugares de interés"
)

let recomendacionMuseo = recomendarLugar(
    desde: "La Cultura",
    hacia: "Museo de la Nación"
)
verificar(
    recomendacionMuseo?.estaciones == ["La Cultura"],
    descripcion: "El Museo de la Nación recomienda La Cultura"
)

let recomendacionEstadio = recomendarLugar(
    desde: "Gamarra",
    hacia: "Estadio Nacional"
)
verificar(
    recomendacionEstadio?.estaciones.last == "Estación Central",
    descripcion: "El Estadio Nacional dirige primero a Estación Central"
)
verificar(
    recomendacionEstadio?.advertencias.contains(where: { $0.contains("Metropolitano") }) == true,
    descripcion: "El Estadio Nacional advierte sobre la conexión planificada"
)

print("\nResumen de pruebas")
print("Pruebas correctas: \(pruebasCorrectas)")
print("Pruebas fallidas: \(pruebasFallidas)")

precondition(pruebasFallidas == 0, "Existen pruebas que deben corregirse")
