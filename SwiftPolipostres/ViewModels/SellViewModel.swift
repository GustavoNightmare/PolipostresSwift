//
//  SellViewModel.swift
//  SwiftPolipostres
//
//  Created by Telematica on 1/11/25.
//

import Foundation
import SwiftUI

final class SellViewModel: ObservableObject {
    @Published var items: [Postre] = []
    @Published var toastMessage: String? = nil

    private let repo: InventoryRepository

    init(repo: InventoryRepository = UserDefaultsInventoryRepository()) {
        self.repo = repo
        load()
        if items.isEmpty { seed() }
    }

    func load() {
        items = repo.getAll()
    }

    private func persist() {
        try? repo.saveAll(items)
    }

    func addOne(_ item: Postre) {
        guard let idx = items.firstIndex(of: item) else { return }
        items[idx].stock += 1
        persist()
    }

    func sellOne(_ item: Postre) {
        guard let idx = items.firstIndex(of: item) else { return }
        guard items[idx].stock > 0 else { return }
        items[idx].stock -= 1
        persist()
        showToast("Vendido 1 de \(items[idx].nombre) ✅")
    }

    private func showToast(_ text: String) {
        withAnimation { toastMessage = text }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            withAnimation { self.toastMessage = nil }
        }
    }

    /// Datos de ejemplo iniciales (como tu screenshot de Android)
    private func seed() {
        items = [
            Postre(id: UUID(), nombre: "gustavo", stock: 33),
            Postre(id: UUID(), nombre: "rico farid", stock: 22),
            Postre(id: UUID(), nombre: "sabroson Gustavo", stock: 22),
            Postre(id: UUID(), nombre: "yamm Fabio", stock: 22),
        ]
        persist()
    }
}
