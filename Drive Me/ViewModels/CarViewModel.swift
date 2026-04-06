//
//  CarViewModel.swift
//  Drive Me
//
//  Created by Paul Bovtach on 24.03.2026.
//

import Foundation
import Supabase
import Combine

@MainActor
class CarViewModel: ObservableObject {
    
    @Published var cars: [Car] = []
    @Published var isLoading = false
    
    // fetching list of cars
    func fetchCars() async {
        isLoading = true
        
        do {
            // make a request to supabase client
            let fetchedCars: [Car] = try await supabase.from("cars").select().execute().value
            
            self.cars = fetchedCars
            
        } catch {
            print("Error while fethcing cars list: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    
    
}



