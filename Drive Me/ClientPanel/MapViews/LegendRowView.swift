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
            MapMarkerIconView(color: color, icon: icon)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.white)
        }
    }
}
