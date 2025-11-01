
//
//  Postre.swift
//  SwiftPolipostres
//
//  Created by Telematica on 1/11/25.
//
import Foundation

struct Postre: Codable, Identifiable, Equatable {
    let id: UUID
    var nombre: String
    var stock: Int
    var sold: Int
    var createdAt: Date
    var imageFilename: String?    // 👈 NUEVO (opcional)

    static func ==(lhs: Postre, rhs: Postre) -> Bool { lhs.id == rhs.id }
}
