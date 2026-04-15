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
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isLoading && viewModel.requests.isEmpty {
                    ProgressView("Loading requests")
                } else if viewModel.requests.isEmpty {
                    Text("There is no requests yet")
                        .foregroundColor(.gray)
                } else {
                    List {
                        ForEach(viewModel.requests) { booking in
                            RequestRowView(booking: booking)
                                .swipeActions(edge: .leading, allowsFullSwipe: true) {
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
                        }
                    }
                    .refreshable {
                        await viewModel.fetchRequests()
                    }
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

// MARK: One request design
struct RequestRowView: View {
    let booking: Booking
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                //auto photo
                Text("Booking ID: \(booking.id.uuidString.prefix(6))")
                    .font(.headline)
                
                Spacer()
                
                Text(booking.status.uppercased())
                    .font(.caption).bold()
                    .padding(.horizontal, 8).padding(.vertical, 4)
                    .background(statusColor(booking.status).opacity(0.2))
                    .foregroundColor(statusColor(booking.status))
                    .clipShape(Capsule())
            }
            
            Text("Client ID: \(booking.clientId.uuidString.prefix(8))")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            if let reason = booking.rejectionReason, booking.status == "rejected" {
                Text("Reason: \(reason)")
                    .font(.footnote)
                    .foregroundColor(.red)
                    .italic()
            }
        }
        .padding(.vertical, 4)
    }
    
    private func statusColor(_ status: String) -> Color {
        switch status.lowercased() {
        case "pending": return .orange
        case "approved": return .green
        case "rejected": return .red
        default: return .gray
        }
    }
}
#Preview {
    AdminRequestsView()
}
