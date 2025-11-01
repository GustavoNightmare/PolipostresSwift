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
          
            NavigationStack { SellView() }
                .tabItem { Image(systemName: "list.bullet.rectangle"); Text("Vender") }

            NavigationStack { MetricsView() }
                .tabItem { Image(systemName: "chart.bar"); Text("Métricas") }
        }
        .tint(AppColors.pink)
    }
}

#Preview { MainTabView() }
