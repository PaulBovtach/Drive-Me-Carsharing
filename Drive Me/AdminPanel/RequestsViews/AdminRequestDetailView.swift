//
//  AdminRequestDetailView.swift
//  Drive Me
//
//  Created by Paul Bovtach on 15.04.2026.
//

import SwiftUI

struct AdminRequestDetailView: View {
    @StateObject private var vm: AdminRequestDetailViewModel
    
    @State private var showRejectAlert = false
    @State private var rejectionReason = ""
    
    @State private var showApproveAlert = false
    
    init(booking: Booking) {
        _vm = StateObject(wrappedValue: AdminRequestDetailViewModel(booking: booking))
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
                
                ImageCardCarousel(car: vm.booking.car ?? Car(id: UUID(), isAvailable: true))
                    .frame(height: 300)
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Client Info")
                            .font(.title3).fontWeight(.bold).foregroundColor(.white)
                        
                        HStack {
                            HStack(spacing: 12) {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.gray.opacity(0.8))
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\(vm.booking.client?.name ?? "Unknown") \(vm.booking.client?.surname ?? "")")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    
                                    if let phone = vm.booking.client?.phoneNumber {
                                        Text(phone)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            
                            Spacer()
                            
                            if (vm.booking.client?.phoneNumber) != nil {
                                let cleanPhone = vm.cleanedNumber()
                                if let url = URL(string: "tel://\(cleanPhone)") {
                                    Link(destination: url) {
                                        Image(systemName: "phone.circle.fill")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(.green)
                                    }
                                }
                            }
                        }
                    }
                    
                    Divider().background(Color.white.opacity(0.2))
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Booking Summary")
                                .font(.title3).fontWeight(.bold).foregroundColor(.white)
                            Spacer()
                            
                            Text(vm.booking.status.uppercased())
                                .font(.caption).bold()
                                .padding(.horizontal, 8).padding(.vertical, 4)
                                .background(Color.white.opacity(0.1))
                                .foregroundColor(statusColor(vm.booking.status))
                                .clipShape(Capsule())
                        }
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Dates").font(.caption).foregroundColor(.gray)
                                Text("\(vm.booking.startDate.formatted(date: .abbreviated, time: .omitted)) - \(vm.booking.endDate.formatted(date: .abbreviated, time: .omitted))")
                                    .foregroundColor(.white).fontWeight(.medium)
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("Duration").font(.caption).foregroundColor(.gray)
                                Text("\(vm.totalDays) days")
                                    .foregroundColor(.white).fontWeight(.medium)
                            }
                        }
                        
                        Divider().background(Color.white.opacity(0.2))
                        
                        HStack {
                            Text("Total Price").foregroundColor(.white)
                            Spacer()
                            Text("\(vm.totalCost) $")
                                .font(.title2).fontWeight(.bold).foregroundColor(.green)
                        }
                    }
                }
                .padding(5)
                .glassEffect()
                .padding(.horizontal)
                
                
                if vm.booking.status == "pending"{
                    HStack{
                        Button{
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                                showRejectAlert = true
                            }
                            
                        }label: {
                            Text("Reject")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundStyle(.white)
                        }
                        .background(Color.red)
                        .buttonStyle(.glass)
                        .clipShape(.capsule)
                        .environment(\.colorScheme, .dark)
                        
                        Button{
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                                showApproveAlert = true
                            }
                            
                        }label: {
                            
                            Text("Approve")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundStyle(.white)
                            
                            
                        }
                        .background(Color.green)
                        .buttonStyle(.glass)
                        .clipShape(.capsule)
                        .environment(\.colorScheme, .dark)
                    }
                    .padding(.horizontal)
                }
                
                
                
                
                
            }
        }
        .navigationTitle("\(vm.booking.car?.brand ?? "No Brand") \(vm.booking.car?.model ?? "No model")")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Reject Request", isPresented: $showRejectAlert) {
            TextField("Reason(optional)", text: $rejectionReason)
            
            Button("Cancel", role: .cancel) {
                rejectionReason = ""
            }
            
            Button("Reject", role: .destructive) {
                Task {
                    await vm.rejectBooking(reason: rejectionReason)
                    rejectionReason = ""
                }
            }
        }message: {
            Text("Are you sure you want to reject this booking? You can provide an optional reason for the client.")
        }
        .alert("Approve Request", isPresented: $showApproveAlert){
            Button("Cancel", role: .cancel){ }
            Button("Approve", role: .confirm) {
                Task{
                    await vm.approveBooking()
                }
            }
        }
        
        
        
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
    NavigationStack {
        AdminRequestDetailView(booking: Booking(id: UUID(), clientId: UUID(), carId: UUID(), startDate: Date(), endDate: Calendar.current.date(byAdding: .day, value: 3, to: Date())!, status: "pending", cost: 200))
            .preferredColorScheme(.dark)
    }
}
