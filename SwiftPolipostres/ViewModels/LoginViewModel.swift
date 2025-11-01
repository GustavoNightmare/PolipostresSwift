//
//  LoginViewModel.swift
//  SwiftPolipostres
//
//  Created by Telematica on 1/11/25.
//
import Foundation

final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String?
    @Published var isLoading = false

    private let repo: UserRepository

    init(repo: UserRepository = FileUserRepository()) {
        self.repo = repo
    }

    func login(onSuccess: (User) -> Void) {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }

        guard let user = repo.findByEmail(email.lowercased()) else {
            errorMessage = "Usuario no encontrado."
            return
        }
        guard user.password == password else {
            errorMessage = "Contraseña incorrecta."
            return
        }
        onSuccess(user)
    }
}
