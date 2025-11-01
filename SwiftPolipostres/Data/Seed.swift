//
//  seed.swift
//  SwiftPolipostres
//
//  Created by Telematica on 1/11/25.
//

import Foundation

enum Seed {
    static func inventoryIfEmpty(repo: InventoryRepository) {
        var items = repo.getAll()
        if items.isEmpty {
            items = [
                Postre(id: UUID(), nombre: "gustavo",         stock: 33, sold: 0, createdAt: Date()),
                Postre(id: UUID(), nombre: "rico farid",       stock: 22, sold: 0, createdAt: Date()),
                Postre(id: UUID(), nombre: "sabroson Gustavo", stock: 22, sold: 0, createdAt: Date()),
                Postre(id: UUID(), nombre: "yamm Fabio",       stock: 22, sold: 0, createdAt: Date())
            ]
            // 👇 ESTA es la línea correcta
            try? repo.saveAll(items)
        }
    }
}


