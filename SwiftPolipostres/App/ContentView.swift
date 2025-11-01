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
                MainTabView()
            }
        }
    }


#Preview {
    ContentView().environmentObject(AuthViewModel())
}
