//
//  ContentView.swift
//  Semana13_ConsumoAPI
//
//  Created by Jason Gomez.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = UserViewModel()

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Usuarios")
                .navigationSubtitle("jsonplaceholder.typicode.com")
        }
        .onAppear {
            // Solo pide la lista la primera vez; al volver a la pantalla no repite la petición
            if viewModel.users.isEmpty {
                viewModel.fetchUsers()
            }
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
            // Si falla una recarga se mantiene la lista anterior y se avisa arriba
            if case .failed(let message) = viewModel.state {
                Section {
                    Label(message, systemImage: "exclamationmark.triangle.fill")
                        .foregroundStyle(.orange)
                    Button("Reintentar") { viewModel.fetchUsers() }
                }
            }
            Section {
                // Lista de usuarios filtrados
                ForEach(viewModel.filteredUsers) { user in
                    UserRow(user: user)
                }
            } header: {
                Text(headerText)
            }
        }
        .refreshable { viewModel.fetchUsers() }
        // Campo de búsqueda en la barra de navegación, enlazado a searchText del ViewModel
        .searchable(text: $viewModel.searchText, prompt: "Buscar usuario por nombre")
        .autocorrectionDisabled()
        .overlay {
            if viewModel.filteredUsers.isEmpty && !viewModel.users.isEmpty {
                ContentUnavailableView(
                    "Nadie se llama “\(viewModel.searchText)”",
                    systemImage: "person.crop.circle.badge.questionmark",
                    description: Text("Revisa cómo lo escribiste o busca con otra parte del nombre.")
                )
            }
        }
    }

    private var headerText: String {
        let total = viewModel.users.count
        let shown = viewModel.filteredUsers.count
        return shown == total ? "\(total) usuarios registrados" : "\(shown) de \(total) usuarios"
    }
}

/// Fila de la lista: avatar, nombre y el id que viene de la API.
private struct UserRow: View {
    let user: User

    var body: some View {
        HStack(spacing: 14) {
            UserAvatar(user: user)
            Text(user.name)
                .font(.body.weight(.medium))
            Spacer()
            Text("ID \(user.id)")
                .font(.caption.monospacedDigit())
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 2)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    ContentView()
}
