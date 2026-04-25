//
//  AutoparkListViewModel.swift
//  Drive Me
//
//  Created by Paul Bovtach on 16.04.2026.
//

import Foundation
import SwiftUI
import Supabase
import Combine

enum CarFilter: String, CaseIterable {
    case all = "All"
    case available = "Available"
    case unavailable = "Unavailable"
}

@MainActor
class AutoparkListViewModel: ObservableObject {
    
    @Published var cars: [Car] = []
    @Published var isLoading = false
    @Published var selectedFilter: CarFilter = .all
    
    var totalCarsCount: Int {
        return cars.count
    }
    
    var availableCarsCount: Int {
        return cars.filter { $0.isAvailable }.count
    }
    
    var filteredCars: [Car] {
        switch selectedFilter {
        case .all:
            return cars
        case .available:
            return cars.filter { $0.isAvailable }
        case .unavailable:
            return cars.filter { !$0.isAvailable }
        }
    }
    
    func fetchCars(isRefreshing: Bool = false) async {
        
        isLoading = true
        
        do{
            
            if isRefreshing {
                try? await Task.sleep(nanoseconds: 300_000_000)
            }
            
            let fetchedCars: [Car] = try await supabase
                .from("cars").select().order("brand", ascending: true).execute().value
            
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                self.cars = fetchedCars
            }
            print("ADMIN. Successfully fetched cars to autopark!")
            
        }catch {
            print("ADMIN. Failed to fetch cars to autopark: \(error.localizedDescription)")
        }
        
        isLoading = false
        
    }
    
    
    
    
    
    
    
}
