import Foundation
import SwiftUI

final class InventoryViewModel: ObservableObject {
    @Published var items: [Postre] = []
    @Published var name: String = ""
    @Published var stockText: String = ""
    @Published var toastMessage: String?
    @Published var hideList = false
    @Published var newImageData: Data? = nil

    private let repo: InventoryRepository
    private var inventoryObserver: NSObjectProtocol?

    init(repo: InventoryRepository = FileInventoryRepository()) {
        self.repo = repo
        load()
        Seed.inventoryIfEmpty(repo: repo)
        load()

        // 🔄 Reactivo: recarga cuando cualquier parte de la app cambie inventario
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

    func load() {
        items = repo.getAll()
    }

    func addItem() {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let stock = Int(stockText) ?? 0

        var list = repo.getAll()
        let newId = UUID()
        var imageFile: String? = nil

        if let data = newImageData {
            let filename = "postre-\(newId.uuidString).jpg"
            try? LocalFileStore.writeData(data, to: filename)
            imageFile = filename
        }

        list.append(Postre(id: newId, nombre: trimmed, stock: stock, sold: 0, createdAt: Date(), imageFilename: imageFile))
        try? repo.saveAll(list)
        name = ""; stockText = ""; newImageData = nil
        load()
        showToast("Guardado postre ✅")
    }

    func increment(_ item: Postre) {
        guard let idx = items.firstIndex(of: item) else { return }
        items[idx].stock += 1
        try? repo.saveAll(items)     // notifica a Vender/Métricas
        showToast("Stock +1 de \(items[idx].nombre)")
    }

    // 🗑️ Eliminar postre (y su imagen)
    func delete(_ item: Postre) {
        guard let idx = items.firstIndex(of: item) else { return }
        if let img = items[idx].imageFilename { LocalFileStore.deleteFile(img) }
        items.remove(at: idx)
        try? repo.saveAll(items)     // notifica a Vender/Métricas
        showToast("Eliminado \(item.nombre)")
    }

    func showToast(_ text: String) {
        withAnimation { toastMessage = text }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            withAnimation { self.toastMessage = nil }
        }
    }
}

