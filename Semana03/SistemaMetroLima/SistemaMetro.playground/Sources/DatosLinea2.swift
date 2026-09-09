// Desarrollado por: Jason Gomez

import Foundation

private let conexionCentralMetropolitano = Conexion(
    sistema: "Metropolitano",
    estacion: "Central",
    estado: .planificada,
    detalle: "Un túnel peatonal conectará ambas estaciones centrales"
)

private func estacionLinea2(
    codigo: String,
    nombre: String,
    ubicacion: String,
    distrito: String,
    estado: EstadoServicio = .enConstruccion,
    conexiones: [Conexion] = []
) -> Estacion {
    Estacion(
        codigo: codigo,
        nombre: nombre,
        lineas: [2],
        ubicacion: ubicacion,
        distrito: distrito,
        estado: estado,
        tieneAscensor: true,
        conexiones: conexiones
    )
}

public let estacionesRegistradasLinea2: [Estacion] = [
    estacionLinea2(
        codigo: "E-01",
        nombre: "Puerto del Callao",
        ubicacion: "Avenida Guardia Chalaca con plaza Garibaldi",
        distrito: "Callao"
    ),
    estacionLinea2(
        codigo: "E-02",
        nombre: "Buenos Aires",
        ubicacion: "Avenida Óscar R. Benavides con avenida Guardia Chalaca",
        distrito: "Callao"
    ),
    estacionLinea2(
        codigo: "E-03",
        nombre: "Juan Pablo II",
        ubicacion: "Avenida Óscar R. Benavides con avenida Juan Pablo II",
        distrito: "Bellavista"
    ),
    estacionLinea2(
        codigo: "E-04",
        nombre: "Insurgentes",
        ubicacion: "Avenida Óscar R. Benavides con avenida Insurgentes",
        distrito: "Callao"
    ),
    estacionLinea2(
        codigo: "E-05",
        nombre: "Carmen de la Legua",
        ubicacion: "Avenida Óscar R. Benavides con avenida Elmer Faucett",
        distrito: "Carmen de la Legua Reynoso"
    ),
    estacionLinea2(
        codigo: "E-06",
        nombre: "Óscar R. Benavides",
        ubicacion: "Avenida Óscar R. Benavides frente a la urbanización San Joaquín",
        distrito: "Bellavista"
    ),
    estacionLinea2(
        codigo: "E-07",
        nombre: "San Marcos",
        ubicacion: "Avenida Germán Amézaga con avenida Universitaria",
        distrito: "Lima"
    ),
    estacionLinea2(
        codigo: "E-08",
        nombre: "Elio",
        ubicacion: "Avenida Venezuela con avenida Aurelio García y García",
        distrito: "Lima"
    ),
    estacionLinea2(
        codigo: "E-09",
        nombre: "La Alborada",
        ubicacion: "Avenida Venezuela entre La Alborada y Roberto Thorndike",
        distrito: "Lima"
    ),
    estacionLinea2(
        codigo: "E-10",
        nombre: "Tingo María",
        ubicacion: "Avenida Venezuela con las calles Yauli y Juan del Mar y Bernedo",
        distrito: "Lima"
    ),
    estacionLinea2(
        codigo: "E-11",
        nombre: "Parque Murillo",
        ubicacion: "Avenida Arica frente al parque Murillo",
        distrito: "Breña"
    ),
    estacionLinea2(
        codigo: "E-12",
        nombre: "Plaza Bolognesi",
        ubicacion: "Avenida Arica entre las calles Varela e Iquique",
        distrito: "Breña"
    ),
    estacionLinea2(
        codigo: "E-13",
        nombre: "Estación Central",
        ubicacion: "Paseo Colón con avenida Garcilaso de la Vega y jirón Washington",
        distrito: "Lima",
        conexiones: [conexionCentralMetropolitano]
    ),
    estacionLinea2(
        codigo: "E-14",
        nombre: "Manco Cápac",
        ubicacion: "Avenida 28 de Julio con avenida Manco Cápac",
        distrito: "La Victoria"
    ),
    estacionLinea2(
        codigo: "E-15",
        nombre: "Cangallo",
        ubicacion: "Avenida 28 de Julio con los jirones Cangallo y Abtao",
        distrito: "La Victoria"
    ),
    estacion28DeJulio,
    estacionLinea2(
        codigo: "E-17",
        nombre: "Nicolás Ayllón",
        ubicacion: "Avenida Nicolás Ayllón con los jirones Inca Garcilaso y Sergio Calera",
        distrito: "La Victoria"
    ),
    estacionLinea2(
        codigo: "E-18",
        nombre: "Circunvalación",
        ubicacion: "Avenida Nicolás Ayllón con avenida Circunvalación",
        distrito: "La Victoria"
    ),
    estacionLinea2(
        codigo: "E-19",
        nombre: "San Juan de Dios",
        ubicacion: "Avenida Nicolás Ayllón, altura del hospital San Juan de Dios",
        distrito: "El Agustino"
    ),
    estacionLinea2(
        codigo: "E-20",
        nombre: "Evitamiento",
        ubicacion: "Avenida Nicolás Ayllón con la vía de Evitamiento",
        distrito: "Santa Anita",
        estado: .operativa
    ),
    estacionLinea2(
        codigo: "E-21",
        nombre: "Óvalo Santa Anita",
        ubicacion: "Carretera Central con avenida La Molina",
        distrito: "Santa Anita",
        estado: .operativa
    ),
    estacionLinea2(
        codigo: "E-22",
        nombre: "Colectora Industrial",
        ubicacion: "Carretera Central con avenida Colectora Industrial",
        distrito: "Santa Anita",
        estado: .operativa
    ),
    estacionLinea2(
        codigo: "E-23",
        nombre: "Hermilio Valdizán",
        ubicacion: "Carretera Central, altura del hospital Hermilio Valdizán",
        distrito: "Santa Anita",
        estado: .operativa
    ),
    estacionLinea2(
        codigo: "E-24",
        nombre: "Mercado Santa Anita",
        ubicacion: "Carretera Central con avenida Separadora Industrial",
        distrito: "Ate",
        estado: .operativa
    ),
    estacionLinea2(
        codigo: "E-25",
        nombre: "Vista Alegre",
        ubicacion: "Carretera Central con avenida Vista Alegre",
        distrito: "Ate"
    ),
    estacionLinea2(
        codigo: "E-26",
        nombre: "Prolongación Javier Prado",
        ubicacion: "Carretera Central con avenida Prolongación Javier Prado",
        distrito: "Ate"
    ),
    estacionLinea2(
        codigo: "E-27",
        nombre: "Municipalidad de Ate",
        ubicacion: "Carretera Central frente a la plaza de Armas de Ate",
        distrito: "Ate"
    )
]

public let recorridoLinea2 = estacionesRegistradasLinea2.map { $0.nombre }
