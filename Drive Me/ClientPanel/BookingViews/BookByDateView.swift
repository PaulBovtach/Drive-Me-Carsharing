//
//  SearchByDateView.swift
//  Drive Me
//
//  Created by Paul Bovtach on 31.03.2026.
//

import SwiftUI

struct BookByDateView: View {
    @StateObject private var viewModel = BookByDateViewModel()
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var bookingManager: BookingsManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 50/255, green: 80/255, blue: 40/255),
                        Color(red: 35/255, green: 60/255, blue: 25/255),
                        Color(red: 20/255, green: 40/255, blue: 15/255)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                if viewModel.isLoading {
                    ProgressView("Analyzing dates...")
                        .foregroundStyle(.white)
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(viewModel.summaryText)
                                        .font(.system(size: 28, weight: .semibold))
                                        .foregroundColor(.white)
                                    
                                    if let start = viewModel.startDate {
                                        Text("\(viewModel.formatDate(start)) \(viewModel.endDate != nil ? "- \(viewModel.formatDate(viewModel.endDate!))" : "")")
                                            .font(.subheadline)
                                            .foregroundColor(.white.opacity(0.7))
                                    }
                                }
                                
                                Spacer()
                                
                                if viewModel.startDate != nil {
                                    Button(action: {
                                        withAnimation {
                                            viewModel.startDate = nil
                                            viewModel.endDate = nil
                                        }
                                    }) {
                                        Text("Clear date")
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                            .frame(width: 100, height: 35)
                                            .clipShape(Capsule())
                                    }
                                    .buttonStyle(.glass)
                                    .environment(\.colorScheme, .dark)
                                }
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 16)
                            
                            VStack(spacing: 20) {
                                HStack {
                                    Button(action: { withAnimation { viewModel.changeMonth(by: -1) } }) {
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
                                    
                                    Button(action: { withAnimation { viewModel.changeMonth(by: 1) } }) {
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.white)
                                            .frame(width: 40, height: 30)
                                            .clipShape(Circle())
                                    }
                                    .buttonStyle(.glass)
                                    .environment(\.colorScheme, .dark)
                                }
                                
                                
                                HStack {
                                    ForEach(viewModel.daysOfWeek, id: \.self) { day in
                                        Text(day).font(.caption).fontWeight(.medium).foregroundColor(.white.opacity(0.5)).frame(maxWidth: .infinity)
                                    }
                                }
                                
                                // Dates grid
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 12) {
                                    ForEach(viewModel.extractDates()) { dayValue in
                                        let isPast = dayValue.date < viewModel.calendar.startOfDay(for: Date())
                                        let isBooked = viewModel.isDateBooked(dayValue.date)
                                        let isDisabled = isPast || isBooked
                                        
                                        GlobalDayCellView(
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
                            }
                            .padding(.horizontal, 24)
                            
                            Divider()
                                .background(Color.white.opacity(0.3))
                                .padding(.vertical, 8)
                                .padding(.horizontal, 24)
                            
                            if viewModel.startDate != nil && viewModel.endDate != nil {
                                let availableCars = viewModel.availableCarsForSelection
                                
                                if availableCars.isEmpty {
                                    VStack(spacing: 12) {
                                        Image(systemName: "car.2.fill")
                                            .font(.system(size: 50))
                                            .foregroundColor(.white.opacity(0.5))
                                        Text("No cars available for these dates.")
                                            .foregroundColor(.white.opacity(0.7))
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.top, 20)
                                } else {
                                    Text("Available Cars (\(availableCars.count))")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 24)
                                    
                                    LazyVStack(spacing: 20) {
                                        ForEach(availableCars) { car in
                                            NavigationLink(destination: ConfirmBookingView(
                                                car: car,
                                                startDate: viewModel.startDate!,
                                                endDate: viewModel.endDate!
                                            )) {
                                                CarRowView(car: car)
                                                    .glassEffect()
                                            }
                                            .buttonStyle(BouncyGlassButtonStyle())
                                        }
                                    }
                                    .padding(.horizontal, 24)
                                    .padding(.bottom, 40)
                                }
                            } else {
                                VStack(spacing: 12) {
                                    Image(systemName: "calendar.badge.clock")
                                        .font(.system(size: 50))
                                        .foregroundColor(.white.opacity(0.5))
                                    Text("Select check-in and check-out dates to see available cars.")
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.white.opacity(0.7))
                                        .padding(.horizontal, 40)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.top, 20)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Book by date")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.fetchGlobalData()
            }
            .refreshable {
                await viewModel.fetchGlobalData(isRefreshing: true)
            }
        }
    }
}

struct GlobalDayCellView: View {
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
                    .foregroundColor(isDisabled ? .white.opacity(0.3) : .white)
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
                                        .overlay(RoundedRectangle(cornerRadius: 40).stroke(Color.white.opacity(0.4), lineWidth: 1))
                                }
                            }
                        }
                    )
            } else { Text("") }
        }
    }
    func isDateBetween(_ date: Date) -> Bool {
        guard let start = startDate, let end = endDate else { return false }
        return date > start && date < end
    }
}

#Preview {
    BookByDateView()
}
