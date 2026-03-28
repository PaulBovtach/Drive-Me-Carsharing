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
    @StateObject private var bookingManager = BookingsManager()
    
    var body: some View {
        NavigationStack{
            ZStack{
                
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
                
                
                VStack{
                    
                    
                    if authManager.isAuthenticated {
                        
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 120))
                            .foregroundColor(.green)
                        
                        //name and surname
                        HStack(spacing: 8) {
                            Text(authManager.currentUserProfile?.name ?? "<name>")
                            Text(authManager.currentUserProfile?.surname ?? "<surname>")
                        }
                        .padding(.vertical)
                        .font(.title)
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        
                        //additional information
                        VStack(alignment: .leading){
                            //email
                            Text("Email: \(authManager.currentUserProfile?.email ?? "<email>")")
                                .font(.title3)
                                .foregroundStyle(.white)
                                .fontWeight(.medium)
                                .multilineTextAlignment(.center)
                            //phone number
                            Text("Phone number: \(authManager.currentUserProfile?.phoneNumber ?? "<number>")")
                                .font(.title3)
                                .foregroundStyle(.white)
                                .fontWeight(.medium)
                                .multilineTextAlignment(.center)
                            //role
                            Text("Role: \(authManager.currentUserProfile?.role ?? "Unknown")")
                                .font(.title3)
                                .foregroundStyle(.white)
                                .fontWeight(.medium)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        
                        
                        
                        // sign out btn
                        Button(action: {
                            Task {
                                await authManager.signOut()
                            }
                        }) {
                            Text("Sign Out")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(10)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .padding(.horizontal, 24)
                        .buttonStyle(.glass)
                        .environment(\.colorScheme, .dark)
                        Spacer()
                        
                        //TODO: Preview for our bookings
                        
                        Text("My bookings")
                            .foregroundStyle(.white)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        ScrollView{
                            VStack(spacing: 8){
                                //text
                                if bookingManager.myBookings.isEmpty {
                                    Text("You have no bookings yet.")
                                        .foregroundStyle(.gray)
                                        .padding(.top, 20)
                                }
                                //navlinks
                                ForEach(bookingManager.myBookings){booking in
                                    NavigationLink{
                                        BookingDetailView(booking: booking)
                                            .environmentObject(bookingManager)
                                    }label: {
                                        HStack{
                                            Image(systemName: booking.status == "pending" ? "clock.fill" : "checkmark.circle.fill")
                                                .foregroundStyle(.white)
                                            VStack{
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
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .task {
                            if let usrID = authManager.currentUser?.id {
                                await bookingManager.fetchMyBookings(userId: usrID)
                            }
                        }
                        
                        
                    } else {
                        //if the user is guest
                        Spacer()
                        Text("You are not authorized")
                            .foregroundStyle(.white)
                            .font(.title)
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
                        Spacer()
                        Spacer()
                    }
                }
                .padding(.top, 40)
            }
        }
    }
}
#Preview {
    AccountView()
        .environmentObject(AuthManager(preview: true))
    
    
}
