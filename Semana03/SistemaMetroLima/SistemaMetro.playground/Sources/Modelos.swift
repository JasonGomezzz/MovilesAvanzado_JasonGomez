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

public enum EstadoLinea: String, CaseIterable {
    case operativa = "Operativa"
    case operacionParcial = "Operación parcial"
    case enConstruccion = "En construcción"
    case planificada = "Planificada"
}

public struct LineaMetro {
    public let numero: Int
    public let nombre: String
    public let estado: EstadoLinea
    public let corredor: String
    public let distritos: [String]
    public let horizonte: String?
    public let tieneCatalogoEstaciones: Bool
    public let observacion: String

    public init(
        numero: Int,
        nombre: String,
        estado: EstadoLinea,
        corredor: String,
        distritos: [String],
        horizonte: String? = nil,
        tieneCatalogoEstaciones: Bool,
        observacion: String
    ) {
        self.numero = numero
        self.nombre = nombre
        self.estado = estado
        self.corredor = corredor
        self.distritos = distritos
        self.horizonte = horizonte
        self.tieneCatalogoEstaciones = tieneCatalogoEstaciones
        self.observacion = observacion
    }
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
    public let estadosPorLinea: [Int: EstadoServicio]
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
        estadosPorLinea: [Int: EstadoServicio]? = nil,
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
        self.estadosPorLinea = estadosPorLinea ?? Dictionary(
            uniqueKeysWithValues: lineas.map { ($0, estado) }
        )
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
