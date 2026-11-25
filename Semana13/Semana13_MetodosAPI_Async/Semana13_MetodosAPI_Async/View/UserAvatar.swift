//
//  UserAvatar.swift
//  Semana13_MetodosAPI_Async
//
//  Created by Jason Gomez.
//

import SwiftUI

/// Círculo con las iniciales. El color sale del id, así cada usuario mantiene el suyo.
struct UserAvatar: View {
    let user: User

    private static let palette: [Color] = [
        Color(red: 0.04, green: 0.43, blue: 0.41), // verde petróleo
        Color(red: 0.72, green: 0.47, blue: 0.13), // ocre
        Color(red: 0.27, green: 0.36, blue: 0.53), // azul pizarra
        Color(red: 0.69, green: 0.33, blue: 0.24), // terracota
        Color(red: 0.42, green: 0.47, blue: 0.20), // oliva
        Color(red: 0.49, green: 0.29, blue: 0.45)  // ciruela
    ]

    private var color: Color {
        Self.palette[abs(user.id) % Self.palette.count]
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
        UserAvatar(user: User(id: 1, name: "Leanne Graham", email: "sincere@april.biz"))
        UserAvatar(user: User(id: 6, name: "Mrs. Dennis Schulist", email: "karley_dach@jasper.info"))
        UserAvatar(user: User(id: 9, name: "Glenna Reichert", email: "chaim_mcdermott@dana.io"))
    }
}
