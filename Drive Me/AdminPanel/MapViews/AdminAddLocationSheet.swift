//
//  AdminAddLocationSheet.swift
//  Drive Me
//
//  Created by Paul Bovtach on 12.05.2026.
//

import SwiftUI

struct AdminAddLocationSheet: View {
    @Environment(\.dismiss) var dismiss
    
    let selectedLatitude: Double
    let selectedLongitude: Double
    
    @State private var locationName: String = ""
    @State private var locationType: String = "pickup_dropoff"
    
    let locationTypes = [
        ("Pickup & Drop-off", "pickup_dropoff"),
        ("Drop-off Only", "dropoff_only")
    ]
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Location Details")) {
                    TextField("Enter location name", text: $locationName)
                    
                    Picker("Type", selection: $locationType) {
                        ForEach(locationTypes, id: \.1) { display, value in
                            Text(display).tag(value)
                        }
                    }
                }
                
                Section(header: Text("Coordinates")) {
                    Text("Lat: \(selectedLatitude)")
                        .foregroundColor(.gray)
                    Text("Lng: \(selectedLongitude)")
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("New Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        //saveLocationToDatabase
                    }
                    .disabled(locationName.isEmpty)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}

#Preview {
    AdminAddLocationSheet(selectedLatitude: 0.0, selectedLongitude: 0.0)
}
