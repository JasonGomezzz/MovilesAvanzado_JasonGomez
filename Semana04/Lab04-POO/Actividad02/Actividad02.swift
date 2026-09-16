// Desarrollado por: Jason Gomez

import Foundation

class Cliente {
    let codigo: String
    let direccion: String
    let fechaDelRegistro: String
    let numeroCuenta: String
    let montoMinimoApertura: Double

    init(
        codigo: String,
        direccion: String,
        fechaDelRegistro: String,
        numeroCuenta: String,
        montoMinimoApertura: Double
    ) {
        self.codigo = codigo
        self.direccion = direccion
        self.fechaDelRegistro = fechaDelRegistro
        self.numeroCuenta = numeroCuenta
        self.montoMinimoApertura = montoMinimoApertura
    }

    func mostrarDatos() {
        print("Código: \(codigo)")
        print("Dirección: \(direccion)")
        print("Fecha de registro: \(fechaDelRegistro)")
        print("Número de cuenta: \(numeroCuenta)")
        print(String(format: "Monto mínimo de apertura: S/ %.2f", montoMinimoApertura))
    }
}

class ClienteNatural: Cliente {
    let nombreCompleto: String
    let dni: String

    init(
        nombreCompleto: String,
        dni: String,
        codigo: String,
        direccion: String,
        fechaDelRegistro: String,
        numeroCuenta: String,
        montoMinimoApertura: Double
    ) {
        self.nombreCompleto = nombreCompleto
        self.dni = dni
        super.init(
            codigo: codigo,
            direccion: direccion,
            fechaDelRegistro: fechaDelRegistro,
            numeroCuenta: numeroCuenta,
            montoMinimoApertura: montoMinimoApertura
        )
    }

    override func mostrarDatos() {
        print("===== CLIENTE NATURAL =====")
        print("Nombre completo: \(nombreCompleto)")
        print("DNI: \(dni)")
        super.mostrarDatos()
    }
}

class ClienteJuridico: Cliente {
    let razonSocial: String
    let ruc: String
    let representanteLegal: String

    init(
        razonSocial: String,
        ruc: String,
        representanteLegal: String,
        codigo: String,
        direccion: String,
        fechaDelRegistro: String,
        numeroCuenta: String,
        montoMinimoApertura: Double
    ) {
        self.razonSocial = razonSocial
        self.ruc = ruc
        self.representanteLegal = representanteLegal
        super.init(
            codigo: codigo,
            direccion: direccion,
            fechaDelRegistro: fechaDelRegistro,
            numeroCuenta: numeroCuenta,
            montoMinimoApertura: montoMinimoApertura
        )
    }

    override func mostrarDatos() {
        print("===== CLIENTE JURÍDICO =====")
        print("Razón social: \(razonSocial)")
        print("RUC: \(ruc)")
        print("Representante legal: \(representanteLegal)")
        super.mostrarDatos()
    }
}

let clienteNatural = ClienteNatural(
    nombreCompleto: "Juan Pérez",
    dni: "12345678",
    codigo: "C001",
    direccion: "Av. Lima 123",
    fechaDelRegistro: "2025-04-03",
    numeroCuenta: "001-2025-000123",
    montoMinimoApertura: 500.0
)

let clienteJuridico = ClienteJuridico(
    razonSocial: "Soluciones SAC",
    ruc: "20123456789",
    representanteLegal: "María León",
    codigo: "C002",
    direccion: "Jr. Empresas 456",
    fechaDelRegistro: "2025-04-01",
    numeroCuenta: "001-2025-000456",
    montoMinimoApertura: 3000.0
)

let clientes: [Cliente] = [clienteNatural, clienteJuridico]

for cliente in clientes {
    cliente.mostrarDatos()
}
