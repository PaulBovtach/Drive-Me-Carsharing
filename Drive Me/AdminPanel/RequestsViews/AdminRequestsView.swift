//
//  AdminRequestsView.swift
//  Drive Me
//
//  Created by Paul Bovtach on 15.04.2026.
//

import SwiftUI

struct AdminRequestsView: View {
    @StateObject private var viewModel = AdminRequestsViewModel()
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
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
                    
                    Picker("Filter", selection: $viewModel.selectedFilter) {
                        ForEach(BookingFilter.allCases, id: \.self) { filter in
                            Text(filter.rawValue).tag(filter)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                    .environment(\.colorScheme, .dark)
                    
                    // MARK: - Content
                    if viewModel.isLoading && viewModel.requests.isEmpty {
                        ProgressView("Loading requests")
                            .tint(.white)
                            .foregroundStyle(.white)
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
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 12) {
                                ForEach(viewModel.filteredRequests) { booking in
                                    NavigationLink {
                                        AdminRequestDetailView(booking: booking)
                                    } label: {
                                        RequestRowView(booking: booking)
                                    }
                                    .buttonStyle(.glass)
                                    .environment(\.colorScheme, .dark)
                                }
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 10)
                            .padding(.bottom, 40)
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
            }
        }
    }
}
#Preview {
    AdminRequestsView()
}
