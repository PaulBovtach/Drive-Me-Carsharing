//
//  AdminRequestsView.swift
//  Drive Me
//
//  Created by Paul Bovtach on 15.04.2026.
//

import SwiftUI

import SwiftUI

struct AdminRequestsView: View {
    @StateObject private var viewModel = AdminRequestsViewModel()
    
    @State private var bookingToReject: Booking?
    @State private var rejectionReason: String = ""
    @State private var showRejectAlert: Bool = false
    
    init(){
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    var body: some View {
        NavigationStack {
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
                
                VStack(spacing: 0) {
                    
                    Picker("Filter", selection: $viewModel.selectedFilter) {
                        ForEach(BookingFilter.allCases, id: \.self) { filter in
                            Text(filter.rawValue).tag(filter)
                        }
                    }
                    .environment(\.colorScheme, .dark)
                    .pickerStyle(.segmented)
                    .padding(5)
                    
                    
                    if viewModel.isLoading && viewModel.requests.isEmpty {
                        ProgressView("Loading requests")
                            .frame(maxHeight: .infinity)
                    } else if viewModel.filteredRequests.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "tray.and.arrow.down")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                            Text("No \(viewModel.selectedFilter.rawValue.lowercased()) requests yet")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        .frame(maxHeight: .infinity)
                        
                    } else {
                        //main content
                        List {
                            ForEach(viewModel.filteredRequests) { booking in
                                
                                NavigationLink {
                                    AdminRequestDetailView(booking: booking)
                                } label: {
                                    RequestRowView(booking: booking)
                                    
                                }
                                
                                .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                    if booking.status == "pending" {
                                        Button {
                                            Task { await viewModel.approveRequest(bookingId: booking.id) }
                                        } label: {
                                            Label("Approve", systemImage: "checkmark")
                                        }
                                        .tint(.green)
                                    }
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    if booking.status == "pending" {
                                        Button {
                                            bookingToReject = booking
                                            showRejectAlert = true
                                        } label: {
                                            Label("Reject", systemImage: "xmark")
                                        }
                                        .tint(.red)
                                    }
                                }
                                .listRowSeparator(.hidden)
                            
                            }
                        }
                        .environment(\.colorScheme, .dark)
                        .listRowSpacing(20)
                        .listStyle(.sidebar)
                        .refreshable {
                            
                            await viewModel.fetchRequests()
                        }
                        .scrollContentBackground(.hidden)
                    }
                }
                .navigationTitle("Requests")
                .task {
                    await viewModel.fetchRequests()
                }
                .alert("Reject Booking", isPresented: $showRejectAlert, presenting: bookingToReject) { booking in
                    TextField("Reason (optional)", text: $rejectionReason)
                    
                    Button("Cancel", role: .cancel) {
                        rejectionReason = ""
                    }
                    
                    Button("Reject", role: .destructive) {
                        Task {
                            await viewModel.rejectRequest(bookingId: booking.id, reason: rejectionReason)
                            rejectionReason = ""
                        }
                    }
                } message: { booking in
                    Text("Are you sure you want to reject this booking? You can provide an optional reason for the client.")
                }
            }
        }
    }
}

#Preview {
    AdminRequestsView()
}
