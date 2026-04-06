//
//  ConfirmBookingView.swift
//  Drive Me
//
//  Created by Paul Bovtach on 06.04.2026.
//

import SwiftUI
import Supabase

struct ConfirmBookingView: View {
    let car: Car
    let startDate: Date
    let endDate: Date
    
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var bookingManager: BookingsManager
    @Environment(\.dismiss) var dismiss
    
    // Обчислюємо кількість днів та вартість
    var totalDays: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        return (components.day ?? 0) + 1
    }
    
    var totalCost: Int {
        return (car.pricePerDay ?? 0) * totalDays
    }

    var body: some View {
        ZStack {
            // Фоновий градієнт (такий самий, як в деталях)
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 50/255, green: 80/255, blue: 40/255),
                    Color(red: 35/255, green: 60/255, blue: 25/255),
                    Color(red: 20/255, green: 40/255, blue: 15/255)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // 1. Карусель зображень
                    ImageCardCarousel(car: car)
                    
                    // 2. Деталі бронювання
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Booking Summary")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Dates")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text("\(startDate.formatted(date: .abbreviated, time: .omitted)) - \(endDate.formatted(date: .abbreviated, time: .omitted))")
                                    .foregroundColor(.white)
                                    .fontWeight(.medium)
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("Duration")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text("\(totalDays) days")
                                    .foregroundColor(.white)
                                    .fontWeight(.medium)
                            }
                        }
                        
                        Divider().background(Color.white.opacity(0.2))
                        
                        HStack {
                            Text("Total Price")
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(totalCost) $")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                        }
                    }
                    .padding()
                    .glassEffect()
                    .padding(.horizontal)
                    
                    // 3. Основна інформація про авто
                    VStack(alignment: .leading, spacing: 16) {
                        Text("\(car.brand ?? "") \(car.model ?? "")")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        
                        HStack(spacing: 12) {
                            if let year = car.year { BadgeView(icon: "calendar", text: String(year)) }
                            if let transmission = car.transmissionType { BadgeView(icon: "gearshape", text: transmission) }
                            if let fuelType = car.fuelType { BadgeView(icon: "fuelpump", text: fuelType)}
                        }
                        .foregroundStyle(.white)
                        
                        HStack(spacing: 12){
                            if let consumption = car.consumption { BadgeView(icon: "leaf.fill", text: "\(String(format: "%.1f", consumption)) l / 100 km")}
                            if let pricePerDay = car.pricePerDay { BadgeView(icon: "dollarsign", text: "\(pricePerDay)") }
                        }
                        .foregroundStyle(.white)
                        
                        Text("Description")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text("You are about to book this car for the selected period. Please confirm the details above.")
                            .foregroundColor(.white.opacity(0.8))
                            .font(.subheadline)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 120)
                }
            }
            
            
            .overlay(alignment: .bottom) {
                Button(action: {
                    confirmBooking()
                }) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Confirm Booking")
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
        .navigationTitle("Confirm Booking")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func confirmBooking() {
        guard let userId = authManager.currentUserProfile?.id else { return }
        
        let newBooking = Booking(
            id: UUID(),
            clientId: userId,
            carId: car.id,
            startDate: startDate,
            endDate: endDate,
            status: "pending",
            cost: totalCost
        )
        
        Task {
            do {
                try await supabase.from("bookings").insert(newBooking).execute()
                print("Booking created successfully!")
                
                await bookingManager.fetchMyBookings(userId: userId)
                
                dismiss()
            } catch {
                print("Error creating booking: \(error.localizedDescription)")
            }
        }
    }
}


