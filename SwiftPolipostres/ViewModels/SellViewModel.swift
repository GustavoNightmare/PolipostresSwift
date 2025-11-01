import Foundation
import SwiftUI

final class SellViewModel: ObservableObject {
    @Published var items: [Postre] = []
    @Published var toastMessage: String?

    private let repo: InventoryRepository
    private var inventoryObserver: NSObjectProtocol?

    init(repo: InventoryRepository = FileInventoryRepository()) {
        self.repo = repo
        load()
        // 🔄 si inventario cambia (vía eliminar o agregar stock), recargo
        inventoryObserver = NotificationCenter.default.addObserver(
            forName: .inventoryDidChange,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.load()
        }
    }

    deinit {
        if let ob = inventoryObserver { NotificationCenter.default.removeObserver(ob) }
    }

    func load() { items = repo.getAll() }

    private func persist() { try? repo.saveAll(items) } // emite notificación

    func sellOne(_ item: Postre) {
        guard let idx = items.firstIndex(of: item) else { return }
        guard items[idx].stock > 0 else { return }
        items[idx].stock -= 1
        items[idx].sold += 1
        persist()
        showToast("Vendido 1 de \(items[idx].nombre) ✅")
    }

    private func showToast(_ text: String) {
        withAnimation { toastMessage = text }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            withAnimation { self.toastMessage = nil }
        }
    }
}

