//
//  CarViewModel.swift
//  Drive Me
//
//  Created by Paul Bovtach on 24.03.2026.
//

import Foundation
import Supabase
import Combine
import SwiftUI

@MainActor
class CarViewModel: ObservableObject {
    
    @Published var cars: [Car] = []
    @Published var isLoading = false
    
    // fetching list of cars
    func fetchCars(isRefreshing: Bool = false) async {
        //isLoading = true
        
        if !isRefreshing {
            isLoading = true
        }
        
        do {
            
            if isRefreshing {
                try? await Task.sleep(nanoseconds: 300_000_000) // 0.3 секунди
            }
            // make a request to supabase client
            let fetchedCars: [Car] = try await supabase.from("cars").select().execute().value
            
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                self.cars = fetchedCars
            }
            
            
            
            
        } catch {
            print("Error while fethcing cars list: \(error.localizedDescription)")
        }
        
        if !isRefreshing {
            isLoading = false
        }
    }
    
    
    
}



