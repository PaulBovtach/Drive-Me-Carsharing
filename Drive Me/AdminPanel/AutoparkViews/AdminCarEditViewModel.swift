import Foundation
import Combine
import Supabase
import SwiftUI

enum FuelType: String, CaseIterable {
    case diesel = "Diesel"
    case gasoline = "Gasoline"
    case gasGasoline = "Gas/Gasoline"
    case hybrid = "Hybrid"
    case electro = "Electro"
}

@MainActor
class AdminCarEditViewModel: ObservableObject {
    let car: Car
    
    @Published var brand: String
    @Published var model: String
    @Published var year: Int
    @Published var consumption: String
    @Published var fuelType: FuelType
    @Published var priceStr: String
    @Published var isAvailable: Bool
    @Published var description: String
    
    @Published var isSaving = false
    
    init(car: Car) {
        self.car = car
        self.brand = car.brand ?? ""
        self.model = car.model ?? ""
        self.year = car.year ?? 2000
        self.consumption = String(car.consumption ?? 0.0)
        self.fuelType = FuelType(rawValue: car.fuelType ?? "") ?? .electro
        self.priceStr = String(car.pricePerDay ?? 0)
        self.isAvailable = car.isAvailable
        self.description = car.description ?? ""
    }
    
    
    
}
