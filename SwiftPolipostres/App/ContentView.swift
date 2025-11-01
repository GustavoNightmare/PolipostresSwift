//
//  ContentView.swift
//  SwiftPolipostres
//
//  Created by Telematica on 1/11/25.
//
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var auth: AuthViewModel

    var body: some View {
        Group {
            if auth.currentUser == nil {
                NavigationStack { LoginView() }
            } else {
                MainTabView()
            }
        }
    }
}

#Preview {
    ContentView().environmentObject(AuthViewModel())
}

