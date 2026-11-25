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
    @State private var isSaving = false
    @State private var serverError: String?

    private let original: User?
    private let otherUsers: [User]
    /// Devuelve nil si la API respondió bien, o el mensaje de error.
    private let onSubmit: (String, String) async -> String?

    private enum Field { case name, email }

    /// - Parameters:
    ///   - user: el usuario a editar, o nil para crear uno nuevo.
    ///   - existingUsers: la lista actual, para no repetir correos.
    init(user: User?, existingUsers: [User], onSubmit: @escaping (String, String) async -> String?) {
        _name = State(initialValue: user?.name ?? "")
        _email = State(initialValue: user?.email ?? "")
        original = user
        otherUsers = existingUsers.filter { $0.id != user?.id }
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
        nameError == nil && emailError == nil && hasChanges && !isSaving
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

                // Si la API falla, el formulario no se cierra y no se pierde lo escrito
                if let serverError {
                    Section {
                        Label(serverError, systemImage: "wifi.exclamationmark")
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle(isEditing ? "Editar usuario" : "Nuevo usuario")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar", role: .cancel) { dismiss() }
                        .disabled(isSaving)
                }
                ToolbarItem(placement: .confirmationAction) {
                    if isSaving {
                        ProgressView()
                    } else {
                        Button(isEditing ? "Guardar" : "Crear", action: save)
                            .disabled(!canSave)
                    }
                }
            }
            .disabled(isSaving)
            // Si ya escribió algo, no se cierra por accidente al deslizar hacia abajo
            .interactiveDismissDisabled(hasChanges || isSaving)
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
        // Task permite llamar a la función async desde el botón, que es código síncrono
        Task {
            isSaving = true
            serverError = nil
            let error = await onSubmit(cleanName, cleanEmail)
            isSaving = false
            if let error {
                serverError = error
            } else {
                dismiss() // se cierra solo cuando la API ya respondió bien
            }
        }
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
    UserFormView(user: nil, existingUsers: []) { _, _ in nil }
}

#Preview("Editar") {
    UserFormView(user: User(id: 3, name: "Clementine Bauch", email: "nathan@yesenia.net"),
                 existingUsers: []) { _, _ in nil }
}
