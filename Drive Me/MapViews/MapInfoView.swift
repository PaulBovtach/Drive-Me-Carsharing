//
//  MapInfoView.swift
//  Drive Me
//

import SwiftUI
import MapKit

struct MapInfoView: View {
    @StateObject private var viewModel = MapViewModel()
    
    //49.264779, 23.870117 - Stryi, Lviv oblast
    @State private var cameraPosition: MapCameraPosition = .camera(
        MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: 49.264779, longitude: 23.870117), distance: 250000)
    )
    
    var body: some View {
        ZStack {
            // MARK: Map
            Map(position: $cameraPosition, selection: $viewModel.selectedLocation) {
                
                ForEach(viewModel.zones) { zone in
                    MapPolygon(coordinates: zone.clCoordinates)
                        .foregroundStyle(Color.green.opacity(0.2))
                        .stroke(Color.green, lineWidth: 2)
                }
                
                // Draw dots
                ForEach(viewModel.locations) { location in
                    Annotation(location.name, coordinate: location.coordinate) {
                        ZStack {
                            Circle()
                                .fill(colorFor(type: location.type))
                                .frame(width: 36, height: 36)
                                .shadow(radius: 4)
                            Image(systemName: iconFor(type: location.type))
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .bold))
                        }
                        .scaleEffect(viewModel.selectedLocation == location ? 1.5 : 1.0)
                        .animation(.spring(), value: viewModel.selectedLocation)
                    }
                    .tag(location)
                }
            }
            .mapStyle(.standard(elevation: .realistic))
            .ignoresSafeArea()
            
            // MARK: Map Legend
            VStack {
                Spacer()
                HStack {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Map Legend")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        LegendRow(color: .green, icon: "arrow.up.and.down", text: "Pickup & Drop-off")
                        LegendRow(color: .orange, icon: "flag.checkered", text: "Drop-off Only")
                        
                        HStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.green.opacity(0.4))
                                .frame(width: 20, height: 20)
                                .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.green, lineWidth: 1))
                            Text("Allowed driving zone")
                                .font(.subheadline)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(16)
                    .background(.ultraThinMaterial)
                    .environment(\.colorScheme, .dark)
                    .cornerRadius(20)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white.opacity(0.3), lineWidth: 1))
                    .padding()
                    
                    Spacer()
                }
                .padding(.bottom, 60)
            }
        }
        .task {
            await viewModel.fetchMapData()
        }
        .sheet(item: $viewModel.selectedLocation) { location in
            LocationDetailSheet(location: location, viewModel: viewModel)
                .presentationDetents([.fraction(0.35)])
                .presentationDragIndicator(.visible)
        }
        .onChange(of: viewModel.selectedLocation) { oldValue, newValue in
            if let selected = newValue {
                withAnimation(.easeInOut(duration: 1.0)) {
                    cameraPosition = .camera(
                        MapCamera(
                            centerCoordinate: selected.coordinate,
                            distance: 3000
                        )
                    )
                }
            }
        }
    }
    
    func colorFor(type: LocationType) -> Color {
        switch type {
        case .both: return .green
        case .dropoff: return .orange
        }
    }
    
    func iconFor(type: LocationType) -> String {
        switch type {
        case .both: return "arrow.up.and.down"
        case .dropoff: return "flag.checkered"
        }
    }
}

// MARK: - Legend Row View
struct LegendRow: View {
    let color: Color
    let icon: String
    let text: String
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(color)
                .frame(width: 20, height: 20)
                .overlay(Image(systemName: icon).font(.system(size: 10, weight: .bold)).foregroundColor(.white))
            Text(text)
                .font(.subheadline)
                .foregroundColor(.white)
        }
    }
}

// MARK: Sheet for details of selected location
struct LocationDetailSheet: View {
    let location: MapLocation
    @ObservedObject var viewModel: MapViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color(red: 25/255, green: 30/255, blue: 25/255).ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(location.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(location.type.rawValue)
                        .font(.subheadline)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Capsule())
                        .foregroundColor(.white)
                }
                
                HStack {
                    Text(location.address)
                        .font(.body)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    // copy btn
                    Button(action: {
                        UIPasteboard.general.string = location.address
                        let impactMed = UIImpactFeedbackGenerator(style: .medium)
                        impactMed.impactOccurred()
                    }) {
                        Image(systemName: "doc.on.doc")
                            .foregroundColor(.green)
                            .padding(10)
                            .background(Color.white.opacity(0.1))
                            .clipShape(Circle())
                    }
                }
                
                Divider().background(Color.gray)
                
                // Routes btns
                HStack(spacing: 16) {
                    Button(action: {
                        viewModel.openInAppleMaps(location: location)
                        dismiss()
                    }) {
                        Label("Apple Maps", systemImage: "map.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    
                    Button(action: {
                        viewModel.openInGoogleMaps(location: location)
                        dismiss()
                    }) {
                        Label("Google Maps", systemImage: "g.circle.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(12)
                    }
                }
                Spacer()
            }
            .padding(24)
            .padding(.top, 16)
        }
    }
}

#Preview {
    MapInfoView()
}
