// Desarrollado por: Jason Gomez

import Foundation

private let accesoConSalvaescaleras = "Salvaescaleras y asistencia del personal"

public let estacion28DeJulio = Estacion(
    codigo: "E-16",
    nombre: "28 de Julio",
    lineas: [1, 2],
    ubicacion: "Cruce de la avenida 28 de Julio con la avenida Aviación",
    distrito: "La Victoria",
    estado: .enConstruccion,
    tieneAscensor: true,
    conexiones: [
        Conexion(
            sistema: "Línea 1 y Línea 2",
            estacion: "28 de Julio",
            estado: .planificada,
            detalle: "Intercambio planificado entre las líneas 1 y 2"
        )
    ]
)

public let estacionesRegistradasLinea1: [Estacion] = [
    Estacion(
        nombre: "Villa El Salvador",
        lineas: [1],
        ubicacion: "Avenida Separadora Industrial",
        distrito: "Villa El Salvador",
        estado: .operativa,
        tieneAscensor: true
    ),
    Estacion(
        nombre: "Parque Industrial",
        lineas: [1],
        ubicacion: "Avenida Separadora Industrial con avenida El Sol",
        distrito: "Villa El Salvador",
        estado: .operativa,
        tieneAscensor: true
    ),
    Estacion(
        nombre: "Pumacahua",
        lineas: [1],
        ubicacion: "Avenida Pachacútec con avenida Mateo Pumacahua",
        distrito: "Villa María del Triunfo",
        estado: .operativa,
        tieneAscensor: false,
        accesoAlternativo: accesoConSalvaescaleras
    ),
    Estacion(
        nombre: "Villa María",
        lineas: [1],
        ubicacion: "Avenida Pachacútec con avenida Villa María",
        distrito: "Villa María del Triunfo",
        estado: .operativa,
        tieneAscensor: false,
        accesoAlternativo: accesoConSalvaescaleras
    ),
    Estacion(
        nombre: "María Auxiliadora",
        lineas: [1],
        ubicacion: "Avenida Pachacútec con avenida María Auxiliadora",
        distrito: "Villa María del Triunfo",
        estado: .operativa,
        tieneAscensor: false,
        accesoAlternativo: accesoConSalvaescaleras
    ),
    Estacion(
        nombre: "San Juan",
        lineas: [1],
        ubicacion: "Avenida Los Héroes con avenida San Juan",
        distrito: "San Juan de Miraflores",
        estado: .operativa,
        tieneAscensor: true
    ),
    Estacion(
        nombre: "Atocongo",
        lineas: [1],
        ubicacion: "Avenida Los Héroes con avenida Atocongo",
        distrito: "San Juan de Miraflores",
        estado: .operativa,
        tieneAscensor: true
    ),
    Estacion(
        nombre: "Jorge Chávez",
        lineas: [1],
        ubicacion: "Avenida Tomás Marsano con avenida Jorge Chávez",
        distrito: "Santiago de Surco",
        estado: .operativa,
        tieneAscensor: true
    ),
    Estacion(
        nombre: "Ayacucho",
        lineas: [1],
        ubicacion: "Avenida Tomás Marsano con avenida Ayacucho",
        distrito: "Santiago de Surco",
        estado: .operativa,
        tieneAscensor: true
    ),
    Estacion(
        nombre: "Cabitos",
        lineas: [1],
        ubicacion: "Avenida Aviación con el óvalo Los Cabitos",
        distrito: "Santiago de Surco",
        estado: .operativa,
        tieneAscensor: true
    ),
    Estacion(
        nombre: "Angamos",
        lineas: [1],
        ubicacion: "Avenida Aviación con avenida Angamos Este",
        distrito: "San Borja",
        estado: .operativa,
        tieneAscensor: true
    ),
    Estacion(
        nombre: "San Borja Sur",
        lineas: [1],
        ubicacion: "Avenida Aviación con avenida San Borja Sur",
        distrito: "San Borja",
        estado: .operativa,
        tieneAscensor: false,
        accesoAlternativo: accesoConSalvaescaleras
    ),
    Estacion(
        nombre: "La Cultura",
        lineas: [1],
        ubicacion: "Avenida Aviación con avenida Javier Prado Este",
        distrito: "San Borja",
        estado: .operativa,
        tieneAscensor: true
    ),
    Estacion(
        nombre: "Arriola",
        lineas: [1],
        ubicacion: "Avenida Aviación con avenida Nicolás Arriola",
        distrito: "La Victoria",
        estado: .operativa,
        tieneAscensor: true
    ),
    Estacion(
        nombre: "Gamarra",
        lineas: [1],
        ubicacion: "Avenida Aviación con jirón Hipólito Unanue",
        distrito: "La Victoria",
        estado: .operativa,
        tieneAscensor: true
    ),
    estacion28DeJulio,
    Estacion(
        nombre: "Miguel Grau",
        lineas: [1],
        ubicacion: "Avenida Grau con avenida Nicolás Ayllón",
        distrito: "Lima",
        estado: .operativa,
        tieneAscensor: true
    ),
    Estacion(
        nombre: "El Ángel",
        lineas: [1],
        ubicacion: "Avenida Locumba, cerca del cementerio El Ángel",
        distrito: "Lima",
        estado: .operativa,
        tieneAscensor: true
    ),
    Estacion(
        nombre: "Presbítero Maestro",
        lineas: [1],
        ubicacion: "Avenida Locumba, cerca del cementerio Presbítero Maestro",
        distrito: "Lima",
        estado: .operativa,
        tieneAscensor: true
    ),
    Estacion(
        nombre: "Caja de Agua",
        lineas: [1],
        ubicacion: "Avenida Próceres de la Independencia",
        distrito: "San Juan de Lurigancho",
        estado: .operativa,
        tieneAscensor: true
    ),
    Estacion(
        nombre: "Pirámide del Sol",
        lineas: [1],
        ubicacion: "Avenida Próceres de la Independencia con avenida Pirámide del Sol",
        distrito: "San Juan de Lurigancho",
        estado: .operativa,
        tieneAscensor: true
    ),
    Estacion(
        nombre: "Los Jardines",
        lineas: [1],
        ubicacion: "Avenida Próceres de la Independencia con avenida Los Jardines",
        distrito: "San Juan de Lurigancho",
        estado: .operativa,
        tieneAscensor: true
    ),
    Estacion(
        nombre: "Los Postes",
        lineas: [1],
        ubicacion: "Avenida Próceres de la Independencia con avenida Los Postes",
        distrito: "San Juan de Lurigancho",
        estado: .operativa,
        tieneAscensor: true
    ),
    Estacion(
        nombre: "San Carlos",
        lineas: [1],
        ubicacion: "Avenida Próceres de la Independencia con avenida El Sol",
        distrito: "San Juan de Lurigancho",
        estado: .operativa,
        tieneAscensor: true
    ),
    Estacion(
        nombre: "San Martín",
        lineas: [1],
        ubicacion: "Avenida Fernando Wiesse con avenida Canto Rey",
        distrito: "San Juan de Lurigancho",
        estado: .operativa,
        tieneAscensor: true
    ),
    Estacion(
        nombre: "Santa Rosa",
        lineas: [1],
        ubicacion: "Avenida Fernando Wiesse con avenida Santa Rosa",
        distrito: "San Juan de Lurigancho",
        estado: .operativa,
        tieneAscensor: true
    ),
    Estacion(
        nombre: "Bayóvar",
        lineas: [1],
        ubicacion: "Avenida Fernando Wiesse, altura de Bayóvar",
        distrito: "San Juan de Lurigancho",
        estado: .operativa,
        tieneAscensor: true
    )
]

public let recorridoLinea1 = estacionesRegistradasLinea1.map { $0.nombre }
