//
//  LoginView.swift
//  SwiftPolipostres
//
//  Created by Telematica on 1/11/25.
//

import SwiftUI

struct LoginView: View {

        var body: some View {
            NavigationStack {
                ZStack {
                    AppColors.background.ignoresSafeArea()

                    VStack(spacing: 24) {
                        Text("Inicio")
                            .font(.largeTitle).bold()
                            .foregroundColor(AppColors.text)

                        NavigationLink {
                            SellView()         // ← destino
                        } label: {
                            Text("Ir a Vender")
                                .bold()
                                .frame(maxWidth: .infinity, minHeight: 56)
                                .background(AppColors.pink)
                                .foregroundColor(.black)
                                .clipShape(Capsule())
                                .padding(.horizontal, 24)
                        }
                    }
                }
            }
        }
    }


#Preview {
    NavigationStack { LoginView() }
}
