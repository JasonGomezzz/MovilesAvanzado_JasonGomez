//
//  UserAvatar.swift
//  Semana13_ConsumoAPI
//
//  Created by Jason Gomez.
//

import SwiftUI

/// Círculo con las iniciales. El color sale del id, así cada usuario mantiene el suyo.
struct UserAvatar: View {
    let user: User
    @Environment(\.colorScheme) private var colorScheme

    private static let palette: [Color] = [
        Color(red: 0.04, green: 0.43, blue: 0.41), // verde petróleo
        Color(red: 0.72, green: 0.47, blue: 0.13), // ocre
        Color(red: 0.27, green: 0.36, blue: 0.53), // azul pizarra
        Color(red: 0.69, green: 0.33, blue: 0.24), // terracota
        Color(red: 0.42, green: 0.47, blue: 0.20), // oliva
        Color(red: 0.49, green: 0.29, blue: 0.45)  // ciruela
    ]

    private var color: Color {
        let base = Self.palette[abs(user.id) % Self.palette.count]
        // En modo oscuro se aclara el tono para que las iniciales se lean sobre fondo negro
        return colorScheme == .dark ? base.mix(with: .white, by: 0.45) : base
    }

    var body: some View {
        Text(user.initials)
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(color)
            .frame(width: 42, height: 42)
            .background(color.opacity(0.14), in: .circle)
            .overlay(Circle().strokeBorder(color.opacity(0.35), lineWidth: 1))
            .accessibilityHidden(true)
    }
}

#Preview {
    HStack {
        UserAvatar(user: User(id: 1, name: "Leanne Graham"))
        UserAvatar(user: User(id: 6, name: "Mrs. Dennis Schulist"))
        UserAvatar(user: User(id: 9, name: "Glenna Reichert"))
    }
}
