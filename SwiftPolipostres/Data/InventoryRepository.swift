//
//  InventoryRepository.swift
//  SwiftPolipostres
//
//  Created by Telematica on 1/11/25.
//

import Foundation

extension Notification.Name {
    static let inventoryDidChange = Notification.Name("inventoryDidChange")
}

protocol InventoryRepository {
    func getAll() -> [Postre]
    func saveAll(_ items: [Postre]) throws
}

final class FileInventoryRepository: InventoryRepository {
    private let file = "inventory.json"

    func getAll() -> [Postre] {
        LocalFileStore.read(file) ?? []
    }

    func saveAll(_ items: [Postre]) throws {
        try LocalFileStore.write(items, to: file)
        NotificationCenter.default.post(name: .inventoryDidChange, object: nil) // 👈 avisa cambios
    }
}

