//
//  Models.swift
//  Drive Me
//
//  Created by Paul Bovtach on 24.03.2026.
//

import Foundation
import CoreLocation

// MARK: - User profile model (table profiles)
struct UserProfile: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String?
    var surname: String?
    var role: String?
    var phoneNumber: String?
    var email: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case surname
        case role
        case phoneNumber = "phone_number"
        case email
    }
}

// MARK: - Car model (table cars)
struct Car: Identifiable, Codable, Hashable {
    let id: UUID
    var brand: String?
    var model: String?
    var year: Int?
    var consumption: Double?
    var fuelType: String?
    var transmissionType: String?
    var isAvailable: Bool
    var imageUrls: [String]?
    var pricePerDay: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case brand
        case model
        case year
        case consumption
        case fuelType = "fuel_type"
        case transmissionType = "transmission_type"
        case isAvailable = "is_available"
        case imageUrls = "image_urls"
        case pricePerDay = "price_per_day"
    }
}

// MARK: - Booking Model (table bookings)
struct Booking: Identifiable, Codable, Hashable {
    let id: UUID
    let clientId: UUID
    let carId: UUID
    var startDate: Date
    var endDate: Date
    var status: String
    var cost: Int
    
    var car: Car?
    
    enum CodingKeys: String, CodingKey {
        case id
        case clientId = "client_id"
        case carId = "car_id"
        case startDate = "start_date"
        case endDate = "end_date"
        case status
        case cost
        case car = "cars"
    }
}


// MARK: - Map Models

// types of locations
enum LocationType: String, Codable{
    case dropoff = "Drop-off Only"
    case both = "Pickup & Drop-off"
}

// map location for dot
struct MapLocation: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    let type: LocationType
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

// struct for json parsing zones
struct ZoneCoordinate: Codable, Hashable {
    let lat: Double
    let lng: Double
    
    var clCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
}

// map location for zones (polygon)
struct MapZone: Identifiable, Codable {
    let id: UUID
    var name: String
    var coordinates: [ZoneCoordinate]
    
    var clCoordinates: [CLLocationCoordinate2D] {
        coordinates.map { $0.clCoordinate }
    }
}

