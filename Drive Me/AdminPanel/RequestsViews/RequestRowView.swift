//
//  RequestRowView.swift
//  Drive Me
//
//  Created by Paul Bovtach on 15.04.2026.
//

import SwiftUI

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
        VStack(alignment: .leading, spacing: 8) {
            
            // MARK: Client and Status
            HStack {
                Text("\(booking.client?.name ?? "Unknown") \(booking.client?.surname ?? "")")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(booking.status.uppercased())
                    .font(.caption).bold()
                    .padding(.horizontal, 8).padding(.vertical, 4)
                    .background(statusColor(booking.status).opacity(0.2))
                    .foregroundColor(statusColor(booking.status))
                    .clipShape(Capsule())
            }
            
            // MARK: Car and Dates
            VStack(alignment: .leading, spacing: 4) {
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
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            
            // MARK: Rejection Reason
            if let reason = booking.rejectionReason, booking.status == "rejected" {
                Text("Reason: \(reason)")
                    .font(.footnote)
                    .foregroundColor(.red)
                    .bold()
                    .padding(.top, 2)
            }
        }
        .padding(.vertical, 6)
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


