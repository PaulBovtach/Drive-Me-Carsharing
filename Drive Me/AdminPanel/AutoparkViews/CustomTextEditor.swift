//
//  CustomTextEditor.swift
//  Drive Me
//
//  Created by Paul Bovtach on 21.04.2026.
//

import SwiftUI
import Foundation

struct CustomTextEditor: View {
    
    @Binding var text: String
    var placeholder: String = "Enter text..."
    var minHeight: CGFloat = 120
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 16)
            }
            
            TextEditor(text: $text)
                .frame(minHeight: minHeight)
                .padding(8)
                .foregroundColor(.black)
                .scrollContentBackground(.hidden)
                .background(Color.white.opacity(0.8))
        }
        .background(Color.white.opacity(0.8))
        .clipShape(.rect(cornerRadius: 15))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.3))
        )
    }
}
