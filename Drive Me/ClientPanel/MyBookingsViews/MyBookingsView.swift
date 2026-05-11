//
//  MyBookingsView.swift
//  Drive Me
//

import SwiftUI
import Supabase

struct MyBookingsView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var bookingManager: BookingsManager
    
    @State private var selectedFilter: String = "all"
    let filterOptions = ["all", "pending", "approved", "rejected"]
    
    var filteredBookings: [Booking] {
        let filtered: [Booking]
        if selectedFilter == "all" {
            filtered = bookingManager.myBookings
        } else {
            filtered = bookingManager.myBookings.filter { $0.status.lowercased() == selectedFilter }
        }
        
        return filtered.sorted { $0.startDate > $1.startDate }
    }
    
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
                
                VStack(spacing: 0) {
                    if authManager.isAuthenticated {
                        Picker("Status", selection: $selectedFilter) {
                            ForEach(filterOptions, id: \.self) { filter in
                                Text(filter.capitalized).tag(filter)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                        .background(.ultraThinMaterial)
                        .environment(\.colorScheme, .dark)
                        
                        ScrollView(showsIndicators: false) {
                            if filteredBookings.isEmpty {
                                Text(selectedFilter == "all" ? "No bookings found." : "No \(selectedFilter) bookings found.")
                                    .foregroundStyle(.white.opacity(0.6))
                                    .padding(.top, 40)
                            } else {
                                VStack(spacing: 12) {
                                    ForEach(filteredBookings) { booking in
                                        NavigationLink {
                                            BookingDetailView(booking: booking)
                                                .environmentObject(bookingManager)
                                        } label: {
                                            MyBookingRowView(booking: booking)
                                        }
                                        .buttonStyle(.glass)
                                        .environment(\.colorScheme, .dark)
                                    }
                                }
                                .padding(.horizontal, 24)
                                .padding(.top, 10)
                                .padding(.bottom, 40)
                            }
                        }
                    } else {
                        VStack(spacing: 20) {
                            Image(systemName: "person.crop.circle.badge.xmark")
                                .font(.system(size: 80))
                                .foregroundColor(.gray.opacity(0.8))
                            
                            Text("You are not authorized")
                                .foregroundStyle(.white)
                                .font(.title2)
                                .fontWeight(.medium)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .navigationTitle("My Bookings")
                .navigationBarTitleDisplayMode(.inline)
                .task {
                    if let usrID = authManager.currentUser?.id {
                        await bookingManager.fetchMyBookings(userId: usrID)
                    }
                }
                .refreshable {
                    if let usrID = authManager.currentUser?.id {
                        await bookingManager.fetchMyBookings(userId: usrID, isRefreshing: true)
                    }
                }
                .onChange(of: authManager.currentUserProfile) { _, newProfile in
                    if let profile = newProfile {
                        Task {
                            await bookingManager.fetchMyBookings(userId: profile.id)
                        }
                    }
                }
            }
        }
    }
}

struct MyBookingRowView: View {
    let booking: Booking
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            HStack {
                Text(booking.car?.brand ?? "Unknown Car")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(booking.status.uppercased())
                    .font(.caption).bold()
                    .padding(.horizontal, 10).padding(.vertical, 4)
                    .background(statusColor(booking.status).opacity(0.2))
                    .foregroundColor(statusColor(booking.status))
                    .clipShape(Capsule())
            }
            
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                        .foregroundColor(.gray)
                    Text("\(booking.startDate.formatted(date: .abbreviated, time: .omitted)) - \(booking.endDate.formatted(date: .abbreviated, time: .omitted))")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }
                
                HStack(spacing: 6) {
                    Image(systemName: "dollarsign.circle.fill")
                        .foregroundColor(.green.opacity(0.8))
                    Text("Total: \(String(booking.cost)) $")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }
            }
        }
        .padding(14)
    }
    
    private func statusColor(_ status: String) -> Color {
        switch status.lowercased() {
        case "pending": return .orange
        case "approved", "confirmed": return .green
        case "rejected", "cancelled": return .red
        default: return .gray
        }
    }
}
