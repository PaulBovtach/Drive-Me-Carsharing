//
//  RequestRowView.swift
//  Drive Me
//
//  Created by Paul Bovtach on 15.04.2026.
//

import SwiftUI

struct RequestRowView: View {
    let booking: Booking
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            HStack {
                Text("\(booking.client?.name ?? "Unknown") \(booking.client?.surname ?? "")")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(booking.status.uppercased())
                    .font(.caption).bold()
                    .padding(.horizontal, 10).padding(.vertical, 4)
                    .background(statusColor(booking.status).opacity(0.2))
                    .foregroundColor(statusColor(booking.status))
                    .clipShape(Capsule())
            }
            
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Image(systemName: "car.fill")
                        .foregroundColor(.gray)
                    Text(booking.car?.brand ?? "Unknown Car")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }
                
                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                        .foregroundColor(.gray)
                    Text("\(booking.startDate.formatted(date: .abbreviated, time: .omitted)) - \(booking.endDate.formatted(date: .abbreviated, time: .omitted))")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }
            }
        }
        .padding(14)
    }
    
    private func statusColor(_ status: String) -> Color {
        switch status.lowercased() {
        case "pending": return .orange
        case "approved": return .green
        case "rejected": return .red
        default: return .gray
        }
    }
}
#Preview {
    RequestRowView(booking: Booking(id: UUID(), clientId: UUID(), carId: UUID(), startDate: Date(), endDate: Date(), status: "pending", cost: 100))
}


