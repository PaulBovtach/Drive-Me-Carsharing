//
//  BookByDateViewModel.swift
//  Drive Me
//
//  Created by Paul Bovtach on 29.03.2026.
//

import Foundation
import Supabase
import Combine

@MainActor
class BookByDateViewModel: ObservableObject {
    
    @Published var startDate: Date? = nil
    @Published var endDate: Date? = nil
    @Published var currentMonth: Date? = Date()
    
    @Published var allCars: [Car] = []
    @Published var allBookings: [Booking] = []
    @Published var totallyBookedDates: [Date] = []
    @Published var isLoading = false
    
    let calendar = Calendar.current
    let daysOfWeek = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
    
    // MARK: Download data
    func fetchGlobalData() async {
            isLoading = true
            do {
                // 1. fetch all cars
                let fetchedCars: [Car] = try await supabase.from("cars").select().execute().value
                self.allCars = fetchedCars
                
                // 2. fethc all bookings
                let fetchedBookings: [Booking] = try await supabase.from("bookings").select().execute().value
                self.allBookings = fetchedBookings
                
                // 3. find which days are booked
                calculateTotallyBookedDates()
                
            } catch {
                print("Failed to fetch global data(cars, bookings): \(error.localizedDescription)")
            }
            isLoading = false
        }
    
    
    //MARK: Calculating booked datesa
    func calculateTotallyBookedDates() {
        guard !allCars.isEmpty else { return }
        
        let totalCarsCount = allCars.count
        var dateCounts: [Date: Int] = [:] //Date : how much cars are booked
        
        for booking in allBookings {
            var currentDate = calendar.startOfDay(for: booking.startDate)
            let endDate = calendar.startOfDay(for: booking.endDate)
            
            while currentDate <= endDate {
                dateCounts[currentDate, default: 0] += 1
                currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
                
            }
        }
        
        // date is fully booked if it's count >= total car amount
        self.totallyBookedDates = dateCounts.compactMap{ (date, count) in
            return count >= totalCarsCount ? date : nil
        }
        
    }
    
    // MARK: Check which cars are available
    
        var availableCarsForSelection: [Car] {
            // If dates don't chosen, show empty list
            guard let start = startDate, let end = endDate else { return [] }
            
            let startOfStart = calendar.startOfDay(for: start)
            let startOfEnd = calendar.startOfDay(for: end)
            
            var bookedCarIds = Set<UUID>()
            
            // search cars that do not needed
            for booking in allBookings {
                let bStart = calendar.startOfDay(for: booking.startDate)
                let bEnd = calendar.startOfDay(for: booking.endDate)
                
                if startOfStart <= bEnd && startOfEnd >= bStart {
                    bookedCarIds.insert(booking.carId) // Booked car
                }
            }
            
            // returning cars that aren't in booked cars list
            return allCars.filter { !bookedCarIds.contains($0.id) && $0.isAvailable }
        }
        
        var summaryText: String {
            if let start = startDate, let end = endDate {
                let days = (calendar.dateComponents([.day], from: start, to: end).day ?? 0) + 1
                return days == 1 ? "\(days) day" : "\(days) days"
            } else if startDate != nil {
                return "Select return date"
            } else {
                return "Select your dates"
            }
        }
        
        func formatDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "E, d MMM"
            return formatter.string(from: date)
        }
        
        func monthYearString() -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM yyyy"
            return formatter.string(from: currentMonth ?? Date())
        }
        
        func changeMonth(by value: Int) {
            if let newMonth = calendar.date(byAdding: .month, value: value, to: currentMonth ?? Date()) {
                currentMonth = newMonth
            }
        }
        
        func isDateBooked(_ date: Date) -> Bool {
            return totallyBookedDates.contains(calendar.startOfDay(for: date))
        }
        
        func isRangeValid(start: Date, end: Date) -> Bool {
            var currentDate = calendar.startOfDay(for: start)
            let endDate = calendar.startOfDay(for: end)
            while currentDate <= endDate {
                if isDateBooked(currentDate) { return false }
                currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
            }
            return true
        }
        
        func handleDateSelection(date: Date) {
            let normalizedDate = calendar.startOfDay(for: date)
            if normalizedDate < calendar.startOfDay(for: Date()) { return }
            if isDateBooked(normalizedDate) { return }
            
            if startDate == nil {
                startDate = normalizedDate
            } else if let start = startDate, endDate == nil {
                if normalizedDate < start {
                    startDate = normalizedDate
                } else {
                    if isRangeValid(start: start, end: normalizedDate) {
                        endDate = normalizedDate
                    } else {
                        startDate = normalizedDate
                        endDate = nil
                    }
                }
            } else {
                startDate = normalizedDate
                endDate = nil
            }
        }
        
        func extractDates() -> [DayValue] {
            var days: [DayValue] = []
            guard let month = calendar.dateInterval(of: .month, for: currentMonth ?? Date())?.start else { return [] }
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
    }
            
    

