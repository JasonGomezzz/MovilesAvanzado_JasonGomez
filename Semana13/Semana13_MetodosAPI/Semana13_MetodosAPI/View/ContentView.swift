//
//  ContentView.swift
//  Semana13_MetodosAPI
//
//  Created by Jason Gomez.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = UserViewModel()

    @State private var showingForm = false
    @State private var editingUser: User? = nil
    @State private var userToDelete: User? = nil

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Usuarios")
                .navigationSubtitle("GET · POST · PUT · DELETE")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            editingUser = nil
                            showingForm = true
                        } label: {
                            Label("Agregar usuario", systemImage: "person.badge.plus")
                        }
                        .disabled(viewModel.isSending || viewModel.users.isEmpty)
                    }
                }
        }
        .onAppear {
            if viewModel.users.isEmpty {
                viewModel.fetchUsers()
            }
        }
        .sheet(isPresented: $showingForm) {
            UserFormView(user: editingUser, existingUsers: viewModel.users, isSending: viewModel.isSending) { name, email in
                if let user = editingUser {
                    let updated = User(id: user.id, name: name, email: email)
                    viewModel.updateUser(user: updated)
                } else {
                    viewModel.createUser(name: name, email: email)
                }
            }
        }
        .confirmationDialog(
            "¿Eliminar a \(userToDelete?.name ?? "este usuario")?",
            isPresented: Binding(get: { userToDelete != nil }, set: { if !$0 { userToDelete = nil } }),
            titleVisibility: .visible,
            presenting: userToDelete
        ) { user in
            Button("Eliminar", role: .destructive) {
                viewModel.deleteUser(id: user.id)
            }
        } message: { _ in
            Text("Se enviará DELETE a la API y se quitará de la lista.")
        }
        .alert(
            "No se pudo completar",
            isPresented: Binding(get: { viewModel.errorMessage != nil }, set: { if !$0 { viewModel.errorMessage = nil } })
        ) {
            Button("Entendido", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading where viewModel.users.isEmpty:
            ProgressView("Cargando usuarios…")
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .failed(let message) where viewModel.users.isEmpty:
            ContentUnavailableView {
                Label("No se pudo cargar la lista", systemImage: "wifi.exclamationmark")
            } description: {
                Text(message)
            } actions: {
                Button("Reintentar") { viewModel.fetchUsers() }
                    .buttonStyle(.borderedProminent)
            }

        default:
            userList
        }
    }

    private var userList: some View {
        List {
            if let log = viewModel.lastRequest {
                Section("Última petición") {
                    RequestLogRow(log: log, isSending: viewModel.isSending)
                }
            }

            Section {
                ForEach(viewModel.filteredUsers) { user in
                    Button {
                        editingUser = user
                        showingForm = true
                    } label: {
                        UserRow(user: user)
                    }
                    .tint(.primary)
                    .swipeActions {
                        Button(role: .destructive) {
                            userToDelete = user
                        } label: {
                            Label("Eliminar", systemImage: "trash")
                        }

                        Button {
                            editingUser = user
                            showingForm = true
                        } label: {
                            Label("Editar", systemImage: "pencil")
                        }
                        .tint(.accentColor)
                    }
                }
            } header: {
                Text(headerText)
            } footer: {
                Text("Desliza una fila a la izquierda para editar o eliminar.")
            }
        }
        .disabled(viewModel.isSending)
        .refreshable { viewModel.fetchUsers() }
        .searchable(text: $viewModel.searchText, prompt: "Buscar por nombre o correo")
        .autocorrectionDisabled()
        .textInputAutocapitalization(.never)
        .overlay {
            if viewModel.filteredUsers.isEmpty && !viewModel.users.isEmpty {
                ContentUnavailableView(
                    "Sin coincidencias para “\(viewModel.searchText)”",
                    systemImage: "person.crop.circle.badge.questionmark",
                    description: Text("Prueba con otra parte del nombre o del correo.")
                )
            }
        }
    }

    private var headerText: String {
        let total = viewModel.users.count
        let shown = viewModel.filteredUsers.count
        return shown == total ? "\(total) usuarios" : "\(shown) de \(total) usuarios"
    }
}

/// Fila de la lista: avatar, nombre y correo.
private struct UserRow: View {
    let user: User

    var body: some View {
        HStack(spacing: 14) {
            UserAvatar(user: user)
            VStack(alignment: .leading, spacing: 2) {
                Text(user.name)
                    .font(.headline)
                Text(user.email)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 0)
        }
        .padding(.vertical, 2)
        .contentShape(.rect)
        .accessibilityElement(children: .combine)
        .accessibilityHint("Toca para editar")
    }
}

/// Muestra el método, la ruta y lo que respondió la API.
private struct RequestLogRow: View {
    let log: RequestLog
    let isSending: Bool

    private var methodColor: Color {
        switch log.method {
        case "POST": Color(red: 0.16, green: 0.55, blue: 0.30)
        case "PUT": Color(red: 0.80, green: 0.48, blue: 0.08)
        case "DELETE": Color(red: 0.77, green: 0.22, blue: 0.20)
        default: Color.accentColor
        }
    }

    private var statusText: String {
        guard let status = log.status else { return "sin petición" }
        let meaning = switch status {
        case 200: "OK"
        case 201: "Creado"
        case 404: "No encontrado"
        case 500...599: "Error del servidor"
        default: ""
        }
        return "\(status) \(meaning)"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                Text(log.method)
                    .font(.caption.weight(.bold).monospaced())
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(methodColor, in: .capsule)
                Text(log.path)
                    .font(.callout.monospaced())
                Spacer()
                if isSending {
                    ProgressView()
                } else {
                    Text(statusText)
                        .font(.caption.monospacedDigit())
                        .foregroundStyle(.secondary)
                }
            }
            if let note = log.note {
                Text(note)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else if log.status != nil {
                Text(String(format: "Respondió en %.2f s", log.seconds))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    ContentView()
}
