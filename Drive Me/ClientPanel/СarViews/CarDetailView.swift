//
//  CarDetailView.swift
//  Drive Me
//
//  Created by Paul Bovtach on 24.03.2026.
//

import SwiftUI
import SwiftUICarousel

struct CarDetailView: View {
    let car: Car
    
    @State private var showBookingSheet = false
    @EnvironmentObject var bookingManager: BookingsManager
    
    var body: some View {
        ZStack{
            
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 50/255, green: 80/255, blue: 40/255),   // Top: Warm, earthy forest green
                    Color(red: 35/255, green: 60/255, blue: 25/255),   // Middle: Deeper forest mid-tone
                    Color(red: 20/255, green: 40/255, blue: 15/255)    // Bottom: Very dark, shadowed underbrush
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // MARK: - 1. Images Carousele Card
                    ImageCardCarousel(car: car)
                    
                    // MARK: - 2. Main Information
                    VStack(alignment: .leading, spacing: 16) {
                        
                        Text("\(car.brand ?? "Unknown") \(car.model ?? "")")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        
                        HStack(spacing: 12) {
                            if let year = car.year {
                                BadgeView(icon: "calendar", text: String(year))
                            }
                            if let transmission = car.transmissionType {
                                BadgeView(icon: "gearshape", text: transmission)
                            }
                            if let fuel = car.fuelType {
                                BadgeView(icon: "fuelpump", text: fuel)
                            }
                        }
                        .foregroundStyle(.white)
                        
                        
                        if let consumption = car.consumption {
                            HStack(spacing: 8) {
                                Image(systemName: "leaf.fill")
                                    .foregroundColor(.green)
                                Text("Consumption: \(String(format: "%.1f", consumption)) l / 100 km")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                            }
                            .padding(.top, 8)
                        }
                        
                        if let price = car.pricePerDay {
                            HStack(spacing: 8) {
                                Image(systemName: "wallet.bifold.fill")
                                    .foregroundColor(.green)
                                Text("Price: \(price)$ per day")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                            }
                            .padding(.top, 8)
                        }
                        
                        Divider()
                            .padding(.vertical, 8)
                            .foregroundStyle(.myGreen)
                        
                        Text("Car description")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                        
                        Text("A great car for comfortable trips. Ideal for both the city and for traveling. Regular maintenance ensures your safety on the road.")
                            .foregroundColor(.white)
                            .lineSpacing(3)
                    }
                    .padding(.horizontal)
                    
                }
                .padding(.bottom, 100)
                .padding(.top, 8)
            }
            .navigationTitle("Details")
            
            
            // MARK: - 3. Кнопка "Забронювати" внизу екрану
            .overlay(alignment: .bottom) {
                Button(action: {
                    print("Reserve \(car.brand ?? "")")
                    showBookingSheet = true
                }) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Book car now!")
                            .fontWeight(.bold)
                    }
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(40)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                }
                .buttonStyle(BouncyGlassButtonStyle())
            }
            
        }
        .sheet(isPresented: $showBookingSheet) {
            BookingCalendarView(car: car)
                .environmentObject(bookingManager)
        }
    }
}



//MARK: - Carousel of images
struct ImageCardCarousel: View {
    let car: Car
    @State private var currentIndex = 0
    var body: some View {
        if let imageUrls = car.imageUrls, !imageUrls.isEmpty {
            SwiftUICarousel(imageUrls, id: \.self,
                            index: $currentIndex,
                            showIndicators: true,
                            indicatorActiveColor: .green,
                            indicatorInactiveColor: .gray.opacity(0.3)){ img in
                
                AsyncImage(url: URL(string: img)) { phase in
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
                .glassEffect()
            }
                            .frame(height: 300)
                            .id(imageUrls)
                            .onChange(of: imageUrls) {
                                withAnimation {
                                    currentIndex = 0
                                }
                            }
            
        } else {
            
            Image(systemName: "photo")
                .font(.system(size: 50))
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                .foregroundColor(.gray)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                .glassEffect()
                .padding(.horizontal)
        }
        
        
    }
    
    
    
}

struct BadgeView: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
            Text(text)
        }
        .font(.subheadline)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.gray.opacity(0.15))
        .cornerRadius(10)
    }
}

struct BouncyGlassButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
        
            .scaleEffect(configuration.isPressed ? 0.85 : 1.0)
        
            .opacity(configuration.isPressed ? 0.8 : 1.0)
        
            .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0), value: configuration.isPressed)
    }
}
