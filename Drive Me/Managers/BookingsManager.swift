//
//  BookingsManager.swift
//  Drive Me
//
//  Created by Paul Bovtach on 28.03.2026.
//

import Foundation
import Combine
import Supabase

@MainActor
class BookingsManager: ObservableObject {
    
    @Published var myBookings: [Booking] = []
    
    func fetchMyBookings(userId: UUID) async {
        do{
            let bookings: [Booking] = try await supabase
                .from("bookings")
                .select("*, cars(*)")
                .eq("client_id", value: userId)
                .order("created_at", ascending: false)
                .execute()
                .value
            
            self.myBookings = bookings
            print("Successfully fetched my bookings")
            
        }catch {
            print("Failed to fetch bookings: \(error.localizedDescription)")
        }
    }
    
    func deleteMyBooking(bookingId: UUID) async {
        do{
            try await supabase
                .from("bookings")
                .delete()
                .eq("id", value: bookingId)
                .execute()
            
            self.myBookings.removeAll { $0.id == bookingId}
            print("Successfully deleted and canceled booking")
        }catch {
            print("Failed to delete booking: \(error.localizedDescription)")
        }
    }
    
    
    
    
    
}
