//
//  AdminRequestDetailView.swift
//  Drive Me
//
//  Created by Paul Bovtach on 15.04.2026.
//

import SwiftUI

struct AdminRequestDetailView: View {
    @StateObject private var vm: AdminRequestDetailViewModel
    
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
                    
                    // MARK: Клієнт
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Client Info")
                            .font(.title3).fontWeight(.bold).foregroundColor(.white)
                        
                        HStack {
                            // Ліва частина: Аватарка (іконка) + Текст
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
                            
                            if let phone = vm.booking.client?.phoneNumber {
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
                .padding()
                .glassEffect()
                .padding(.horizontal)
                
            }
        }
        .navigationTitle(vm.booking.car?.brand ?? "Details")
        .navigationBarTitleDisplayMode(.inline)
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
