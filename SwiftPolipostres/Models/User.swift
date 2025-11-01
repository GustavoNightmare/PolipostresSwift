//
//  User.swift
//  SwiftPolipostres
//
//  Created by Telematica on 1/11/25.
//

import Foundation

struct User: Codable, Identifiable {
    let id: UUID
    var name: String
    var email: String
    var password: String
}
