// Desarrollado por: Jason Gomez

import Foundation

private func estacionLinea4(
    numero: Int,
    nombre: String,
    ubicacion: String,
    distrito: String,
    estado: EstadoServicio,
    conexiones: [Conexion] = []
) -> Estacion {
    Estacion(
        codigo: String(format: "L4-%02d", numero),
        nombre: nombre,
        lineas: [4],
        ubicacion: ubicacion,
        distrito: distrito,
        estado: estado,
        tieneAscensor: true,
        accesoAlternativo: "Infraestructura de accesibilidad prevista en el proyecto",
        conexiones: conexiones
    )
}

public let estacionesRamalLinea4: [Estacion] = [
    estacionLinea4(numero: 1, nombre: "Gambetta", ubicacion: "Avenida Elmer Faucett con avenida Néstor Gambetta", distrito: "Callao", estado: .enConstruccion),
    estacionLinea4(numero: 2, nombre: "Canta Callao", ubicacion: "Avenida Elmer Faucett con avenida Canta Callao", distrito: "Callao", estado: .enConstruccion),
    estacionLinea4(numero: 3, nombre: "Bocanegra", ubicacion: "Avenida Elmer Faucett con avenida Bocanegra", distrito: "Callao", estado: .enConstruccion),
    estacionLinea4(numero: 4, nombre: "Aeropuerto", ubicacion: "Aeropuerto Internacional Jorge Chávez", distrito: "Callao", estado: .enConstruccion),
    estacionLinea4(numero: 5, nombre: "El Olivar", ubicacion: "Avenida Elmer Faucett, sector El Olivar", distrito: "Callao", estado: .enConstruccion),
    estacionLinea4(numero: 6, nombre: "Quilca", ubicacion: "Avenida Elmer Faucett con avenida Quilca", distrito: "Callao", estado: .enConstruccion),
    estacionLinea4(numero: 7, nombre: "Morales Duárez", ubicacion: "Avenida Elmer Faucett con avenida Morales Duárez", distrito: "Callao", estado: .enConstruccion),
    estacionLinea4(
        numero: 8,
        nombre: "Carmen de la Legua",
        ubicacion: "Avenida Elmer Faucett con avenida Óscar R. Benavides",
        distrito: "Carmen de la Legua Reynoso",
        estado: .enConstruccion,
        conexiones: [
            Conexion(
                sistema: "Línea 2",
                estacion: "Carmen de la Legua",
                estado: .planificada,
                detalle: "Intercambio proyectado entre las líneas 4 y 2"
            )
        ]
    )
]

public let estacionesProyectoPrincipalLinea4: [Estacion] = [
    estacionLinea4(numero: 9, nombre: "Venezuela", ubicacion: "Avenida Elmer Faucett con avenida Venezuela", distrito: "San Miguel", estado: .planificada),
    estacionLinea4(numero: 10, nombre: "Rafael Escardó", ubicacion: "Avenida Rafael Escardó", distrito: "San Miguel", estado: .planificada),
    estacionLinea4(numero: 11, nombre: "Pando", ubicacion: "Sector Pando", distrito: "San Miguel", estado: .planificada),
    estacionLinea4(numero: 12, nombre: "José de Sucre", ubicacion: "Avenida José de Sucre", distrito: "Pueblo Libre", estado: .planificada),
    estacionLinea4(numero: 13, nombre: "Brasil", ubicacion: "Avenida Javier Prado con avenida Brasil", distrito: "Magdalena del Mar", estado: .planificada),
    estacionLinea4(numero: 14, nombre: "Felipe Salaverry", ubicacion: "Avenida Javier Prado con avenida General Felipe Salaverry", distrito: "Jesús María", estado: .planificada),
    estacionLinea4(numero: 15, nombre: "Guillermo Prescott", ubicacion: "Avenida Javier Prado con calle Guillermo Prescott", distrito: "San Isidro", estado: .planificada),
    estacionLinea4(numero: 16, nombre: "Las Palmeras", ubicacion: "Avenida Javier Prado, sector Las Palmeras", distrito: "San Isidro", estado: .planificada),
    estacionLinea4(
        numero: 17,
        nombre: "Rivera Navarrete",
        ubicacion: "Avenida Javier Prado con avenida Rivera Navarrete",
        distrito: "San Isidro",
        estado: .planificada,
        conexiones: [
            Conexion(
                sistema: "Línea 3",
                estacion: "Rivera Navarrete",
                estado: .planificada,
                detalle: "Intercambio proyectado entre las líneas 4 y 3"
            )
        ]
    ),
    estacionLinea4(numero: 18, nombre: "Conde de San Isidro", ubicacion: "Avenida Javier Prado, sector Conde de San Isidro", distrito: "San Isidro", estado: .planificada),
    estacionLinea4(numero: 19, nombre: "Pablo Carriquiry", ubicacion: "Avenida Javier Prado con calle Pablo Carriquiry", distrito: "San Isidro", estado: .planificada),
    estacionLinea4(
        numero: 20,
        nombre: "La Cultura",
        ubicacion: "Avenida Javier Prado con avenida Aviación",
        distrito: "San Borja",
        estado: .planificada,
        conexiones: [
            Conexion(
                sistema: "Línea 1",
                estacion: "La Cultura",
                estado: .planificada,
                detalle: "Intercambio proyectado entre las líneas 4 y 1"
            )
        ]
    ),
    estacionLinea4(numero: 21, nombre: "San Luis", ubicacion: "Avenida Javier Prado con avenida San Luis", distrito: "San Borja", estado: .planificada),
    estacionLinea4(numero: 22, nombre: "Monterrico", ubicacion: "Avenida Javier Prado, sector Monterrico", distrito: "Santiago de Surco", estado: .planificada),
    estacionLinea4(numero: 23, nombre: "Manuel Olguín", ubicacion: "Avenida Javier Prado con avenida Manuel Olguín", distrito: "Santiago de Surco", estado: .planificada),
    estacionLinea4(numero: 24, nombre: "Los Frutales", ubicacion: "Avenida Javier Prado con avenida Los Frutales", distrito: "La Molina", estado: .planificada),
    estacionLinea4(numero: 25, nombre: "La Molina", ubicacion: "Avenida Javier Prado, distrito de La Molina", distrito: "La Molina", estado: .planificada),
    estacionLinea4(numero: 26, nombre: "Santa Patricia", ubicacion: "Avenida Javier Prado, urbanización Santa Patricia", distrito: "La Molina", estado: .planificada),
    estacionLinea4(numero: 27, nombre: "Mayorazgo", ubicacion: "Avenida Separadora Industrial, urbanización Mayorazgo", distrito: "Ate", estado: .planificada),
    estacionLinea4(
        numero: 28,
        nombre: "Mercado Santa Anita",
        ubicacion: "Carretera Central con avenida Separadora Industrial",
        distrito: "Ate",
        estado: .planificada,
        conexiones: [
            Conexion(
                sistema: "Línea 2",
                estacion: "Mercado Santa Anita",
                estado: .planificada,
                detalle: "Intercambio proyectado entre las líneas 4 y 2"
            )
        ]
    )
]

public let estacionesRegistradasLinea4 = estacionesRamalLinea4 + estacionesProyectoPrincipalLinea4
public let recorridoLinea4 = estacionesRegistradasLinea4.map { $0.nombre }
