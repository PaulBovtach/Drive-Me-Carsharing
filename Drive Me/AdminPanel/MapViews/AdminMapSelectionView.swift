//
//  AdminMapSelectionView.swift
//  Drive Me
//
//  Created by Paul Bovtach on 12.05.2026.
//

import SwiftUI
import MapKit

struct AdminMapSelectionView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: AdminMapViewModel
    
    @State private var cameraPosition: MapCameraPosition = .userLocation(
        fallback: .region(MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 49.8397, longitude: 24.0297),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
    )
    
    @State private var currentCenter = CLLocationCoordinate2D(latitude: 49.8397, longitude: 24.0297)
    @State private var showDetailsSheet = false
    
    var body: some View {
        ZStack {
            Map(position: $cameraPosition){
                UserAnnotation()
            }
            .onMapCameraChange(frequency: .continuous) { context in
                currentCenter = context.region.center
            }
            
            
            //static aim
            VStack {
                Image(systemName: "plus")
                    .font(.system(size: 30, weight: .light))
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.black.opacity(0.3).clipShape(Circle()))
            }
            
            VStack {
                Spacer()
                Button(action: {
                    Task{
                        await viewModel.detectAddress(latitude: currentCenter.latitude, longitude: currentCenter.longitude)
                    }
                    showDetailsSheet = true
                }) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Confirm Location")
                    }
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(40)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 50)
                }
            }
        }
        .navigationTitle("Select Location")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showDetailsSheet) {
            AdminAddLocationSheet(
                viewModel: viewModel, selectedLatitude: currentCenter.latitude,
                selectedLongitude: currentCenter.longitude
            )
            .onDisappear {
                if viewModel.isLocationSaved {
                    viewModel.isLocationSaved = false
                    dismiss()
                }
            }
            
        }
    }
}

#Preview {
    AdminMapSelectionView(viewModel: AdminMapViewModel())
}
