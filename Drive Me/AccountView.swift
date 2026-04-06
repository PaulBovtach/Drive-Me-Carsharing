//
//  AccountView.swift
//  Drive Me
//
//  Created by Paul Bovtach on 28.03.2026.
//

import SwiftUI
import Supabase

struct AccountView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var bookingManager: BookingsManager
    
    @State private var showSignOutAlert = false
    
    var body: some View {
        NavigationStack {
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
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        
                        if authManager.isAuthenticated {
                            // MARK: - Інформація про користувача
                            VStack(spacing: 12) {
                                Image(systemName: "person.crop.circle.fill")
                                    .font(.system(size: 100))
                                    .foregroundColor(.white)
                                    .shadow(color: .black.opacity(0.2), radius: 10, y: 5)
                                
                                
                                HStack(spacing: 8) {
                                    Text(authManager.currentUserProfile?.name ?? "<name>")
                                    Text(authManager.currentUserProfile?.surname ?? "<surname>")
                                }
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                            }
                            .padding(.top, 20)
                            
                            
                            VStack(alignment: .leading, spacing: 12) {
                                BadgeView(icon: "envelope.fill", text: authManager.currentUserProfile?.email ?? "<email>")
                                BadgeView(icon: "phone.fill", text: authManager.currentUserProfile?.phoneNumber ?? "<number>")
                                BadgeView(icon: "person.text.rectangle", text: "Role: \(authManager.currentUserProfile?.role?.capitalized ?? "Unknown")")
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 24)
                            

                            Button(action: {
                                showSignOutAlert = true
                            }) {
                                Text("Sign Out")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(10)
                            }
                            .padding(.horizontal, 24)
                            .buttonStyle(.glass)
                            .environment(\.colorScheme, .dark)
                            
                            Divider()
                                .background(Color.white.opacity(0.2))
                                .padding(.vertical, 8)
                                .padding(.horizontal, 24)
                            
                            // MARK: - Мої бронювання
                            VStack(alignment: .leading, spacing: 16) {
                                Text("My bookings")
                                    .foregroundStyle(.white)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 24)
                                
                                if bookingManager.myBookings.isEmpty {
                                    Text("You have no bookings yet.")
                                        .foregroundStyle(.white.opacity(0.6))
                                        .padding(.horizontal, 24)
                                } else {

                                    VStack(spacing: 12) {
                                        ForEach(bookingManager.myBookings) { booking in

                                            NavigationLink {
                                                BookingDetailView(booking: booking)
                                                    .environmentObject(bookingManager)
                                            } label: {
                                                HStack {
                                                    Image(systemName: booking.status == "pending" ? "clock.fill" : "checkmark.circle.fill")
                                                        .foregroundStyle(.white)
                                                        .font(.title)
                                                    
                                                    VStack(alignment: .leading, spacing: 4) {
                                                        Text(booking.car?.brand ?? "Unknown")
                                                            .font(.headline)
                                                            .foregroundColor(.white)
                                                        
                                                        Text("\(booking.startDate.formatted(date: .numeric, time: .omitted)) - \(booking.endDate.formatted(date: .numeric, time: .omitted))")
                                                            .font(.subheadline)
                                                            .foregroundColor(.gray)
                                                    }
                                                    Spacer()
                                                    Image(systemName: "chevron.right")
                                                        .foregroundColor(.gray)
                                                }
                                                .padding(10)
                                            }
                                            .buttonStyle(.glass)
                                            .environment(\.colorScheme, .dark)
                                        }
                                    }
                                    .padding(.horizontal, 24)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 40)
                            
                        } else {

                            VStack(spacing: 20) {
                                Image(systemName: "person.crop.circle.badge.xmark")
                                    .font(.system(size: 80))
                                    .foregroundColor(.gray.opacity(0.8))
                                
                                Text("You are not authorized")
                                    .foregroundStyle(.white)
                                    .font(.title2)
                                    .fontWeight(.medium)
                                

                                Button(action: {
                                    withAnimation {
                                        authManager.showAuthView = true
                                    }
                                }) {
                                    Text("Log in or Register")
                                        .font(.headline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                }
                                .padding(.horizontal, 24)
                                .buttonStyle(.glass)
                                .environment(\.colorScheme, .dark)
                            }
                            .padding(.top, 100)
                        }
                    }
                }
                .task {
                    if let usrID = authManager.currentUser?.id {
                        await bookingManager.fetchMyBookings(userId: usrID)
                    }
                }
                .onChange(of: authManager.currentUserProfile) { _, newProfile in
                    if let profile = newProfile {
                        Task {
                            await bookingManager.fetchMyBookings(userId: profile.id)
                        }
                    }
                }
                .alert("Sign Out", isPresented: $showSignOutAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Sign Out", role: .destructive) {
                        Task {
                                await authManager.signOut()
                                bookingManager.clearBookedDates()
                                bookingManager.myBookings = []
                            }
                        }
                    } message: {
                        Text("Are you sure you want to sign out of your account?")
                    }
            }
        }
    }
}

#Preview {
    AccountView()
        .environmentObject(AuthManager(preview: true))
        .environmentObject(BookingsManager())
}
