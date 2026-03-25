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
                        Color(red: 63/255, green: 126/255, blue: 65/255),
                        Color(red: 45/255, green: 100/255, blue: 50/255),
                        Color(red: 30/255, green: 80/255, blue: 35/255)
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
