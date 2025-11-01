//
//  LoginViewModel.swift
//  SwiftPolipostres
//
//  Created by Telematica on 1/11/25.
//
import Foundation
import Combine

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isPasswordVisible: Bool = false

    // Alert properties
    @Published var showingAlert: Bool = false
    var alertTitle = ""
    var alertMessage = ""

    private let userRepository: UserRepository

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    func login() {
        let correo = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let clave = password

        guard !correo.isEmpty, !clave.isEmpty else {
            alertTitle = "Campos vacíos"
            alertMessage = "Por favor ingresa correo y contraseña."
            showingAlert = true
            return
        }

        // Llamada al repositorio local
        if userRepository.authenticate(email: correo, password: clave) {
            // login exitoso -> manejar navegación o estado global
            alertTitle = "Éxito"
            alertMessage = "Has ingresado correctamente."
            showingAlert = true
            // aquí cambiar la vista principal (ej. setear un flag en App State)
        } else {
            alertTitle = "Error"
            alertMessage = "Correo o contraseña incorrectos."
            showingAlert = true
        }
    }
}

