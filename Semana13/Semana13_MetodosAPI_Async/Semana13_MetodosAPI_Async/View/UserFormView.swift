//
//  UserFormView.swift
//  Semana13_MetodosAPI_Async
//
//  Created by Jason Gomez.
//  Vista para agregar o modificar un usuario.
//

import SwiftUI

struct UserFormView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var name: String
    @State private var email: String
    @FocusState private var focusedField: Field?

    private let original: User?
    private let otherUsers: [User]
    private let isSending: Bool
    private let onSubmit: (String, String) -> Void

    private enum Field { case name, email }

    /// - Parameters:
    ///   - user: el usuario a editar, o nil para crear uno nuevo.
    ///   - existingUsers: la lista actual, para no repetir correos.
    init(user: User?, existingUsers: [User], isSending: Bool, onSubmit: @escaping (String, String) -> Void) {
        _name = State(initialValue: user?.name ?? "")
        _email = State(initialValue: user?.email ?? "")
        original = user
        otherUsers = existingUsers.filter { $0.id != user?.id }
        self.isSending = isSending
        self.onSubmit = onSubmit
    }

    private var isEditing: Bool { original != nil }

    private var nameError: String? { UserValidator.nameError(name) }
    private var emailError: String? { UserValidator.emailError(email, others: otherUsers) }

    private var cleanName: String { UserValidator.normalizeName(name) }
    private var cleanEmail: String { UserValidator.normalizeEmail(email) }

    private var hasChanges: Bool {
        cleanName != (original?.name ?? "") || cleanEmail != (original?.email.lowercased() ?? "")
    }

    private var canSave: Bool {
        nameError == nil && emailError == nil && hasChanges && !isSending
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack(spacing: 14) {
                        UserAvatar(user: User(id: original?.id ?? 0, name: cleanName, email: cleanEmail))
                        VStack(alignment: .leading, spacing: 2) {
                            Text(cleanName.isEmpty ? "Nombre y apellido" : cleanName)
                                .font(.headline)
                                .foregroundStyle(cleanName.isEmpty ? .secondary : .primary)
                            Text(isEditing ? "Editando el ID \(original!.id)" : "Se enviará con POST /users")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Section {
                    TextField("Nombre y apellido", text: $name)
                        .textContentType(.name)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()
                        .submitLabel(.next)
                        .focused($focusedField, equals: .name)
                        .onSubmit { focusedField = .email }
                    FieldError(message: name.isEmpty ? nil : nameError)
                } header: {
                    Text("Nombre")
                }

                Section {
                    TextField("nombre@dominio.com", text: $email)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .submitLabel(.done)
                        .focused($focusedField, equals: .email)
                        .onSubmit(save)
                    FieldError(message: email.isEmpty ? nil : emailError)
                } header: {
                    Text("Correo")
                } footer: {
                    Text(footerText)
                }
            }
            .navigationTitle(isEditing ? "Editar usuario" : "Nuevo usuario")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar", role: .cancel) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(isEditing ? "Guardar" : "Crear", action: save)
                        .disabled(!canSave)
                }
            }
            // Si ya escribió algo, no se cierra por accidente al deslizar hacia abajo
            .interactiveDismissDisabled(hasChanges)
            .onAppear { focusedField = isEditing ? nil : .name }
        }
    }

    private var footerText: String {
        if isEditing && !hasChanges {
            return "Cambia el nombre o el correo para poder guardar."
        }
        return "Nombre y apellido reales, sin números. El correo no puede repetirse con otro usuario."
    }

    private func save() {
        guard canSave else { return }
        onSubmit(cleanName, cleanEmail)
        dismiss()
    }
}

/// Mensaje rojo debajo de un campo; no ocupa espacio si no hay error.
private struct FieldError: View {
    let message: String?

    var body: some View {
        if let message {
            Label(message, systemImage: "exclamationmark.circle.fill")
                .font(.footnote)
                .foregroundStyle(.red)
        }
    }
}

#Preview("Nuevo") {
    UserFormView(user: nil, existingUsers: [], isSending: false) { _, _ in }
}

#Preview("Editar") {
    UserFormView(user: User(id: 3, name: "Clementine Bauch", email: "nathan@yesenia.net"),
                 existingUsers: [], isSending: false) { _, _ in }
}
