//
//  InventoryViewModel.swift
//  SwiftPolipostres
//
//  Created by Telematica on 1/11/25.
//

import Foundation

final class InventoryViewModel: ObservableObject {
    @Published var items: [Postre] = []
    @Published var name: String = ""
    @Published var stockText: String = ""
    @Published var toastMessage: String?
    @Published var hideList = false

    private let repo: InventoryRepository

    init(repo: InventoryRepository = FileInventoryRepository()) {
        self.repo = repo
        load()
        Seed.inventoryIfEmpty(repo: repo)    // opcional
        load()
    }

    func load() {
        items = repo.getAll()
    }

    func addItem() {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let stock = Int(stockText) ?? 0
        var list = repo.getAll()
        list.append(Postre(id: UUID(), nombre: name, stock: stock, sold: 0, createdAt: Date()))
        try? repo.saveAll(list)
        name = ""
        stockText = ""
        load()
        showToast("Guardado postre ✅")
    }

    func showToast(_ text: String) {
        withAnimation { toastMessage = text }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            withAnimation { self.toastMessage = nil }
        }
    }
}

