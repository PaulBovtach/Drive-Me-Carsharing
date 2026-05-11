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
                        Color(red: 50/255, green: 80/255, blue: 40/255),
                        Color(red: 35/255, green: 60/255, blue: 25/255),
                        Color(red: 20/255, green: 40/255, blue: 15/255)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        
                        if authManager.isAuthenticated {
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
                .navigationTitle("My account")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            withAnimation {
                                UserDefaults.standard.set(false, forKey: "hasSeenOnboarding")
                            }
                        }) {
                            Image(systemName: "questionmark.circle")
                                .font(.body)
                                .foregroundColor(.white)
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
