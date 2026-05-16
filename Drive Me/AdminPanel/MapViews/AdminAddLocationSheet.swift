//
//  AdminAddLocationSheet.swift
//  Drive Me
//
//  Created by Paul Bovtach on 12.05.2026.
//

import SwiftUI

struct AdminAddLocationSheet: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: AdminMapViewModel
    
    let selectedLatitude: Double
    let selectedLongitude: Double
    @State private var locationType: LocationType = .both
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Location Details")) {
                    TextField("Enter location name", text: $viewModel.newLocationName)
                    TextField("Enter location address", text: $viewModel.newLocationAddress)
                    
                    Picker("Type", selection: $locationType) {
                        ForEach(LocationType.allCases, id: \.self) {type in
                            Text(type.rawValue)
                                .tag(type)
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
                    Button("Cancel") {
                        viewModel.newLocationName = ""
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        Task{
                            await viewModel.addNewLocation(latitude: selectedLatitude, longitude: selectedLongitude, type: locationType)
                            dismiss()
                        }
                    }
                    .disabled(viewModel.newLocationName.isEmpty)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}

#Preview {
    AdminAddLocationSheet(viewModel: AdminMapViewModel(), selectedLatitude: 0.0, selectedLongitude: 0.0)
}
