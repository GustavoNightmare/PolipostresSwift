//
//  PostreRowView.swift
//  SwiftPolipostres
//
//  Created by Telematica on 1/11/25.
//
import SwiftUI

struct PostreRowView: View {
    let item: Postre
    let onAdd: () -> Void
    let onSell: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.nombre).font(.headline).lineLimit(1).foregroundColor(AppColors.text)
                Text("Stock: \(item.stock)").font(.subheadline).foregroundColor(AppColors.hint)
            }
            Spacer()
            Button(action: onAdd) {
                ZStack {
                    Circle().stroke(AppColors.hint, lineWidth: 1.4).frame(width: 36, height: 36)
                    Image(systemName: "plus").foregroundColor(AppColors.text)
                }
            }
            Button(action: onSell) {
                HStack(spacing: 8) {
                    Image(systemName: "cart.fill")
                    Text("Vender 1").bold()
                }
                .padding(.horizontal, 14)
                .frame(height: 36)
                .background(AppColors.pink)
                .foregroundColor(.black)
                .clipShape(Capsule())
            }
            .disabled(item.stock == 0)
            .opacity(item.stock == 0 ? 0.5 : 1)
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 16).fill(AppColors.surface))
    }
}
