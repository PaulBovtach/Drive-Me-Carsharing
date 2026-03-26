//
//  Extension.swift
//  Drive Me
//
//  Created by Paul Bovtach on 24.03.2026.
//

import Foundation
import SwiftUI

extension Color {
    public static let myGreenColor = Color("MyGreen")
}

extension Color {
    public static let greenBackground = Color("BackgroundGreen")
}

extension View {
    func glassEffect() -> some View {
        self
            .padding()
            .background(
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: 20, style: .continuous)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.white.opacity(0.25), lineWidth: 0.8)
                    .allowsHitTesting(false)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.white.opacity(0.05))
                    .allowsHitTesting(false)
            )
            .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 6)
    }
}
