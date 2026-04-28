//
//  AdminAddCarViewModel.swift
//  Drive Me
//
//  Created by Paul Bovtach on 25.04.2026.
//

import Foundation
import Combine
import Supabase
import SwiftUI
import PhotosUI

@MainActor
class AdminAddCarViewModel: ObservableObject {
    
    let years = Array(1900...Calendar.current.component(.year, from: Date())).reversed()
    
    @Published var brand: String = ""
    @Published var model: String = ""
    @Published var year: Int = Calendar.current.component(.year, from: Date())
    @Published var consumption: String = ""
    @Published var fuelType: FuelType = .diesel
    @Published var transmissionType: TransmissionType = .automatic
    @Published var priceStr: String = ""
    @Published var isAvailable: Bool = true
    @Published var description: String = ""
    
    @Published var newPhotosToUpload: [LocalPhoto] = []
    @Published var selectedPhotoItems: [PhotosPickerItem] = [] {
        didSet { handlePhotoSelection() }
    }
    
    @Published var isSaving = false
    
    var hasChanges: Bool {
        return !brand.isEmpty ||
        !model.isEmpty ||
        !priceStr.isEmpty ||
        !consumption.isEmpty ||
        !description.isEmpty ||
        !newPhotosToUpload.isEmpty
    }
    
    
    
    //struct to create new row in "cars" table
    struct CarInsert: Codable{
        let id: UUID
        var brand: String
        var model: String
        var year: Int
        var consumption: Double
        var fuel_type: String
        var transmission_type: String
        var is_available: Bool
        var image_urls: [String]?
        var price_per_day: Int
        var description: String?
    }
    
    
    func handlePhotoSelection() {
        let itemsToProcess = selectedPhotoItems
        guard !itemsToProcess.isEmpty else { return }
        self.selectedPhotoItems.removeAll()
        
        Task {
            for item in itemsToProcess {
                do {
                    if let data = try await item.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        let localPhoto = LocalPhoto(data: data, image: uiImage)
                        self.newPhotosToUpload.append(localPhoto)
                    }
                } catch {
                    print("ADMIN. Failed to handle new photos: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func removeLocalPhoto(id: UUID) {
        newPhotosToUpload.removeAll() { $0.id == id }
    }
    
    func saveNewCar() async -> Bool {
        
        guard !brand.isEmpty, !model.isEmpty, !priceStr.isEmpty else {
            print("ADMIN. Fill required fields!")
            return false
        }
        
        isSaving = true
        defer { isSaving = false }
        
        let newCarId = UUID()
        var uploadedUrls: [String] = []
        
        // uploading photos to bucket
        for localPhoto in newPhotosToUpload {
            guard let compressedData = localPhoto.image.jpegData(compressionQuality: 0.6) else { continue }
            let filename = "\(newCarId.uuidString)/\(UUID().uuidString).jpg"
            
            do {
                try await supabase.storage.from("car_images").upload(
                    filename,
                    data: compressedData,
                    options: FileOptions(contentType: "image/jpeg")
                )
                let publicUrl = try supabase.storage.from("car_images").getPublicURL(path: filename)
                uploadedUrls.append(publicUrl.absoluteString)
            } catch {
                print("Failed to upload photo: \(error.localizedDescription)")
            }
        }
        
        // forming object for supabase table
        let parsedConsumption = Double(consumption.replacingOccurrences(of: ",", with: ".")) ?? 0.0
        let parsedPrice = Int(priceStr) ?? 0
        
        
        let newCarData = CarInsert(
            id: newCarId,
            brand: brand,
            model: model,
            year: year,
            consumption: parsedConsumption,
            fuel_type: fuelType.rawValue,
            transmission_type: transmissionType.rawValue,
            is_available: isAvailable,
            image_urls: uploadedUrls,
            price_per_day: parsedPrice,
            description: description
        )
     
        
        // saving data to "cars"
        do {
            try await supabase
                .from("cars")
                .insert(newCarData)
                .execute()
            
            print("ADMIN. Car \(brand) \(model) successfully added!")
            return true
        } catch {
            print("ADMIN. Failed to insert new car: \(error.localizedDescription)")
            return false
        }
    }
    
    
    
    
    
    
}
