//
//  CarRowView.swift
//  Drive Me
//
//  Created by Paul Bovtach on 24.03.2026.
//

import SwiftUI

struct CarRowView: View {
    let car: Car
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // 1. image block
            if let firstImageUrlString = car.imageUrls?.first,
               let imageUrl = URL(string: firstImageUrlString) {
                
                AsyncImage(url: imageUrl) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.1))
                        
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .clipped()
                            .cornerRadius(12)
                    case .failure:
                        Image(systemName: "car.fill")
                            .font(.system(size: 50))
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.gray)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "photo")
                    .font(.system(size: 50))
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.gray)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
            }
            
            // 2. text block
            VStack(alignment: .leading, spacing: 8) {
                Text("\(car.brand ?? "Unknown") \(car.model ?? "")")
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.white)
                
                HStack {
                    
                    if let year = car.year {
                        Label(String(year), systemImage: "calendar")
                    }
                    
                    Spacer()
                    
                    if let transmission = car.transmissionType {
                        Label(transmission, systemImage: "gearshape")
                    }
                    
                    Spacer()
                    if let fuel = car.fuelType {
                        Label(fuel, systemImage: "fuelpump")
                    }
                }
                .font(.subheadline)
                .foregroundColor(.white)
            }
            .padding(.horizontal, 4)
            .padding(.bottom, 4)
        }
    }
}

