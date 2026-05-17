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
                
                if viewModel.selectedTab == .map {
                    AdminMapView(viewModel: viewModel)
                        .transition(.opacity)
                }
                
                VStack(spacing: 0) {
                    
                    Picker("View Mode", selection: $viewModel.selectedTab) {
                        ForEach(AdminMapTab.allCases, id: \.self) { tab in
                            Text(tab.rawValue).tag(tab)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    .environment(\.colorScheme, .dark)
                    .background {
                        if viewModel.selectedTab == .map {
                            Rectangle()
                                .fill(.ultraThinMaterial)
                                .ignoresSafeArea(edges: .top)
                        }
                    }
                    
                    if viewModel.selectedTab == .list {
                        AdminLocationListView(viewModel: viewModel)
                            .transition(.opacity)
                    } else {
                        Spacer()
                    }
                }
            }
            .animation(.easeInOut(duration: 0.2), value: viewModel.selectedTab)
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
