//
//  CarListView.swift
//  Drive Me
//
//  Created by Paul Bovtach on 24.03.2026.
//

import SwiftUI

struct CarListView: View {
    @StateObject private var viewModel = CarViewModel()
    
    init(){
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
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
                
                Group {
                    if viewModel.isLoading {
                        ProgressView("Searching available cars...")
                            .foregroundStyle(.white)
                    }
                    else if viewModel.cars.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "car.2.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.white)
                            Text("Unfortunately, there is no available cars.")
                                .foregroundColor(.white)
                        }
                    }
                    else {
                        ScrollView {
                            LazyVStack(spacing: 20) {
                                ForEach(viewModel.cars) { car in
                                    NavigationLink(destination: CarDetailView(car: car)){
                                        CarRowView(car: car)
                                            .glassEffect()
                                    }
                                    
                                    .buttonStyle(BouncyGlassButtonStyle())
                                    
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("Available cars")
            .task {
                await viewModel.fetchCars()
            }
        }
    }
}


#Preview {
    CarListView()
}
