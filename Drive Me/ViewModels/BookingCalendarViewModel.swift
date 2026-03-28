//
//  BookingCalendarSheetViewModel.swift
//  Drive Me
//
//  Created by Paul Bovtach on 25.03.2026.
//

import Foundation
import Combine
import Supabase

struct DayValue: Identifiable {
    let id = UUID()
    let day: Int
    let date: Date
}


class BookingCalendarViewModel: ObservableObject {
    
    let car: Car
    
    @Published var startDate: Date? = nil
    @Published var endDate: Date? = nil
    @Published var currentMonth: Date = Date()
    
    let calendar = Calendar.current
    let daysOfWeek = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
    
    init(car: Car) {
        self.car = car
    }
    
    //MARK: Formatting text
    
    //text that will show how many days uses have selected
    var summaryText: String {
        if let start = startDate, let end = endDate {
            let components = calendar.dateComponents([.day], from: start, to: end)
            let days = (components.day ?? 0) + 1
            
            return days == 1 ? "\(days) day" : "\(days) days "
        }
        else if startDate != nil {
            return "Select return date"
        }
        else {
            return "Select dates"
        }
    }
    
    
    //format date to show day of week, day of month and month
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM"
        return formatter.string(from: date)
    }
    
    //showing full mont of year, example: may 2026
    func monthYearString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentMonth)
    }
    
    var totalCost: Int {
        
        if let start = startDate, let end = endDate, let price = car.pricePerDay {
            let components = calendar.dateComponents([.day], from: start, to: end)
            let days = (components.day ?? 0) + 1
            return price * days
        }
        
        return 0
    }
    
    
    
    //MARK: Action Logics
    //clearing selected dates
    func clearDates() {
        startDate = nil
        endDate = nil
    }
    
    //change month after pressing the > button
    func changeMonth(by value: Int) {
        if let newMonth = calendar.date(byAdding: .month, value: value, to: currentMonth) {
            currentMonth = newMonth
        }
    }
    
    func handleDateSelection(date: Date) {
        //reject selecting past date
        if date < calendar.startOfDay(for: Date()) { return }
        
        if startDate == nil {
            startDate = date
        } else if let start = startDate, endDate == nil {
            if date < start {
                startDate = date
            } else {
                endDate = date
            }
        } else {
            startDate = date
            endDate = nil
        }
    }
    
    // MARK: - Генератор сітки календаря
    func extractDates() -> [DayValue] {
        var days: [DayValue] = []
        guard let month = calendar.dateInterval(of: .month, for: currentMonth)?.start else { return [] }
        
        let firstWeekday = calendar.component(.weekday, from: month)
        for _ in 0..<(firstWeekday - 1) { days.append(DayValue(day: -1, date: month)) }
        
        guard let range = calendar.range(of: .day, in: .month, for: month) else { return days }
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: month) {
                days.append(DayValue(day: day, date: date))
            }
        }
        return days
    }
    
    
    //MARK: - Supabase actions
    @MainActor
    func createBooking(userId: UUID, startDate: Date, endDate: Date) async {
        
        let newBooking = Booking(id: UUID(), clientId: userId, carId: car.id, startDate: startDate, endDate: endDate, status: "pending", cost: totalCost)
        
        do{
            try await supabase.from("bookings").insert(newBooking).execute()
            print("Booking successfully created")
        }catch {
            print("Failed to create booking: \(error.localizedDescription)")
        }
        
    }
    
}
