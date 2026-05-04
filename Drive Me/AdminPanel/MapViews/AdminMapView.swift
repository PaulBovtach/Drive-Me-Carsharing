import SwiftUI
import MapKit

struct AdminMapView: View {
    @ObservedObject var viewModel: AdminMapViewModel
    @StateObject private var locationManager = LocationManager()
    
    let initialCamera = MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: 49.264779, longitude: 23.870117), distance: 250000)
    
    @State private var cameraPosition: MapCameraPosition
    @State private var currentCamera: MapCamera
    
    init(viewModel: AdminMapViewModel) {
        self.viewModel = viewModel
        _cameraPosition = State(initialValue: .camera(MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: 49.264779, longitude: 23.870117), distance: 250000)))
        _currentCamera = State(initialValue: MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: 49.264779, longitude: 23.870117), distance: 250000))
    }
    
    var body: some View {
        ZStack {
            Map(position: $cameraPosition, selection: $viewModel.selectedLocation) {
                UserAnnotation()
                
                ForEach(viewModel.zones) { zone in
                    MapPolygon(coordinates: zone.clCoordinates)
                        .foregroundStyle(Color.green.opacity(0.2))
                        .stroke(Color.green, lineWidth: 2)
                }
                
                ForEach(viewModel.locations) { location in
                    Marker(location.name, systemImage: iconFor(type: location.type), coordinate: location.coordinate)
                        .tint(colorFor(type: location.type))
                        .tag(location)
                }
            }
            .mapStyle(.standard(elevation: .realistic))
            .mapControls {
                MapCompass()
                MapScaleView()
                MapPitchToggle()
            }
            .onMapCameraChange { context in
                currentCamera = context.camera
            }
            
            // MARK: Map Legend
            VStack {
                Spacer()
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Map Legend")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Spacer(minLength: 20)
                            
                            // Re-centre
                            Button(action: {
                                withAnimation(.easeInOut(duration: 1.0)) {
                                    cameraPosition = .camera(initialCamera)
                                    viewModel.selectedLocation = nil
                                }
                            }) {
                                Image(systemName: "location.circle")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.white.opacity(0.2))
                                    .clipShape(Circle())
                            }
                        }
                        
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
                .padding(.bottom, 10)
            }
        }
        .onChange(of: viewModel.selectedLocation) { oldValue, newValue in
            if let selected = newValue {
                withAnimation(.easeInOut(duration: 0.7)) {
                    cameraPosition = .camera(
                        MapCamera(
                            centerCoordinate: selected.coordinate,
                            distance: 4500
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
