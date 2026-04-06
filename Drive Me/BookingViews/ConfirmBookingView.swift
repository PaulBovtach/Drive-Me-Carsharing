//
//  ConfirmBookingView.swift
//  Drive Me
//
//  Created by Paul Bovtach on 06.04.2026.
//

import SwiftUI

struct ConfirmBookingView: View {
    @StateObject private var viewModel: ConfirmBookingViewModel
    
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var bookingManager: BookingsManager
    @Environment(\.dismiss) var dismiss
    
    
    init(car: Car, startDate: Date, endDate: Date) {
        self._viewModel = StateObject(wrappedValue: ConfirmBookingViewModel(car: car, startDate: startDate, endDate: endDate))
    }
    
    var body: some View {
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
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    ImageCardCarousel(car: viewModel.car)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Booking Summary")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Dates")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text("\(viewModel.startDate.formatted(date: .abbreviated, time: .omitted)) - \(viewModel.endDate.formatted(date: .abbreviated, time: .omitted))")
                                    .foregroundColor(.white)
                                    .fontWeight(.medium)
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("Duration")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text("\(viewModel.totalDays) days")
                                    .foregroundColor(.white)
                                    .fontWeight(.medium)
                            }
                        }
                        
                        Divider().background(Color.white.opacity(0.2))
                        
                        HStack {
                            Text("Total Price")
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(viewModel.totalCost) $")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                        }
                    }
                    .padding()
                    .glassEffect()
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("\(viewModel.car.brand ?? "") \(viewModel.car.model ?? "")")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        
                        HStack(spacing: 12) {
                            if let year = viewModel.car.year { BadgeView(icon: "calendar", text: String(year)) }
                            if let transmission = viewModel.car.transmissionType { BadgeView(icon: "gearshape", text: transmission) }
                            if let fuelType = viewModel.car.fuelType { BadgeView(icon: "fuelpump", text: fuelType)}
                        }
                        .foregroundStyle(.white)
                        
                        HStack(spacing: 12){
                            if let consumption = viewModel.car.consumption { BadgeView(icon: "leaf.fill", text: "\(String(format: "%.1f", consumption)) l / 100 km")}
                            if let pricePerDay = viewModel.car.pricePerDay { BadgeView(icon: "dollarsign", text: "\(pricePerDay)") }
                        }
                        .foregroundStyle(.white)
                        
                        Text("Description")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text("You are about to book this car for the selected period. Please confirm the details above.")
                            .foregroundColor(.white.opacity(0.8))
                            .font(.subheadline)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 120)
                }
            }
            
            .overlay(alignment: .bottom) {
                Button(action: {
                    if let userId = authManager.currentUserProfile?.id {
                        Task {
                            await viewModel.confirmBooking(userId: userId, bookingManager: bookingManager)
                        }
                    }
                }) {
                    HStack {
                        
                        if viewModel.isLoading {
                            ProgressView()
                                .tint(.black)
                        } else {
                            Image(systemName: "checkmark.circle.fill")
                        }
                        
                        Text(viewModel.isLoading ? "Confirming..." : "Confirm Booking")
                            .fontWeight(.bold)
                    }
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.isLoading ? Color.white.opacity(0.7) : Color.white)
                    .cornerRadius(40)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                }
                .buttonStyle(BouncyGlassButtonStyle())
                
                .disabled(viewModel.isLoading)
            }
        }
        .navigationTitle("Confirm Booking")
        .navigationBarTitleDisplayMode(.inline)
        
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlertBookingStatus) {
            Button("OK", role: .cancel) {
                if viewModel.isSuccess {
                    dismiss()
                }
            }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}
