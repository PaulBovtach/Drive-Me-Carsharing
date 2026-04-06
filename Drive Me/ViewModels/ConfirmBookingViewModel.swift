//
//  ConfirmBookingViewModel.swift
//  Drive Me
//
//  Created by Paul Bovtach on 06.04.2026.
//



import Foundation
import Combine
import Supabase

@MainActor
class ConfirmBookingViewModel: ObservableObject {
    let car: Car
    let startDate: Date
    let endDate: Date
    
    // Стан UI
    @Published var isLoading = false
    @Published var showAlertBookingStatus = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var isSuccess = false
    
    init(car: Car, startDate: Date, endDate: Date) {
        self.car = car
        self.startDate = startDate
        self.endDate = endDate
    }
    
    var totalDays: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        return (components.day ?? 0) + 1
    }
    

    var totalCost: Int {
        return (car.pricePerDay ?? 0) * totalDays
    }
    

    func confirmBooking(userId: UUID, bookingManager: BookingsManager) async {
        isLoading = true
        
        let newBooking = Booking(
            id: UUID(),
            clientId: userId,
            carId: car.id,
            startDate: startDate,
            endDate: endDate,
            status: "pending",
            cost: totalCost
        )
        
        do {

            try await supabase.from("bookings").insert(newBooking).execute()
            

            await bookingManager.fetchMyBookings(userId: userId)
            

            self.alertTitle = "Success!"
            self.alertMessage = "Successfully created booking. Wait until it will be confirmed."
            self.isSuccess = true
            self.showAlertBookingStatus = true
            
        } catch {

            self.alertTitle = "Fail!"
            self.alertMessage = "Something went wrong. Check Internet connection or try again later."
            self.isSuccess = false
            self.showAlertBookingStatus = true
        }
        
        isLoading = false
    }
}
