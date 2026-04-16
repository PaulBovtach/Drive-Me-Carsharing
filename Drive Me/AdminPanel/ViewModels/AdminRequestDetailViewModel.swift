//
//  AdminRequestDetailViewModel.swift
//  Drive Me
//
//  Created by Paul Bovtach on 15.04.2026.
//

import Foundation
import Combine
import SwiftUI
import Supabase

@MainActor
class AdminRequestDetailViewModel: ObservableObject {
    @Published var booking: Booking
    @Published var isProcessing: Bool = false
    
    init(booking: Booking) {
        self.booking = booking
    }
    
    var totalDays: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: booking.startDate, to: booking.endDate)
        let days = components.day ?? 0
        return days > 0 ? days : 1
    }
    
    var totalCost: Int {
        return booking.cost
    }
    
    func cleanedNumber() -> String {
        return booking.client?.phoneNumber?.filter { "0123456789+".contains($0) } ?? "0000"
    }
    
    
    
    
    func approveBooking() async {
        isProcessing = true
        do {
            try await supabase
                .from("bookings")
                .update(["status": "approved", "rejection_reason": nil])
                .eq("id", value: booking.id)
                .execute()
            
            withAnimation {
                self.booking.status = "approved"
            }
        } catch {
            print("ADMIN. Failed to approve request(DetailView): \(error.localizedDescription)")
        }
        isProcessing = false
    }
    
    func rejectBooking(reason: String) async {
        isProcessing = true
        let finalReason = reason.trimmingCharacters(in: .whitespaces).isEmpty ? nil : reason
        do {
            try await supabase
                .from("bookings")
                .update(["status": "rejected", "rejection_reason": finalReason])
                .eq("id", value: booking.id)
                .execute()
            
            withAnimation {
                self.booking.status = "rejected"
                self.booking.rejectionReason = finalReason
            }
        } catch {
            print("ADMIN. Failed to reject request(DetailView): \(error.localizedDescription)")
        }
        isProcessing = false
    }
}
