import SwiftUI

struct AdminLocationListView: View {
    @ObservedObject var viewModel: AdminMapViewModel
    
    @State private var locationToDelete: MapLocation?
    @State private var showDeleteAlert = false
    
    var body: some View {
        List {
            if viewModel.locations.isEmpty {
                Text("No locations available. Switch to Map to add some.")
                    .foregroundColor(.gray)
                    .listRowBackground(Color.clear)
            }
            
            ForEach(viewModel.sortedLocations) { location in
                Button {
                    viewModel.selectedLocation = location
                } label: {
                    AdminLocationRowView(location: location)
                }
                .listRowBackground(Color.white.opacity(0.05))
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        locationToDelete = location
                        showDeleteAlert = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                            .tint(.red)
                    }
                    .tint(.red)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .toolbar{
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    AdminMapSelectionView(viewModel: viewModel)
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                }
            }
        }
        
        .alert("Confirm Deletion", isPresented: $showDeleteAlert, presenting: locationToDelete) { location in
            Button("Cancel", role: .cancel) {
                locationToDelete = nil
            }
            Button("Delete", role: .destructive) {
                Task {
                    await viewModel.deleteLocationImmediately(id: location.id)
                    locationToDelete = nil
                }
            }
        } message: { location in
            Text("Are you sure you want to delete '\(location.name)'? This action cannot be undone.")
        }
        
    }
}

struct AdminLocationRowView: View {
    let location: MapLocation
    
    var body: some View {
        HStack(spacing: 16) {
            
            MapMarkerIconView(
                color: location.type == .both ? .green : .orange,
                icon: location.type == .both ? "arrow.up.and.down" : "flag.checkered",
                scale: 1.5 
            )
            .offset(y: -6)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(location.name)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(location.address)
                    .font(.subheadline)
                    .foregroundColor(Color.white.opacity(0.8))
                
                Text(location.type.rawValue)
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.white.opacity(0.15))
                    .clipShape(Capsule())
                    .foregroundColor(location.type == .both ? .green : .orange)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray.opacity(0.5))
                .font(.caption)
        }
        .padding(.vertical, 4)
    }
}

