// Desarrollado por: Jason Gomez

import Foundation

private func estacionLinea3(
    numero: Int,
    nombre: String,
    ubicacion: String,
    distrito: String,
    conexiones: [Conexion] = []
) -> Estacion {
    Estacion(
        codigo: String(format: "L3-%02d", numero),
        nombre: nombre,
        lineas: [3],
        ubicacion: ubicacion,
        distrito: distrito,
        estado: .planificada,
        tieneAscensor: true,
        accesoAlternativo: "Infraestructura de accesibilidad prevista en el proyecto",
        conexiones: conexiones
    )
}

public let estacionesRegistradasLinea3: [Estacion] = [
    estacionLinea3(numero: 1, nombre: "El Álamo", ubicacion: "Sector El Álamo", distrito: "Comas"),
    estacionLinea3(numero: 2, nombre: "Huandoy", ubicacion: "Avenida Universitaria con avenida Huandoy", distrito: "Los Olivos"),
    estacionLinea3(numero: 3, nombre: "2 de Octubre", ubicacion: "Avenida Universitaria, sector 2 de Octubre", distrito: "Los Olivos"),
    estacionLinea3(numero: 4, nombre: "Villa Sol", ubicacion: "Avenida Universitaria, urbanización Villa Sol", distrito: "Los Olivos"),
    estacionLinea3(numero: 5, nombre: "Naranjal", ubicacion: "Avenida Universitaria con avenida Naranjal", distrito: "Los Olivos"),
    estacionLinea3(numero: 6, nombre: "Carlos Izaguirre", ubicacion: "Avenida Universitaria con avenida Carlos Izaguirre", distrito: "Los Olivos"),
    estacionLinea3(numero: 7, nombre: "Tomás Valle", ubicacion: "Avenida Universitaria con avenida Tomás Valle", distrito: "San Martín de Porres"),
    estacionLinea3(numero: 8, nombre: "Bartolomé de las Casas", ubicacion: "Avenida Universitaria con jirón Bartolomé de las Casas", distrito: "San Martín de Porres"),
    estacionLinea3(numero: 9, nombre: "José Granda", ubicacion: "Avenida Universitaria con avenida José Granda", distrito: "San Martín de Porres"),
    estacionLinea3(numero: 10, nombre: "Caquetá", ubicacion: "Avenida Alfonso Ugarte con avenida Caquetá", distrito: "Lima"),
    estacionLinea3(numero: 11, nombre: "Tacna", ubicacion: "Avenida Tacna, Centro Histórico", distrito: "Lima"),
    estacionLinea3(numero: 12, nombre: "Garcilaso de la Vega", ubicacion: "Avenida Garcilaso de la Vega", distrito: "Lima"),
    estacionLinea3(
        numero: 13,
        nombre: "Estación Central",
        ubicacion: "Paseo Colón con avenida Garcilaso de la Vega",
        distrito: "Lima",
        conexiones: [
            Conexion(
                sistema: "Línea 2 y Metropolitano",
                estacion: "Estación Central",
                estado: .planificada,
                detalle: "Intercambio proyectado con la Línea 2 y el Metropolitano"
            )
        ]
    ),
    estacionLinea3(numero: 14, nombre: "Parque de la Reserva", ubicacion: "Avenida Arequipa, parque de la Reserva", distrito: "Lima"),
    estacionLinea3(numero: 15, nombre: "Museo de Historia Natural", ubicacion: "Avenida Arequipa, Museo de Historia Natural", distrito: "Lima"),
    estacionLinea3(numero: 16, nombre: "César Canevaro", ubicacion: "Avenida Arequipa con avenida César Canevaro", distrito: "Lince"),
    estacionLinea3(
        numero: 17,
        nombre: "Rivera Navarrete",
        ubicacion: "Avenida Arequipa con avenida Rivera Navarrete",
        distrito: "San Isidro",
        conexiones: [
            Conexion(
                sistema: "Línea 4",
                estacion: "Rivera Navarrete",
                estado: .planificada,
                detalle: "Intercambio proyectado entre las líneas 3 y 4"
            )
        ]
    ),
    estacionLinea3(numero: 18, nombre: "Andrés Aramburú", ubicacion: "Avenida Arequipa con avenida Andrés Aramburú", distrito: "San Isidro"),
    estacionLinea3(numero: 19, nombre: "Huaca Pucllana", ubicacion: "Avenida Arequipa, sector Huaca Pucllana", distrito: "Miraflores"),
    estacionLinea3(numero: 20, nombre: "Parque Central de Miraflores", ubicacion: "Avenida Arequipa, parque Central de Miraflores", distrito: "Miraflores"),
    estacionLinea3(numero: 21, nombre: "Parque Reducto", ubicacion: "Avenida Benavides, parque Reducto", distrito: "Miraflores"),
    estacionLinea3(numero: 22, nombre: "Panamá", ubicacion: "Avenida Benavides con avenida República de Panamá", distrito: "Miraflores"),
    estacionLinea3(numero: 23, nombre: "Juana Alarco", ubicacion: "Avenida Benavides, sector Juana Alarco", distrito: "Santiago de Surco"),
    estacionLinea3(
        numero: 24,
        nombre: "Cabitos",
        ubicacion: "Óvalo Los Cabitos",
        distrito: "Santiago de Surco",
        conexiones: [
            Conexion(
                sistema: "Línea 1",
                estacion: "Cabitos",
                estado: .planificada,
                detalle: "Intercambio proyectado entre las líneas 3 y 1"
            )
        ]
    ),
    estacionLinea3(numero: 25, nombre: "Alejandro Velasco", ubicacion: "Avenida Los Héroes con avenida Alejandro Velasco", distrito: "San Juan de Miraflores"),
    estacionLinea3(numero: 26, nombre: "Las Gardenias", ubicacion: "Avenida Los Héroes, sector Las Gardenias", distrito: "San Juan de Miraflores"),
    estacionLinea3(numero: 27, nombre: "Los Héroes", ubicacion: "Avenida Los Héroes", distrito: "San Juan de Miraflores"),
    estacionLinea3(numero: 28, nombre: "Pedro Miotta", ubicacion: "Avenida Pedro Miotta", distrito: "San Juan de Miraflores")
]

public let recorridoLinea3 = estacionesRegistradasLinea3.map { $0.nombre }
