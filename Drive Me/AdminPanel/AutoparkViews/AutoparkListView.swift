//
//  AutoparkListView.swift
//  Drive Me
//
//  Created by Paul Bovtach on 16.04.2026.
//

import SwiftUI

struct AutoparkListView: View {
    
    @StateObject private var vm = AutoparkListViewModel()
    
    init(){
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    var body: some View {
        let columns = [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16)
        ]
        
        NavigationStack{
            ZStack{
                
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
                
                VStack(spacing: 0){
                    HStack(spacing: 16) {
                        DashboardCard(title: "Total Cars", value: "\(vm.totalCarsCount)", icon: "car.2.fill", color: .blue)
                            .glassEffect()
                        DashboardCard(title: "Available", value: "\(vm.availableCarsCount)", icon: "checkmark.circle.fill", color: .green)
                            .glassEffect()
                    }
                    .padding()
                    
                    
                    Picker("Filter", selection: $vm.selectedFilter) {
                        ForEach(CarFilter.allCases, id: \.self) { filter in
                            Text(filter.rawValue).tag(filter)
                        }
                    }
                    .environment(\.colorScheme, .dark)
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                
                
                ScrollView {
                    if vm.filteredCars.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "car.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                            Text("No \(vm.selectedFilter.rawValue.lowercased()) cars")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 50)
                    } else {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(vm.filteredCars) { car in
                                NavigationLink {
                                    AdminCarEditView(car: car)
                                } label: {
                                    CarGridCellView(car: car)
                                        .glassEffect()
                                }
                                
                            }
                        }
                        .padding()
                    }
                }
                .navigationTitle("Autopark")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            print("Add new car tapped")
                        } label: {
                            Image(systemName: "plus")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .clipShape(Circle())
                        .padding(8)
                        
                        
                        
                    }
                }
                .preferredColorScheme(.dark)
                .task { await vm.fetchCars() }
                .refreshable { await vm.fetchCars(isRefreshing: true) }
            }
                
            }
        }
        
        
        
        
    }
}

struct DashboardCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(1)
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            Spacer()
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(color.opacity(0.8))
        }
        
    }
}

#Preview {
    AutoparkListView()
}
