import SwiftUI
import MapKit
import Combine
import Supabase

@MainActor
class MapViewModel: ObservableObject {
    @Published var locations: [MapLocation] = []
    @Published var zones: [MapZone] = []
    @Published var selectedLocation: MapLocation?
    @Published var isLoading = false
    
    // MARK: Fetch Data from Supabase
    func fetchMapData() async {
        isLoading = true
        do {
            // fetch dots
            let fetchedLocations: [MapLocation] = try await supabase
                .from("locations")
                .select()
                .execute()
                .value
            
            // fetch zones for polygon
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
