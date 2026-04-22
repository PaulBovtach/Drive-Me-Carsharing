//
//  AdminCarPhotoEditorView.swift
//  Drive Me
//
//  Created by Paul Bovtach on 22.04.2026.
//

import SwiftUI
import PhotosUI

struct AdminCarPhotoEditorView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm: AdminCarEditViewModel
    
    
    let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 35/255, green: 60/255, blue: 25/255)
                    .ignoresSafeArea()
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        
                        
                        ForEach(vm.existingImagesUrls, id: \.self) { urlString in
                            ZStack(alignment: .topTrailing) {
                                
                                AsyncImage(url: URL(string: urlString)) { phase in
                                    switch phase {
                                    case .empty:
                                        ZStack {
                                            Color.gray.opacity(0.2)
                                            ProgressView().tint(.white)
                                        }
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFit()
                                    case .failure:
                                        ZStack {
                                            Color.gray.opacity(0.3)
                                            Image(systemName: "photo.badge.exclamationmark")
                                                .foregroundColor(.white.opacity(0.5))
                                        }
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                                .frame(height: 100)
                                
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .clipped()
                                
                                Button {
                                    vm.removeExistingPhoto(url: urlString)
                                } label: {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundStyle(.white, .red)
                                        .font(.title2)
                                        .offset(x: 8, y: -8)
                                }
                            }
                        }
                        ForEach(vm.newPhotosToUpload) { localPhoto in
                            ZStack(alignment: .topTrailing) {
                                Image(uiImage: localPhoto.image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 150)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.green, lineWidth: 2))
                                
                                Button {
                                    vm.removeLocalPhoto(id: localPhoto.id)
                                } label: {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundStyle(.white, .red)
                                        .font(.title2)
                                        .offset(x: 8, y: -8)
                                }
                            }
                        }
                        
                        
                        PhotosPicker(selection: $vm.selectedPhotoItems, maxSelectionCount: 10, matching: .images) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [8]))
                                    .foregroundColor(.green.opacity(0.6))
                                    .frame(height: 150)
                                    .background(Color.white.opacity(0.05).cornerRadius(12))
                                
                                VStack(spacing: 8) {
                                    Image(systemName: "photo.on.rectangle.angled")
                                        .font(.largeTitle)
                                    Text("Add Photos")
                                        .font(.subheadline)
                                }
                                .foregroundColor(.green)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Manage Photos")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
            }
        }
    }
}

#Preview {
    AdminCarPhotoEditorView(vm: AdminCarEditViewModel(car: Car(id: UUID(), brand: "BWM", model: "M5", year: 2012, consumption: 10.4, fuelType: "Diesel", transmissionType: "Automatic", isAvailable: true, imageUrls: [], pricePerDay: 100, description: "BMW stands for Bayerische Motoren Werke, which translates to Bavarian Motor Works in English. It is a renowned German manufacturer of luxury automobiles, motorcycles, and engines headquartered in Munich, known for its focus on performance, innovation, and premium engineering. ")))
}
