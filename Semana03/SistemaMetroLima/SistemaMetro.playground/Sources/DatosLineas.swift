// Desarrollado por: Jason Gomez

import Foundation

public let lineasMetro: [Int: LineaMetro] = [
    1: LineaMetro(
        numero: 1,
        nombre: "Línea 1",
        estado: .operativa,
        corredor: "Villa El Salvador - Bayóvar",
        distritos: [
            "Villa El Salvador", "Villa María del Triunfo", "San Juan de Miraflores",
            "Santiago de Surco", "San Borja", "La Victoria", "Lima",
            "San Juan de Lurigancho"
        ],
        tieneCatalogoEstaciones: true,
        observacion: "Servicio operativo; 28 de Julio se registra aparte como intercambio futuro"
    ),
    2: LineaMetro(
        numero: 2,
        nombre: "Línea 2",
        estado: .operacionParcial,
        corredor: "Puerto del Callao - Municipalidad de Ate",
        distritos: [
            "Callao", "Bellavista", "Carmen de la Legua Reynoso", "Lima", "Breña",
            "La Victoria", "El Agustino", "Santa Anita", "Ate"
        ],
        tieneCatalogoEstaciones: true,
        observacion: "Cinco estaciones operativas y las demás en construcción"
    ),
    3: LineaMetro(
        numero: 3,
        nombre: "Línea 3",
        estado: .planificada,
        corredor: "Comas - San Juan de Miraflores",
        distritos: [
            "Comas", "Los Olivos", "San Martín de Porres", "Lima", "Lince",
            "San Isidro", "Miraflores", "Santiago de Surco", "San Juan de Miraflores"
        ],
        horizonte: "2035",
        tieneCatalogoEstaciones: true,
        observacion: "Las 28 estaciones son referencias del proyecto y no prestan servicio"
    ),
    4: LineaMetro(
        numero: 4,
        nombre: "Línea 4",
        estado: .enConstruccion,
        corredor: "Callao - Ate por el eje Faucett y Javier Prado",
        distritos: [
            "Callao", "Carmen de la Legua Reynoso", "San Miguel", "Pueblo Libre",
            "Magdalena del Mar", "Jesús María", "San Isidro", "San Borja",
            "Santiago de Surco", "La Molina", "Ate"
        ],
        horizonte: "2035",
        tieneCatalogoEstaciones: true,
        observacion: "El ramal de ocho estaciones está en construcción; el corredor principal continúa planificado"
    ),
    5: LineaMetro(
        numero: 5,
        nombre: "Línea 5",
        estado: .planificada,
        corredor: "Eje centro-sur hacia Villa El Salvador",
        distritos: ["Surquillo", "Miraflores", "Chorrillos", "Villa El Salvador"],
        horizonte: "2045",
        tieneCatalogoEstaciones: false,
        observacion: "La planificación oficial todavía no publica nombres definitivos de estaciones"
    ),
    6: LineaMetro(
        numero: 6,
        nombre: "Línea 6",
        estado: .planificada,
        corredor: "Eje transversal norte-este",
        distritos: [
            "Independencia", "San Martín de Porres", "Comas", "Santiago de Surco", "La Molina"
        ],
        horizonte: "2045",
        tieneCatalogoEstaciones: false,
        observacion: "La planificación oficial todavía no publica nombres definitivos de estaciones"
    )
]
