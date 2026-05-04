//
//  AdminMapViewModel.swift
//  Drive Me
//
//  Created by Paul Bovtach on 04.05.2026.
//

import Foundation
import SwiftUI
import MapKit
import Combine
import Supabase

enum AdminMapTab: String, CaseIterable {
    case map = "Map"
    case list = "List"
}

@MainActor
class AdminMapViewModel: ObservableObject {
    @Published var locations: [MapLocation] = []
    @Published var zones: [MapZone] = []
    @Published var selectedLocation: MapLocation?
    @Published var isLoading = false
    
    @Published var selectedTab: AdminMapTab = .map
    
    var sortedLocations: [MapLocation] {
            locations.sorted {
                if $0.type != $1.type {
                    return $0.type == .both
                }
                return $0.name < $1.name
            }
        }
    
    // MARK: Fetch Data from Supabase
    func fetchMapData() async {
        isLoading = true
        do {
            let fetchedLocations: [MapLocation] = try await supabase
                .from("locations")
                .select()
                .execute()
                .value
            
            let fetchedZones: [MapZone] = try await supabase
                .from("zones")
                .select()
                .execute()
                .value
            
            self.locations = fetchedLocations
            self.zones = fetchedZones
            print("Fetched \(locations.count) locations and \(zones.first?.coordinates.count ?? 0) zones")
            
        } catch {
            print("Failed to fetch locations: \(error.localizedDescription)")
        }
        isLoading = false
    }
    
    func deleteLocationImmediately(id: UUID) async {
        do {
            try await supabase.from("locations").delete().eq("id", value: id).execute()
            
            await fetchMapData()
            
            if selectedLocation?.id == id {
                selectedLocation = nil
            }
            
            print("ADMIN. Location deleted successfully!")
        } catch {
            print("ADMIN. Delete error: \(error.localizedDescription)")
        }
    }
    
    // MARK: Logics to go to another apps (Maps, GoogleMaps)
    func openInAppleMaps(location: MapLocation) {
        let clLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        let mapItem = MKMapItem(location: clLocation, address: nil)
        mapItem.name = location.name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    
    func openInGoogleMaps(location: MapLocation) {
        if let url = URL(string: "comgooglemaps://?daddr=\(location.latitude),\(location.longitude)&directionsmode=driving"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            if let webUrl = URL(string: "https://www.google.com/maps/dir/?api=1&destination=\(location.latitude),\(location.longitude)") {
                UIApplication.shared.open(webUrl)
            }
        }
    }
}
