//
//  AdminMapSelectionView.swift
//  Drive Me
//
//  Created by Paul Bovtach on 12.05.2026.
//

import SwiftUI
import MapKit

struct AdminMapSelectionView: View {
    @State private var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 49.8397, longitude: 24.0297),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    ))
    
    @State private var currentCenter = CLLocationCoordinate2D(latitude: 49.8397, longitude: 24.0297)
    @State private var showDetailsSheet = false
    
    var body: some View {
        ZStack {
            Map(position: $cameraPosition)
                .onMapCameraChange(frequency: .continuous) { context in
                    currentCenter = context.region.center
                }
            
            //static aim
            VStack {
                Image(systemName: "scope")
                    .font(.system(size: 30, weight: .light))
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.black.opacity(0.3).clipShape(Circle()))
                    .offset(y: -15)
            }
            
            VStack {
                Spacer()
                Button(action: {
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
                selectedLatitude: currentCenter.latitude,
                selectedLongitude: currentCenter.longitude
            )
            
        }
    }
}

#Preview {
    AdminMapSelectionView()
}
