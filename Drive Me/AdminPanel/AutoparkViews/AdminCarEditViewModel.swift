import Foundation
import Combine
import Supabase
import SwiftUI
import PhotosUI

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

struct LocalPhoto: Identifiable {
    let id = UUID()
    let data: Data
    let image: UIImage
}

@MainActor
class AdminCarEditViewModel: ObservableObject {
    let car: Car
    
    let years = Array(1900...Calendar.current.component(.year, from: Date()))
    
    //buffer of fields
    @Published var brand: String
    @Published var model: String
    @Published var year: Int
    @Published var consumption: String
    @Published var fuelType: FuelType
    @Published var transmissionType: TransmissionType
    @Published var priceStr: String
    @Published var isAvailable: Bool
    @Published var description: String
    
    //buffer of photos
    @Published var existingImagesUrls: [String]
    @Published var newPhotosToUpload: [LocalPhoto] = []
    @Published var selectedPhotoItems: [PhotosPickerItem] = [] {
        didSet { handlePhotoSelection() }
    }
    
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
        
        self.existingImagesUrls = car.imageUrls ?? []
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
    
    
    //MARK: Photo Editor
    func handlePhotoSelection(){
        Task{
            for item in selectedPhotoItems {
                do{
                    if let data = try await item.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data){
                        let localPhoto = LocalPhoto(data: data, image: uiImage)
                        self.newPhotosToUpload.append(localPhoto)
                    }
                }catch{
                    print("ADMIN. Failed to handle new photos from gallery: \(error.localizedDescription)")
                }
            }
            self.selectedPhotoItems.removeAll()
        }
    }
    
    func removeExistingPhoto(url: String) {
        existingImagesUrls.removeAll() {$0 == url}
    }
    
    func removeLocalPhoto(id: UUID) {
        newPhotosToUpload.removeAll() {$0.id == id}
    }
    
    
    //MARK: Compressing and Uploading photos
    func uploadAndCompressPhotos() async {
        
        guard !newPhotosToUpload.isEmpty else {return}
        
        isSaving = true
        
        var newlyUpdatedUrls: [String] = []
        
        for localPhoto in newPhotosToUpload {
            
            //compressing
            guard let compressedData = localPhoto.image.jpegData(compressionQuality: 0.6) else {
                print("ADMIN. Failed to compress photo.")
                continue
            }
            
            let filename = "\(car.id)/\(UUID().uuidString)"
            do{
                //uploading to bucket
                try await supabase
                    .storage
                    .from("car_images")
                    .upload(filename, data: compressedData, options: FileOptions(contentType: "image/jpeg"))
                
                //getting link
                let publicUrl = try supabase.storage
                    .from("car_images")
                    .getPublicURL(path: filename)
                
                newlyUpdatedUrls.append(publicUrl.absoluteString)
            }catch{
                print("Failed to upload photo \(filename): \(error.localizedDescription)")
            }
        }
        
        if !newlyUpdatedUrls.isEmpty {
            self.existingImagesUrls.append(contentsOf: newlyUpdatedUrls)
            self.newPhotosToUpload.removeAll()
            
            print("ADMIN. Successfully uploaded \(newlyUpdatedUrls.count) new photos!")
        }
        
        isSaving = false
    }
    
    func updatePhotosInDB() async {
        do {
            try await supabase
                .from("cars")
                .update(["image_urls": existingImagesUrls])
                .eq("id", value: car.id)
                .execute()
            print("ADMIN. Image URLs successfully synced with DB!")
        } catch {
            print("ADMIN. Failed to sync image URLs: \(error.localizedDescription)")
        }
    }
    
    
    
    
    
    
    
    
    
}
