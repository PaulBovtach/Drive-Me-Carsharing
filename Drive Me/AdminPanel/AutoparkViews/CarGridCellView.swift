//
//  CarGridCellView.swift
//  Drive Me
//
//  Created by Paul Bovtach on 16.04.2026.
//

import SwiftUI

struct CarGridCellView: View {
    let car: Car
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            ZStack(alignment: .topTrailing) {
                if let firstImageUrlString = car.imageUrls?.first,
                   let url = URL(string: firstImageUrlString) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            placeholderView
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                        case .failure:
                            placeholderView
                        @unknown default:
                            placeholderView
                        }
                    }
                    .frame(height: 120)
                    .clipped()
                } else {
                    placeholderView
                        .frame(height: 120)
                }
                
                statusBadge
                    .padding(8)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(car.brand ?? "None")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(car.model ?? "None")
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text("\(car.pricePerDay ?? 100) $/day")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                    .padding(.top, 4)
            }
            .padding(12)
        }
        .background(Color.black.opacity(0.3))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
    
    private var placeholderView: some View {
        ZStack {
            Color.gray.opacity(0.2)
            Image(systemName: "car.fill")
                .font(.largeTitle)
                .foregroundColor(.gray.opacity(0.5))
        }
    }
    
    private var statusBadge: some View {
        Circle()
            .fill(car.isAvailable ? Color.green : Color.red)
            .frame(width: 12, height: 12)
            .overlay(Circle().stroke(Color.black.opacity(0.3), lineWidth: 2))
            .shadow(color: car.isAvailable ? .green.opacity(0.5) : .red.opacity(0.5), radius: 3)
    }
}

