//
//  UserRepository.swift
//  SwiftPolipostres
//
//  Created by Telematica on 1/11/25.
//

import Foundation

protocol UserRepository {
    func save(_ user: User) throws
    func load() -> User?
    func clear()
}

final class UserDefaultsUserRepository: UserRepository {
    private let key = "registered_user"

    func save(_ user: User) throws {
        let data = try JSONEncoder().encode(user)
        UserDefaults.standard.set(data, forKey: key)
    }

    func load() -> User? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(User.self, from: data)
    }

    func clear() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
