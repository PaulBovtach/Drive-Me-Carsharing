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

enum TransmissionType: String, CaseIterable {
    case manual = "Manual"
    case automatic = "Automatic"
}

struct CarUpdateData: Codable {
    let brand: String
    let model: String
    let year: Int
    let consumption: Double
    let fuel_type: String
    let transmission_type: String
    let price_per_day: Int
    let is_available: Bool
    let description: String
}

@MainActor
class AdminCarEditViewModel: ObservableObject {
    let car: Car
    
    @Published var brand: String
    @Published var model: String
    @Published var year: Int
    @Published var consumption: String
    @Published var fuelType: FuelType
    @Published var transmissionType: TransmissionType
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
        self.transmissionType = TransmissionType(rawValue: car.transmissionType ?? "") ?? .manual
        self.priceStr = String(car.pricePerDay ?? 0)
        self.isAvailable = car.isAvailable
        self.description = car.description ?? ""
    }
    
    func updateFields() async {
        
            let parsedConsumption = Double(consumption) ?? 0.0
            let parsedPrice = Int(priceStr) ?? 0
            
            isSaving = true
            
            let dataToUpdate = CarUpdateData(
                brand: brand,
                model: model,
                year: year,
                consumption: parsedConsumption,
                fuel_type: fuelType.rawValue,
                transmission_type: transmissionType.rawValue,
                price_per_day: parsedPrice,
                is_available: isAvailable,
                description: description
            )
            
            do {
                
                try await supabase
                    .from("cars")
                    .update(dataToUpdate)
                    .eq("id", value: car.id)
                    .execute()
                
                print("ADMIN. Car \(brand) \(model) successfully updated(fields)!")
                
            } catch {
                print("Failed to update car's info: \(error.localizedDescription)")
            }
        
            isSaving = false
        }
    
    
    
    
    
}
