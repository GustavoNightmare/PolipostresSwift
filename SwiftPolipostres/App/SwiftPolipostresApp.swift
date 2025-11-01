//
//  SwiftPolipostresApp.swift
//  SwiftPolipostres
//
//  Created by Telematica on 1/11/25.
//
import SwiftUI

@main
struct SwiftPolipostresApp: App {
    @StateObject private var auth = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(auth)
        }
    }
}
