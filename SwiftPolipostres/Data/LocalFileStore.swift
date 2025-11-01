//
//  LocalFileStore.swift
//  SwiftPolipostres
//
//  Created by Telematica on 1/11/25.
//
import Foundation

enum LocalFileStore {
    static var documentsURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    static func read<T: Decodable>(_ filename: String, as type: T.Type = T.self) -> T? {
        let url = documentsURL.appendingPathComponent(filename)
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("LocalFileStore read error:", error)
            return nil
        }
    }

    static func write<T: Encodable>(_ value: T, to filename: String) throws {
        let url = documentsURL.appendingPathComponent(filename)
        let data = try JSONEncoder().encode(value)
        try data.write(to: url, options: .atomic)
    }
}
extension LocalFileStore {
    static func writeData(_ data: Data, to filename: String) throws {
        let url = documentsURL.appendingPathComponent(filename)
        try data.write(to: url, options: .atomic)
    }

    static func readData(_ filename: String) -> Data? {
        let url = documentsURL.appendingPathComponent(filename)
        return try? Data(contentsOf: url)
    }
}
extension LocalFileStore {
    static func deleteFile(_ filename: String) {
        let url = documentsURL.appendingPathComponent(filename)
        try? FileManager.default.removeItem(at: url)
    }
}

