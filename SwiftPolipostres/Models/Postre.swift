
import Foundation

struct Postre: Identifiable, Codable {
    let id = UUID()
    var nombre: String
    var stock: Int
    var fechaCreacion: Date
}
