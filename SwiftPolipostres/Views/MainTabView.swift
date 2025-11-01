//
//  MainTabView.swift
//  SwiftPolipostres
//
//  Created by Telematica on 1/11/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            InventoryView()
                .tabItem {
                    Label("Inventario", systemImage: "list.bullet")
                }
            
            Text("Vender")
                .tabItem {
                    Label("Vender", systemImage: "cart")
                }
            
            Text("Métricas")
                .tabItem {
                    Label("Métricas", systemImage: "chart.bar")
                }
        }
        .accentColor(AppTheme.primary)
    }
}

#Preview {
    MainTabView()
}
