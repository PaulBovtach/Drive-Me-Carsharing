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
                        
                        HStack(spacing: 8) {
                            Image(systemName: car.isAvailable == true ? "checkmark.seal.fill" : "xmark.seal.fill")
                                .foregroundColor( car.isAvailable == true ? .green : .red)
                            
                            if car.isAvailable {
                                Text("Available for rent now")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                            }else {
                                Text("Unavailable for rent now, try another car or give glance at calandar")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                            }
                            
                            
                        }
                        .padding(.top, 8)
                        
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
                ReserveButton(car: car)
            }
            
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
                            indicatorActiveColor: .green, // Замінив .myGreen на .green (виправте, якщо маєте кастомний колір)
                            indicatorInactiveColor: .gray.opacity(0.3)){ img in
                
                AsyncImage(url: URL(string: img)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: 200) // Трохи збільшив висоту для екрану деталей
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
            
        } else {
            // Плейсхолдер, якщо картинок немає
            Image(systemName: "photo")
                .font(.system(size: 50))
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                .foregroundColor(.gray)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
        }
    }
}

// MARK: - Допоміжний компонент для характеристик
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





// MARK: - Custom Button Style
struct ReserveButton: View {
    let car: Car
    @EnvironmentObject var bookingManager: BookingsManager
    
    @State private var showBookingSheet = false
    
    var body: some View {
        Button(action: {
            print("Reserve \(car.brand ?? "")")
            showBookingSheet = true
        }) {
            // Внутрішній контент кнопки
            HStack {
                // Кругла іконка зліва (як на скріншоті)
                ZStack {
                    Circle()
                        .fill(Color.black.opacity(0.3))
                        .frame(width: 44, height: 44)
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .bold))
                }
                
                Spacer()
                Text("Reserve Now")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
                
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial)
            .environment(\.colorScheme, .dark)
            // Додаємо легкий зелений відтінок склу
            .background(Color.greenBackground.opacity(0.3))
            .cornerRadius(40) // Сильне заокруглення (pill shape)
            // Легка біла рамка зверху для ефекту об'єму (скла)
            .overlay(
                RoundedRectangle(cornerRadius: 40)
                    .stroke(Color.white.opacity(0.4), lineWidth: 1)
            )
        }
        // Застосовуємо наш кастомний стиль з анімацією
        .buttonStyle(BouncyGlassButtonStyle())
        
        .padding(.horizontal, 24)
        .padding(.bottom, 32)
        
        // Фоновий градієнт екрану (щоб текст під кнопкою плавно зникав)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 20/255, green: 40/255, blue: 15/255).opacity(0),
                    Color(red: 20/255, green: 40/255, blue: 15/255)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .sheet(isPresented: $showBookingSheet) {
            BookingCalendarView(car: car)
                .environmentObject(bookingManager)
        }
        
    }
}



struct BouncyGlassButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
        // Якщо кнопка натиснута - зменшуємо її до 90% розміру
            .scaleEffect(configuration.isPressed ? 0.85 : 1.0)
        // Робимо її трохи прозорішою при натисканні
            .opacity(configuration.isPressed ? 0.8 : 1.0)
        // Плавна, пружиниста анімація
            .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0), value: configuration.isPressed)
    }
}
