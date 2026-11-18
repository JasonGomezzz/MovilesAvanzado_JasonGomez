//
//  Ayudas.swift
//  apple_lab11_B_Compras
//
//  Created by Jason on 17/11/26.
//

import SwiftUI

// Convierte un número en soles: 7080 -> "S/ 7,080.00"
func soles(_ valor: Double) -> String {
    let texto = valor.formatted(.number.precision(.fractionLength(2)).locale(Locale(identifier: "en_US")))
    return "S/ " + texto
}

// Fecha corta: "17/11/2026"
func fechaCorta(_ fecha: Date) -> String {
    return fecha.formatted(.dateTime.day(.twoDigits).month(.twoDigits).year().locale(Locale(identifier: "es_PE")))
}

// Acepta "120", "120.5" o "120,5"
func leerNumero(_ texto: String) -> Double? {
    return Double(texto.replacingOccurrences(of: ",", with: "."))
}

// Etiqueta pequeña de color: "Pendiente", "VENCIDA", "Al día"...
struct Etiqueta: View {
    let texto: String
    let color: Color

    var body: some View {
        Text(texto)
            .font(.caption.bold())
            .foregroundStyle(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(color.opacity(0.15))
            .clipShape(Capsule())
    }
}

// Cuadro con las iniciales (para productos y proveedores)
struct Iniciales: View {
    let texto: String

    var iniciales: String {
        let palabras = texto.split(separator: " ")
        var resultado = ""
        for palabra in palabras.prefix(2) {
            resultado += String(palabra.prefix(1))
        }
        return resultado.uppercased()
    }

    var body: some View {
        Text(iniciales)
            .font(.subheadline.bold())
            .foregroundStyle(.white)
            .frame(width: 38, height: 38)
            .background(Color.teal)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

// Color del estado de una compra
func colorEstado(_ estado: String) -> Color {
    switch estado {
    case "Aprobada": return .green
    case "Rechazada": return .red
    default: return .orange   // Pendiente
    }
}

// Color del stock: verde más de 10, ámbar de 6 a 10, rojo de 5 o menos
func colorStock(_ stock: Int) -> Color {
    if stock > 10 { return .green }
    if stock >= 6 { return .orange }
    return .red
}
