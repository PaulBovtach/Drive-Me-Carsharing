//
//  BookingDetailView.swift
//  Drive Me
//
//  Created by Paul Bovtach on 28.03.2026.
//

import SwiftUI

struct BookingDetailView: View {
    let booking: Booking
    @EnvironmentObject var bookingManager: BookingsManager
    @Environment(\.dismiss) var dismiss
    
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
            
            VStack(spacing: 20) {
                // Іконка статусу
                Image(systemName: booking.status == "pending" ? "clock.fill" : "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(booking.status == "pending" ? .orange : .green)
                
                
                Text(booking.status == "pending" ? "Waiting to confirm" : "Confirmed")
                    .foregroundStyle(.white)
                    .font(.title2)
                    .bold()
                
                Divider()
                
                // Деталі
                VStack(alignment: .leading, spacing: 12) {
                    DetailRow(title: "Car ID", value: booking.carId.uuidString.prefix(8).description)
                    DetailRow(title: "Brand/Model", value: "\(booking.car?.brand ?? "<brand>") \(booking.car?.model ?? "<model>")")
                    
                    DetailRow(title: "Rent Start", value: booking.startDate.formatted(date: .abbreviated, time: .omitted))
                    
                    DetailRow(title: "Rent End", value: booking.endDate.formatted(date: .abbreviated, time: .omitted))
                    
                    DetailRow(title: "Amount to pay", value: "\(booking.cost) $")
                }
                .padding()
                .background(Color.gray.opacity(0.15))
                .cornerRadius(12)
                
                
                Button{
                    Task{
                        await bookingManager.deleteMyBooking(bookingId: booking.id)
                        dismiss()
                        
                    }
                    
                }label: {
                    HStack{
                        Image(systemName: "xmark.circle")
                            .font(.title2)
                        Text("Delete Booking")
                    }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .padding(.horizontal, 24)
                .buttonStyle(.glass)
                .environment(\.colorScheme, .dark)
                Spacer()
            }
            .padding()
            .navigationTitle("Booking details")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .foregroundStyle(.white)
                .bold()
        }
    }
}

#Preview {
    BookingDetailView(booking: Booking(id: UUID(), clientId: UUID(), carId: UUID(), startDate: Date(), endDate: Date(), status: "pending", cost: 100))
}
