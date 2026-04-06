//
//  BookingCalendarSheetView.swift
//  Drive Me
//
//  Created by Paul Bovtach on 25.03.2026.
//


import SwiftUI

struct BookingCalendarView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: BookingCalendarViewModel
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var bookingManager: BookingsManager
    
    let car: Car
    
    init(car: Car) {
        self.car = car
        self._viewModel = StateObject(wrappedValue: BookingCalendarViewModel(car: car))
    }
    
    
    var body: some View {
        ZStack {
            
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
            
            VStack(alignment: .leading, spacing: 24) {
                // MARK: - Верхня панель (Кнопка X та Clear)
                HStack {
                    Button(action: { withAnimation {
                        dismiss()
                    } }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 50)
                            .clipShape(Circle())
                            
                        
                        
                    }
                    .buttonStyle(.glass)
                    .environment(\.colorScheme, .dark)
                    
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            viewModel.startDate = nil
                            viewModel.endDate = nil
                        }
                    }) {
                        Text("Clear date")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .frame(width: 100, height: 50)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.glass)
                    .environment(\.colorScheme, .dark)
                }
                
                // MARK: - Заголовок (Кількість днів)
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.summaryText)
                        .font(.system(size: 36, weight: .semibold))
                        .foregroundColor(.white)
                    
                    if let start = viewModel.startDate {
                        Text("\(viewModel.formatDate(start)) \(viewModel.endDate != nil ? "- \(viewModel.formatDate(viewModel.endDate!))" : "")")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    HStack(spacing: 8) {
                        Image(systemName: "dollarsign")
                            .foregroundColor(.green)
                        Text("\(viewModel.totalCost)")
                            .font(.headline)
                            .foregroundStyle(.white)
                    }
                    .padding(.top, 8)
                }
                
                // MARK: - Календар
                VStack(spacing: 20) {
                    //Buttons to swap months
                    HStack {
                        Button(action: { withAnimation {
                            viewModel.changeMonth(by: -1)
                        } }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .frame(width: 40, height: 30)
                                .clipShape(Circle())
                                
                        }
                        .buttonStyle(.glass)
                        .environment(\.colorScheme, .dark)
                        
                        Spacer()
                        
                        Text(viewModel.monthYearString())
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: { withAnimation {
                            viewModel.changeMonth(by: 1)
                        } }) {
                            Image(systemName: "chevron.right")
                                .frame(width: 40, height: 30)
                                .clipShape(Circle())
                                .foregroundColor(.white)
                                
                        }
                        .buttonStyle(.glass)
                        .environment(\.colorScheme, .dark)
                    }
                    
                    // Days of month
                    HStack {
                        ForEach(viewModel.daysOfWeek, id: \.self) { day in
                            Text(day)
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.white.opacity(0.5))
                                .frame(maxWidth: .infinity)
                        }
                    }
                    
                    // Date grid
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 12) {
                        ForEach(viewModel.extractDates()) { dayValue in
                            
                            
                            let isPast = dayValue.date < viewModel.calendar.startOfDay(for: Date())
                            let isBooked = viewModel.isDateBooked(dayValue.date)
                            let isDisabled = isPast || isBooked
                            
                            DayCellView(
                                dayValue: dayValue,
                                startDate: viewModel.startDate,
                                endDate: viewModel.endDate,
                                calendar: viewModel.calendar,
                                isDisabled: isDisabled
                            )
                            .onTapGesture {
                                if !isDisabled {
                                    withAnimation {
                                        viewModel.handleDateSelection(date: dayValue.date)
                                    }
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // MARK: - Нижня кнопка
                    Button(action: {
                        
                        
                        if authManager.isAuthenticated {
                            print("Користувач залогінений. Бронюємо з \(viewModel.startDate?.description ?? "") по \(viewModel.endDate?.description ?? "")")
                            
                            Task{
                                if let usrID = authManager.currentUserProfile?.id {
                                    
                                    await viewModel.createBooking(userId: usrID, startDate: viewModel.startDate ?? Date(), endDate: viewModel.endDate ?? Date())
                                }else { print("Booking. problem with usrID")}
                            }
                            
                            
                            dismiss()
                        }else {
                            print("Користувач є гостем.")
                            withAnimation {
                                authManager.showAuthView = true
                            }
                        }
                        
                        
                    }) {
                        Text("Confirm Dates")
                            .font(.headline)
                            .foregroundColor((viewModel.startDate != nil && viewModel.endDate != nil) ? .black : .white.opacity(0.5))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background((viewModel.startDate != nil && viewModel.endDate != nil) ? Color.white : Color.white.opacity(0.1))
                            .cornerRadius(40)
                    }
                    .disabled(viewModel.startDate == nil || viewModel.endDate == nil)
                    .padding(.bottom, 20)
                }
                .padding(24)
                .task {
                    bookingManager.clearBookedDates()
                    await bookingManager.fetchBookedDatesForCar(carId: car.id)
                }
                .onChange(of: bookingManager.bookedDatesForCar) { _, newValue in
                    withAnimation {
                        viewModel.bookedDates = newValue
                    }
                }
                .onDisappear {
                    bookingManager.clearBookedDates()
                }
            }
            .padding()
            
            
        }
        
    }
    
}

struct DayCellView: View {
    let dayValue: DayValue
    let startDate: Date?
    let endDate: Date?
    let calendar: Calendar
    let isDisabled: Bool
    
    var body: some View {
        VStack {
            if dayValue.day != -1 {
                let isStart = startDate != nil && calendar.isDate(dayValue.date, inSameDayAs: startDate!)
                let isEnd = endDate != nil && calendar.isDate(dayValue.date, inSameDayAs: endDate!)
                let isBetween = isDateBetween(dayValue.date)
                
                Text("\(dayValue.day)")
                    .font(.system(size: 16, weight: (isStart || isEnd) ? .bold : .regular))
                    .foregroundColor(isDisabled ? .white.opacity(0.3) : .white) // Сірий текст
                    .frame(width: 40, height: 40)
                    .background(
                        ZStack {
                            if !isDisabled {
                                if isBetween || isStart || isEnd {
                                    Circle()
                                        .fill(Color.green.opacity(0.80))
                                        .frame(height: 40)
                                        .padding(.leading, isStart ? 20 : 0)
                                        .padding(.trailing, isEnd ? 20 : 0)
                                }
                                if isStart || isEnd {
                                    Circle()
                                        .frame(width: 40, height: 40)
                                        .shadow(radius: 2)
                                        .background(.ultraThinMaterial)
                                        .environment(\.colorScheme, .light)
                                        .cornerRadius(40)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 40)
                                                .stroke(Color.white.opacity(0.4), lineWidth: 1)
                                        )
                                }
                            }
                        }
                    )
            } else {
                Text("")
            }
        }
    }
    
    func isDateBetween(_ date: Date) -> Bool {
        guard let start = startDate, let end = endDate else { return false }
        return date > start && date < end
    }
}



    
#Preview {
    BookingCalendarView(car: Car(id: UUID(), isAvailable: true, pricePerDay: 100))
}




