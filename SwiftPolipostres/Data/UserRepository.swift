//
//  UserRepository.swift
//  SwiftPolipostres
//
//  Created by Telematica on 1/11/25.
//

import Foundation

protocol UserRepository {
    func register(_ user: User) throws
    func findByEmail(_ email: String) -> User?
    func all() -> [User]
    func saveSession(user: User?) throws
    func loadSession() -> User?
    func clearAll() throws   // para pruebas
}

final class FileUserRepository: UserRepository {
    private let usersFile = "users.json"
    private let sessionFile = "session.json"

    func all() -> [User] {
        LocalFileStore.read(usersFile) ?? []
    }

    func register(_ user: User) throws {
        var list = all()
        guard findByEmail(user.email) == nil else {
            throw NSError(domain: "UserRepo", code: 1, userInfo: [NSLocalizedDescriptionKey: "El correo ya está registrado"])
        }
        list.append(user)
        try LocalFileStore.write(list, to: usersFile)
    }

    func findByEmail(_ email: String) -> User? {
        all().first { $0.email.lowercased() == email.lowercased() }
    }

    func saveSession(user: User?) throws {
        if let user = user {
            try LocalFileStore.write(user, to: sessionFile)
        } else {
            try LocalFileStore.write(Optional<User>.none as User?, to: sessionFile)
        }
    }

    func loadSession() -> User? {
        LocalFileStore.read(sessionFile)
    }

    func clearAll() throws {
        try LocalFileStore.write([User](), to: usersFile)
        try LocalFileStore.write(Optional<User>.none as User?, to: sessionFile)
    }
}
