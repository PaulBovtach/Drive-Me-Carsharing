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
    @Published var bookedDatesForCar: [Date] = []
    
    //MARK: Fetch my bookings
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
    
    //MARK: delete my bookings
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
    
    //MARK: fetch booked dates
    func fetchBookedDatesForCar(carId: UUID) async {
        do {
            let bookings: [Booking] = try await supabase
                .from("bookings")
                .select()
                .eq("car_id", value: carId)
                .execute()
                .value
            
            var dates: [Date] = []
            let calendar = Calendar.current
            for booking in bookings {
                var currentDate = calendar.startOfDay(for: booking.startDate)
                let endDate = calendar.startOfDay(for: booking.endDate)
                
                while currentDate <= endDate {
                    dates.append(currentDate)
                    currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
                }
            }
            self.bookedDatesForCar = dates
            print("Successfully fetched \(dates.count) booked days for this car")
        }catch {
            print("Failed to fetch booked dates: \(error.localizedDescription)")
            
        }
    }
    
    func clearBookedDates() {
        self.bookedDatesForCar = []
    }
    
    
    
    
    
    
}
