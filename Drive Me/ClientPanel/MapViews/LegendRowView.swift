//
//  LegendRowView.swift
//  Drive Me
//
//  Created by Paul Bovtach on 06.04.2026.
//

import SwiftUI

struct LegendRow: View {
    let color: Color
    let icon: String
    let text: String
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(color)
                .frame(width: 20, height: 20)
                .overlay(Image(systemName: icon).font(.system(size: 10, weight: .bold)).foregroundColor(.white))
            Text(text)
                .font(.subheadline)
                .foregroundColor(.white)
        }
    }
}
