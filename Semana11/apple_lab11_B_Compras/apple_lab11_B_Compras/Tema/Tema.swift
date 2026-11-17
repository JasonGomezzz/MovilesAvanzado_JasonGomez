import SwiftUI

// MARK: - Colores

extension Color {
    /// Color que cambia entre modo claro y oscuro.
    init(claro: Color, oscuro: Color) {
        self.init(uiColor: UIColor { rasgos in
            rasgos.userInterfaceStyle == .dark ? UIColor(oscuro) : UIColor(claro)
        })
    }

    /// Verde azulado de la maqueta del profesor (el mismo del ícono).
    static let marca = Color(claro: Color(red: 0.039, green: 0.612, blue: 0.478),
                             oscuro: Color(red: 0.24, green: 0.80, blue: 0.65))
    /// Ámbar de la flecha del ícono, para lo que está pendiente.
    static let aviso = Color(claro: Color(red: 0.72, green: 0.42, blue: 0.0),
                             oscuro: Color(red: 1.0, green: 0.76, blue: 0.28))
    static let correcto = Color(claro: Color(red: 0.06, green: 0.54, blue: 0.30),
                                oscuro: Color(red: 0.35, green: 0.82, blue: 0.54))
    static let peligro = Color(claro: Color(red: 0.82, green: 0.17, blue: 0.20),
                               oscuro: Color(red: 1.0, green: 0.42, blue: 0.42))
}

enum Paleta {
    /// Colores de avatar: sobrios y con buen contraste con texto blanco.
    private static let avatares: [Color] = [
        Color(red: 0.04, green: 0.50, blue: 0.42),
        Color(red: 0.25, green: 0.38, blue: 0.80),
        Color(red: 0.50, green: 0.33, blue: 0.72),
        Color(red: 0.80, green: 0.42, blue: 0.10),
        Color(red: 0.36, green: 0.44, blue: 0.52)
    ]

    /// Siempre da el mismo color para el mismo texto (hashValue cambia en cada ejecución, esto no).
    static func avatar(para texto: String) -> Color {
        let suma = texto.unicodeScalars.reduce(0) { $0 + Int($1.value) }
        return avatares[suma % avatares.count]
    }

    /// Colores para las series de los gráficos.
    static let serie: [Color] = [
        Color(red: 0.04, green: 0.58, blue: 0.47),
        Color(red: 0.95, green: 0.65, blue: 0.15),
        Color(red: 0.25, green: 0.38, blue: 0.80),
        Color(red: 0.50, green: 0.33, blue: 0.72),
        Color(red: 0.36, green: 0.44, blue: 0.52)
    ]
}

// MARK: - Componentes

/// Cuadro o círculo con las iniciales, como en la maqueta.
struct Avatar: View {
    let texto: String
    var tamano: CGFloat = 40
    var circular = false

    var body: some View {
        Text(Formato.iniciales(texto))
            .font(.system(size: tamano * 0.36, weight: .semibold, design: .rounded))
            .foregroundStyle(.white)
            .frame(width: tamano, height: tamano)
            .background(Paleta.avatar(para: texto),
                        in: circular ? AnyShape(Circle())
                                     : AnyShape(RoundedRectangle(cornerRadius: tamano * 0.3, style: .continuous)))
            .accessibilityHidden(true)
    }
}

/// Etiqueta de estado con fondo suave: "Pendiente", "VENCIDA", "Al día"…
struct Insignia: View {
    let texto: String
    let color: Color

    var body: some View {
        Text(texto)
            .font(.caption2.weight(.bold))
            .foregroundStyle(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(color.opacity(0.14), in: Capsule())
            .fixedSize()
    }
}

/// Stock con color: verde más de 10, ámbar de 6 a 10, rojo de 5 o menos.
struct InsigniaStock: View {
    let stock: Int

    private var color: Color {
        switch stock {
        case ..<6: .peligro
        case 6...10: .aviso
        default: .correcto
        }
    }

    var body: some View {
        Insignia(texto: "\(stock) u.", color: color)
            .accessibilityLabel("Stock \(stock) unidades")
    }
}

extension EstadoCompra {
    var color: Color {
        switch self {
        case .pendiente: .aviso
        case .aprobada: .correcto
        case .rechazada: .peligro
        }
    }

    var icono: String {
        switch self {
        case .pendiente: "hourglass"
        case .aprobada: "checkmark"
        case .rechazada: "xmark"
        }
    }
}

/// Cuadro con el icono del estado de una compra.
struct IconoEstado: View {
    let estado: EstadoCompra

    var body: some View {
        Image(systemName: estado.icono)
            .font(.system(size: 15, weight: .bold))
            .foregroundStyle(estado.color)
            .frame(width: 40, height: 40)
            .background(estado.color.opacity(0.14), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            .accessibilityHidden(true)
    }
}

extension View {
    /// Tarjeta con fondo de grupo y esquinas continuas.
    func tarjeta(relleno: CGFloat = 16) -> some View {
        padding(relleno)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.secondarySystemGroupedBackground),
                        in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

// MARK: - Botones (responden al toque al instante, sin esperar a soltar)

struct BotonPrincipal: ButtonStyle {
    var color: Color = .marca
    @Environment(\.isEnabled) private var habilitado

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(color.opacity(habilitado ? 1 : 0.35),
                        in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .opacity(configuration.isPressed ? 0.9 : 1)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct BotonContorno: ButtonStyle {
    var color: Color = .peligro

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(color)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 13)
            .background(configuration.isPressed ? color.opacity(0.1) : .clear,
                        in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(color, lineWidth: 1.5))
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Campos del login y registro

/// Etiqueta pequeña sobre un campo, con el campo dentro de una tarjeta.
struct CampoEtiquetado<Contenido: View>: View {
    let etiqueta: String
    @ViewBuilder var contenido: Contenido

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(etiqueta.uppercased())
                .font(.caption2.weight(.semibold))
                .tracking(0.6)
                .foregroundStyle(.secondary)
            contenido
                .padding(.horizontal, 14)
                .padding(.vertical, 13)
                .background(Color(.secondarySystemGroupedBackground),
                            in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }
}

/// Mensaje de error en rojo con triángulo, como en la maqueta.
struct MensajeError: View {
    let texto: String

    var body: some View {
        Label(texto, systemImage: "exclamationmark.triangle.fill")
            .font(.footnote.weight(.medium))
            .foregroundStyle(Color.peligro)
            .frame(maxWidth: .infinity, alignment: .leading)
            .accessibilityAddTraits(.isStaticText)
    }
}
