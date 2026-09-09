// Desarrollado por: Jason Gomez

import Foundation

public enum EstadoServicio: String, CaseIterable {
    case operativa = "Operativa"
    case enConstruccion = "En construcción"
    case planificada = "Planificada"
}

public enum EstadoConexion: String, CaseIterable {
    case operativa = "Operativa"
    case planificada = "Planificada"
}

public struct Conexion {
    public let sistema: String
    public let estacion: String
    public let estado: EstadoConexion
    public let detalle: String

    public init(
        sistema: String,
        estacion: String,
        estado: EstadoConexion,
        detalle: String
    ) {
        self.sistema = sistema
        self.estacion = estacion
        self.estado = estado
        self.detalle = detalle
    }
}

public struct Estacion {
    public let codigo: String?
    public let nombre: String
    public let lineas: [Int]
    public let ubicacion: String
    public let distrito: String
    public let estado: EstadoServicio
    public let tieneAscensor: Bool
    public let accesoAlternativo: String?
    public let conexiones: [Conexion]

    public init(
        codigo: String? = nil,
        nombre: String,
        lineas: [Int],
        ubicacion: String,
        distrito: String,
        estado: EstadoServicio,
        tieneAscensor: Bool,
        accesoAlternativo: String? = nil,
        conexiones: [Conexion] = []
    ) {
        self.codigo = codigo
        self.nombre = nombre
        self.lineas = lineas
        self.ubicacion = ubicacion
        self.distrito = distrito
        self.estado = estado
        self.tieneAscensor = tieneAscensor
        self.accesoAlternativo = accesoAlternativo
        self.conexiones = conexiones
    }
}

public struct LugarInteres {
    public let nombre: String
    public let estacionRecomendada: String
    public let indicacionesFinales: [String]

    public init(
        nombre: String,
        estacionRecomendada: String,
        indicacionesFinales: [String]
    ) {
        self.nombre = nombre
        self.estacionRecomendada = estacionRecomendada
        self.indicacionesFinales = indicacionesFinales
    }
}

public struct ResultadoRuta {
    public let origen: String
    public let destino: String
    public let estaciones: [String]
    public let transbordos: [String]
    public let advertencias: [String]
    public let indicacionesFinales: [String]

    public init(
        origen: String,
        destino: String,
        estaciones: [String],
        transbordos: [String] = [],
        advertencias: [String] = [],
        indicacionesFinales: [String] = []
    ) {
        self.origen = origen
        self.destino = destino
        self.estaciones = estaciones
        self.transbordos = transbordos
        self.advertencias = advertencias
        self.indicacionesFinales = indicacionesFinales
    }
}
