//
//  BookingCalendarSheetView.swift
//  Drive Me
//
//  Created by Paul Bovtach on 25.03.2026.
//


import SwiftUI

struct BookingCalendarView: View {
    @Environment(\.dismiss) var dismiss
    let car: Car
    
    
    @StateObject private var viewModel: BookingCalendarViewModel
    
    init(car: Car) {
            self.car = car
            self._viewModel = StateObject(wrappedValue: BookingCalendarViewModel(car: car))
        }
    
    
    var body: some View {
        ZStack {
            
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 63/255, green: 126/255, blue: 65/255),
                    Color(red: 45/255, green: 100/255, blue: 50/255),
                    Color(red: 30/255, green: 80/255, blue: 35/255)
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
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .background(.ultraThinMaterial)
                            .cornerRadius(40)
                            .overlay(
                                RoundedRectangle(cornerRadius: 40)
                                    .stroke(Color.white.opacity(0.4), lineWidth: 1)
                            )
                            
                
                    }
                    
                    .buttonStyle(BouncyGlassButtonStyle())
                    
                    
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
                            .background(.ultraThinMaterial)
                            .cornerRadius(40)
                            .overlay(
                                RoundedRectangle(cornerRadius: 40)
                                    .stroke(Color.white.opacity(0.4), lineWidth: 1)
                            )
                    }
                    .buttonStyle(BouncyGlassButtonStyle())
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
                    // Перемикач місяців
                    HStack {
                        Button(action: { withAnimation {
                            viewModel.changeMonth(by: -1)
                        } }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .frame(width: 44, height: 44)
                                .background(Color.white.opacity(0.1))
                                .clipShape(Circle())
                                .background(.ultraThinMaterial)
                                .cornerRadius(40)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(Color.white.opacity(0.4), lineWidth: 1)
                                )
                        }
                        .buttonStyle(BouncyGlassButtonStyle())
                        
                        Spacer()
                        
                        Text(viewModel.monthYearString())
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: { withAnimation {
                            viewModel.changeMonth(by: 1)
                        } }) {
                            Image(systemName: "chevron.right").frame(width: 44, height: 44).background(Color.white.opacity(0.1)).clipShape(Circle()).foregroundColor(.white)
                                .background(.ultraThinMaterial)
                                .cornerRadius(40)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(Color.white.opacity(0.4), lineWidth: 1)
                                )
                        }
                        .buttonStyle(BouncyGlassButtonStyle())
                    }
                    
                    // Дні тижня
                    HStack {
                        ForEach(viewModel.daysOfWeek, id: \.self) { day in
                            Text(day)
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.white.opacity(0.5))
                                .frame(maxWidth: .infinity)
                        }
                    }
                    
                    // Сітка дат
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 12) {
                        ForEach(viewModel.extractDates()) { dayValue in
                            DayCellView(
                                dayValue: dayValue,
                                startDate: viewModel.startDate, // Передаємо значення
                                endDate: viewModel.endDate,
                                calendar: viewModel.calendar
                            )
                            .onTapGesture {
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
                    print("Бронюємо з \(viewModel.startDate?.description ?? "") по \(viewModel.endDate?.description ?? "")")
                    dismiss()
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
        }
       
    }
    
}


// Дизайн однієї клітинки дня
struct DayCellView: View {
    let dayValue: DayValue
    let startDate: Date?
    let endDate: Date?
    let calendar: Calendar
    
    var body: some View {
        VStack {
            if dayValue.day != -1 {
                let isPast = dayValue.date < calendar.startOfDay(for: Date())
                let isStart = startDate != nil && calendar.isDate(dayValue.date, inSameDayAs: startDate!)
                let isEnd = endDate != nil && calendar.isDate(dayValue.date, inSameDayAs: endDate!)
                let isBetween = isDateBetween(dayValue.date)
                
                Text("\(dayValue.day)")
                    .font(.system(size: 16, weight: (isStart || isEnd) ? .bold : .regular))
                    .foregroundColor(isPast ? .white.opacity(0.3) : .white)
                    .frame(width: 40, height: 40)
                    .background(
                        ZStack {
                            if isBetween || isStart || isEnd {
                                Circle()
                                    .fill(Color.myGreen.opacity(0.80))
                                    .frame(height: 40)
                                    .padding(.leading, isStart ? 20 : 0)
                                    .padding(.trailing, isEnd ? 20 : 0)
                            }
                            if isStart || isEnd {
                                Circle()
                                    .frame(width: 40, height: 40)
                                    .shadow(radius: 2)
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(40)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 40)
                                            .stroke(Color.white.opacity(0.4), lineWidth: 1)
                                    )
                                
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




