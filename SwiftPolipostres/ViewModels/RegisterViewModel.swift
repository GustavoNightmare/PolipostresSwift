import Foundation

final class RegisterViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var showPassword = false
    @Published var showConfirmPassword = false
    @Published var isSaving = false
    @Published var errorMessage: String?
    @Published var didRegister = false

    private let repo: UserRepository

    init(repo: UserRepository = FileUserRepository()) {
        self.repo = repo
    }

    func register() {
        errorMessage = nil
        guard validate() else { return }
        isSaving = true
        defer { isSaving = false }

        let user = User(id: UUID(),
                        name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                        email: email.lowercased().trimmingCharacters(in: .whitespacesAndNewlines),
                        password: password,
                        createdAt: Date())

        do {
            try repo.register(user)
            didRegister = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func validate() -> Bool {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errorMessage = "Ingresa tu nombre."
            return false
        }
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        if NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: email) == false {
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
}

