//
//  Models.swift
//  Drive Me
//
//  Created by Paul Bovtach on 24.03.2026.
//

import Foundation

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
    let carId: UUID
    let clientId: UUID
    var startDate: Date?
    var endDate: Date?
    var status: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case carId = "car_id"
        case clientId = "client_id"
        case startDate = "start_date"
        case endDate = "end_date"
        case status
    }
}
