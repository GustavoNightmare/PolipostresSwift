//
//  ToastView.swift
//  SwiftPolipostres
//
//  Created by Telematica on 1/11/25.
//
import SwiftUI

struct ToastView: View {
    let message: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.seal.fill")
                .imageScale(.medium)
            Text(message)
                .lineLimit(1)
                .font(.subheadline)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .shadow(radius: 8)
    }
}

