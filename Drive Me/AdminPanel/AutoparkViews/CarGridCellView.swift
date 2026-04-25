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
                            ProgressView()
                                .frame(height: 100)
                                .frame(maxWidth: .infinity)
                                .background(Color.gray.opacity(0.1))
                            
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 100)
                                .frame(maxWidth: 150)
                                .clipped()
                                .cornerRadius(12)
                        case .failure:
                            Image(systemName: "car.fill")
                                .font(.system(size: 25))
                                .frame(height: 100)
                                .frame(maxWidth: 150)
                                .foregroundColor(.gray)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(12)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    
                }else {
                    Image(systemName: "car.fill")
                        .font(.system(size: 25))
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.gray)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .center){
                    Text(car.brand ?? "None")
                        .font(.headline)
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    Text(car.model ?? "None")
                        .font(.headline)
                        .foregroundColor(.white)
                        .lineLimit(1)
                }
                
                Text("\(car.pricePerDay ?? 100) $/day")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                    .padding(.top, 3)
                
                Text(car.isAvailable ? "AVAILABLE" : "UNAVAILABLE")
                    .font(.caption).bold()
                    .padding(.horizontal, 8).padding(.vertical, 4)
                    .background(car.isAvailable ? .green.opacity(0.2) : .red.opacity(0.2))
                    .foregroundStyle(car.isAvailable ? .green : .red)
                    .clipShape(Capsule())
            }
            .padding(4)
        }
    }
    
    
    
    
}




