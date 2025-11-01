//
//  AppTheme.swift
//  SwiftPolipostres
//
//  Created by Telematica on 1/11/25.
//

import SwiftUI

// Colores de la app (oscuro + rosa)
enum AppColors {
    static let background = Color(hex: 0x1F1719)   // fondo oscuro
    static let surface    = Color(hex: 0x2A2022)   // tarjetas/campos
    static let pink       = Color(hex: 0xF7B2C6)   // botón
    static let text       = Color.white.opacity(0.92)
    static let hint       = Color.white.opacity(0.6)
}

// Helper para colores HEX
extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        let r = Double((hex >> 16) & 0xff) / 255.0
        let g = Double((hex >> 8)  & 0xff) / 255.0
        let b = Double(hex & 0xff) / 255.0
        self.init(.sRGB, red: r, green: g, blue: b, opacity: alpha)
    }
}

// Estilo de campo (borde suave)
struct FieldBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 16)
            .frame(height: 56)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.surface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
            )
            .foregroundColor(AppColors.text)
    }
}

extension View {
    func fieldStyle() -> some View { modifier(FieldBackground()) }
}
