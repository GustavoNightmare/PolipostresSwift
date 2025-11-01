//
//  RegisterViewModel.swift
//  SwiftPolipostres
//
//  Created by Telematica on 1/11/25.
//

import Foundation
import Combine

final class RegisterViewModel: ObservableObject {
    // Inputs
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""

    // UI state
    @Published var showPassword: Bool = false
    @Published var showConfirmPassword: Bool = false
    @Published var isSaving: Bool = false
    @Published var errorMessage: String? = nil
    @Published var didRegister: Bool = false

    private let repo: UserRepository

    init(repo: UserRepository = UserDefaultsUserRepository()) {
        self.repo = repo
    }

    func register() {
        errorMessage = nil
        guard validate() else { return }
        isSaving = true

        let user = User(id: UUID(),
                        name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                        email: email.lowercased().trimmingCharacters(in: .whitespacesAndNewlines),
                        password: password)

        do {
            try repo.save(user)
            isSaving = false
            didRegister = true
        } catch {
            isSaving = false
            errorMessage = "No se pudo guardar el usuario."
        }
    }

    private func validate() -> Bool {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errorMessage = "Ingresa tu nombre."
            return false
        }
        if !isValidEmail(email) {
            errorMessage = "Correo inválido."
            return false
        }
        if password.count < 6 {
            errorMessage = "La contraseña debe tener al menos 6 caracteres."
            return false
        }
        if password != confirmPassword {
            errorMessage = "Las contraseñas no coinciden."
            return false
        }
        return true
    }

    private func isValidEmail(_ str: String) -> Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: str)
    }
}
