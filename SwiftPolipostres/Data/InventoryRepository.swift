//
//  InventoryRepository.swift
//  SwiftPolipostres
//
//  Created by Telematica on 1/11/25.
//

import Foundation

protocol InventoryRepository {
    func getAll() -> [Postre]
    func saveAll(_ items: [Postre]) throws
}

final class UserDefaultsInventoryRepository: InventoryRepository {
    private let key = "inventory_items"

    func getAll() -> [Postre] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        return (try? JSONDecoder().decode([Postre].self, from: data)) ?? []
    }

    func saveAll(_ items: [Postre]) throws {
        let data = try JSONEncoder().encode(items)
        UserDefaults.standard.set(data, forKey: key)
    }
}
