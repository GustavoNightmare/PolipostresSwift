//
//  SwiftPolipostresApp.swift
//  SwiftPolipostres
//
//  Created by Telematica on 1/11/25.
//

import SwiftUI

@main
struct SwiftPolipostresApp: App {
    // crea instancia compartida
        let userRepo = UserRepository.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
            // Antes de mostrar, creamos usuario de prueba para desarrollo
                       let vm = LoginViewModel(userRepository: userRepo)
                       LoginView(viewModel: vm)
        }
    }
}
