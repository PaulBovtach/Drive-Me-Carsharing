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
        HStack(spacing: 12) {
            ZStack {
                Image(systemName: "triangle.fill")
                    .resizable()
                    .frame(width: 12, height: 9)
                    .rotationEffect(.degrees(180))
                    .foregroundStyle(.black.gradient)
                    .offset(y: 12)
                
                Circle()
                    .fill(color.gradient)
                    .frame(width: 24, height: 24)
                    .overlay(
                        Circle().stroke(Color.black, lineWidth: 1.5)
                    )
                
                Image(systemName: icon)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.white)
            }
            .frame(width: 24, height: 32)
            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.white)
        }
    }
}
