//
//  BookingDetailView.swift
//  Drive Me
//
//  Created by Paul Bovtach on 28.03.2026.
//

import SwiftUI
import SwiftUICarousel // Не забудьте імпортувати, якщо карусель цього вимагає

struct BookingDetailView: View {
    let booking: Booking
    @EnvironmentObject var bookingManager: BookingsManager
    @Environment(\.dismiss) var dismiss
    
    @State private var showDeletionAlert = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 50/255, green: 80/255, blue: 40/255),   // Top
                    Color(red: 35/255, green: 60/255, blue: 25/255),   // Middle
                    Color(red: 20/255, green: 40/255, blue: 15/255)    // Bottom
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    if let car = booking.car {
                        ImageCardCarousel(car: car)
                    } else {
                        ZStack {
                            Color.black.opacity(0.3)
                            Image(systemName: "car.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .frame(height: 300)
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        
                        Text("\(booking.car?.brand ?? "Unknown") \(booking.car?.model ?? "")")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: statusIcon(booking.status))
                                .font(.title2)
                                .foregroundColor(statusColor(booking.status))
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Status: \(booking.status.capitalized)")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                if booking.status.lowercased() == "rejected", let reason = booking.rejectionReason {
                                    Text("Reason: \(reason)")
                                        .font(.subheadline)
                                        .foregroundColor(.red.opacity(0.9))
                                } else if booking.status.lowercased() == "pending" {
                                    Text("Waiting for administrator approval.")
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.7))
                                }
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.black.opacity(0.2))
                        .cornerRadius(12)
                        
                        
                        VStack(alignment: .leading, spacing: 12) {
                            DetailRow(icon: "calendar.badge.clock", title: "Pick-up", value: booking.startDate.formatted(date: .abbreviated, time: .omitted))
                            
                            DetailRow(icon: "calendar.badge.clock", title: "Return", value: booking.endDate.formatted(date: .abbreviated, time: .omitted))
                            
                            Divider().background(Color.white.opacity(0.2))
                            
                            HStack {
                                Image(systemName: "dollarsign.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.title3)
                                Text("Total Cost")
                                    .foregroundColor(.gray)
                                Spacer()
                                Text("\(String(booking.cost)) $")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                            }
                            .padding(.top, 4)
                        }
                        .padding()
                        .background(Color.black.opacity(0.2))
                        .cornerRadius(12)
                        
                        
                        Divider()
                            .padding(.vertical, 8)
                        
                        
                        if let car = booking.car {
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
                            .padding(.top, 8)
                            
                            if let consumption = car.consumption {
                                HStack(spacing: 8) {
                                    Image(systemName: "leaf.fill")
                                        .foregroundColor(.green)
                                    Text("Consumption: \(String(format: "%.1f", consumption)) l / 100 km")
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                }
                                .padding(.top, 4)
                            }
                            
                            Divider()
                                .padding(.vertical, 8)
                            
                            Text("Car description")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                            
                            Text("A great car for comfortable trips. Ideal for both the city and for traveling. Regular maintenance ensures your safety on the road.")
                                .foregroundColor(.white)
                                .lineSpacing(3)
                            
                        }
                    }
                    .padding(.horizontal)
                    
                }
                .padding(.bottom, 100)
                .padding(.top, 8)
            }
            .navigationTitle("Booking Details")
            .navigationBarTitleDisplayMode(.inline)
            .overlay(alignment: .bottom) {
                Button(action: {
                    showDeletionAlert = true
                }) {
                    HStack {
                        Image(systemName: "trash")
                        Text("Delete Booking")
                            .fontWeight(.bold)
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red.opacity(0.85))
                    .cornerRadius(40)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                }
                .buttonStyle(BouncyGlassButtonStyle())
            }
            
        }
        .alert("Delete booking", isPresented: $showDeletionAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                Task {
                    await bookingManager.deleteMyBooking(bookingId: booking.id)
                    dismiss()
                }
            }
        } message: {
            Text("Are you sure you want to delete this booking?")
        }
    }
    
    
    private func statusColor(_ status: String) -> Color {
        switch status.lowercased() {
        case "pending": return .orange
        case "approved", "confirmed": return .green
        case "rejected", "cancelled": return .red
        default: return .gray
        }
    }
    
    private func statusIcon(_ status: String) -> String {
        switch status.lowercased() {
        case "pending": return "clock.fill"
        case "approved", "confirmed": return "checkmark.circle.fill"
        case "rejected", "cancelled": return "xmark.circle.fill"
        default: return "questionmark.circle.fill"
        }
    }
}

struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 24)
            Text(title)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .foregroundStyle(.white)
                .fontWeight(.medium)
        }
    }
}
