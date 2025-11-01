//
//  AuthViewModel.swift
//  SwiftPolipostres
//
//  Created by Telematica on 1/11/25.
//

import Foundation

final class AuthViewModel: ObservableObject {
    @Published var currentUser: User?
    private let userRepo: UserRepository

    init(userRepo: UserRepository = FileUserRepository()) {
        self.userRepo = userRepo
        self.currentUser = userRepo.loadSession()
    }

    func signIn(_ user: User) {
        currentUser = user
        try? userRepo.saveSession(user: user)
    }

    func signOut() {
        currentUser = nil
        try? userRepo.saveSession(user: nil)
    }
}
