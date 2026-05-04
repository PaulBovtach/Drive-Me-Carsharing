import SwiftUI
import MapKit

struct AdminMapDashboardView: View {
    @StateObject private var viewModel = AdminMapViewModel()
    @StateObject private var locationManager = LocationManager()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 50/255, green: 80/255, blue: 40/255),
                        Color(red: 35/255, green: 60/255, blue: 25/255),
                        Color(red: 20/255, green: 40/255, blue: 15/255)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                
                // Перемикання між картою та списком
                if viewModel.selectedTab == .map {
                    AdminMapView(viewModel: viewModel)
                } else {
                    AdminLocationListComponent(viewModel: viewModel)
                }
            }
            .safeAreaInset(edge: .top) {
                VStack {
                    Picker("View Mode", selection: $viewModel.selectedTab) {
                        ForEach(AdminMapTab.allCases, id: \.self) { tab in
                            Text(tab.rawValue).tag(tab)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding()
                }
                .background(.ultraThinMaterial)
                .environment(\.colorScheme, .dark)
            }
            .navigationTitle("Manage Locations")
            .navigationBarTitleDisplayMode(.inline)
            
        }
        .task {
            await viewModel.fetchMapData()
        }
        .sheet(item: $viewModel.selectedLocation) { location in
            AdminLocationDetailSheetView(location: location, viewModel: viewModel)
                .presentationDetents([.fraction(0.35)])
                .presentationDragIndicator(.visible)
        }
    }
}

struct AdminLocationListComponent: View {
    @ObservedObject var viewModel: AdminMapViewModel
    
    var body: some View {
        List {
            if viewModel.locations.isEmpty {
                Text("No locations available.")
                    .foregroundColor(.gray)
                    .listRowBackground(Color.clear)
            }
            
            ForEach(viewModel.locations) { location in
                Button {
                    viewModel.selectedLocation = location
                } label: {
                    HStack(spacing: 16) {
                        Circle()
                            .fill(location.type == .both ? Color.green : Color.orange)
                            .frame(width: 12, height: 12)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(location.name)
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Text(location.address)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray.opacity(0.5))
                            .font(.caption)
                    }
                    .padding(.vertical, 4)
                }
                .listRowBackground(Color.white.opacity(0.05))
            }
        }
        .scrollContentBackground(.hidden)
    }
}
