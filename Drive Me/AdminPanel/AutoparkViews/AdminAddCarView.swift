//
//  AdminAddCarView.swift
//  Drive Me
//
//  Created by Paul Bovtach on 25.04.2026.
//

import SwiftUI

import SwiftUI
import BetterSwiftUITextEditor
import PhotosUI

struct AdminAddCarView: View {
    @StateObject private var vm = AdminAddCarViewModel()
    @Environment(\.dismiss) var dismiss
    
    @State private var showCancelAlert = false
    
    let columns = [GridItem(.adaptive(minimum: 100), spacing: 12)]
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 50/255, green: 80/255, blue: 40/255),
                        Color(red: 20/255, green: 40/255, blue: 15/255)
                    ]),
                    startPoint: .top, endPoint: .bottom
                ).ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        //photos section
                        VStack(alignment: .leading) {
                            Text("Photos").font(.title3.bold()).foregroundColor(.white)
                            
                            LazyVGrid(columns: columns, spacing: 12) {
                                ForEach(vm.newPhotosToUpload) { localPhoto in
                                    ZStack(alignment: .topTrailing) {
                                        Image(uiImage: localPhoto.image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(height: 100)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                        
                                        Button {
                                            withAnimation { vm.removeLocalPhoto(id: localPhoto.id) }
                                        } label: {
                                            Image(systemName: "minus.circle.fill")
                                                .foregroundStyle(.white, .red)
                                                .offset(x: 8, y: -8)
                                        }
                                    }
                                }
                                PhotosPicker(selection: $vm.selectedPhotoItems, maxSelectionCount: 10, matching: .images) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12)
                                            .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [8]))
                                            .foregroundColor(.green.opacity(0.6))
                                            .frame(height: 100)
                                            .background(Color.white.opacity(0.05).cornerRadius(12))
                                        
                                        VStack {
                                            Image(systemName: "camera.fill").font(.title2)
                                            Text("Add").font(.caption)
                                        }.foregroundColor(.green)
                                    }
                                }
                            }
                        }
                        .padding()
                        .glassEffect()
                        
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Vehicle Details")
                                .font(.title3.bold())
                                .foregroundColor(.white)
                            
                            if !vm.errorMessage.isEmpty {
                                Text(vm.errorMessage)
                                    .font(.footnote)
                                    .foregroundColor(.red)
                                    .transition(.opacity)
                            }
                            
                            //car brand
                            VStack(alignment: .leading, spacing: 4){
                                Text("Car Brand").font(.caption).foregroundStyle(.gray).padding(.leading, 4)
                                
                                TextField("", text: $vm.brand, prompt: Text("Brand Name").foregroundStyle(.gray.opacity(0.9)))
                                    .keyboardType(.default)
                                    .textInputAutocapitalization(.words)
                                    .autocorrectionDisabled(true)
                                    .padding(10)
                                    .background(Color.white.opacity(0.8))
                                    .foregroundColor(.black)
                                    .clipShape(.rect(cornerRadius: 15))
                            }
                            //car model
                            VStack(alignment: .leading, spacing: 4){
                                Text("").font(.caption).foregroundStyle(.gray).padding(.leading, 4)
                                
                                TextField("", text: $vm.model, prompt: Text("Model Name").foregroundStyle(.gray.opacity(0.9)))
                                    .keyboardType(.default)
                                    .textInputAutocapitalization(.words)
                                    .autocorrectionDisabled(true)
                                    .padding(10)
                                    .background(Color.white.opacity(0.8))
                                    .foregroundColor(.black)
                                    .clipShape(.rect(cornerRadius: 15))
                            }
                            
                            //price and car year
                            HStack(alignment: .center, spacing: 10){
                                //price
                                VStack(alignment: .leading, spacing: 4){
                                    Text("Price per day").font(.caption).foregroundStyle(.gray).padding(.leading, 4)
                                    HStack {
                                        TextField("Price", text: $vm.priceStr)
                                            .keyboardType(.numberPad)
                                        
                                        Text("$")
                                            .foregroundColor(.gray)
                                    }
                                    .foregroundStyle(.black)
                                    .padding(10)
                                    
                                    .background(Color.white.opacity(0.8))
                                    .clipShape(.rect(cornerRadius: 15))
                                }
                                //car year
                                VStack (alignment: .leading, spacing: 4){
                                    Text("Car Year").font(.caption).foregroundStyle(.gray).padding(.leading, 4)
                                    
                                    Picker("Car Year", selection: $vm.year) {
                                        ForEach(vm.years, id: \.self){ year in
                                            Text(String(year))
                                                .tag(year)
                                        }
                                    }
                                    .padding(4)
                                    .background(Color.white.opacity(0.8))
                                    .clipShape(.rect(cornerRadius: 15))
                                    .tint(Color.black)
                                    
                                }
                            }
                            //consumption and fuel type
                            HStack(alignment: .center, spacing: 10){
                                //consumption
                                VStack(alignment: .leading, spacing: 4){
                                    Text("Consumption").font(.caption).foregroundStyle(.gray).padding(.leading, 4)
                                    HStack {
                                        TextField("", text: $vm.consumption)
                                            .keyboardType(.decimalPad)
                                        
                                        Text("L/100km")
                                            .foregroundColor(.gray)
                                    }
                                    .foregroundStyle(.black)
                                    .padding(10)
                                    .background(Color.white.opacity(0.8))
                                    .clipShape(.rect(cornerRadius: 15))
                                }
                                
                                //fuel type
                                VStack(alignment: .leading, spacing: 4){
                                    Text("Fuel Type").font(.caption).foregroundStyle(.gray).padding(.leading, 4)
                                    
                                    Picker("Fuel Type", selection: $vm.fuelType) {
                                        ForEach(FuelType.allCases, id: \.self) { type in
                                            Text(type.rawValue)
                                                .tag(type)
                                        }
                                    }
                                    .padding(4)
                                    .background(Color.white.opacity(0.8))
                                    .clipShape(.rect(cornerRadius: 15))
                                    .tint(Color.black)
                                }
                            }
                            
                            VStack (alignment: .leading, spacing: 4){
                                Text("Transmission Type").font(.caption).foregroundStyle(.gray).padding(.leading, 4)
                                
                                Picker("Transmission", selection: $vm.transmissionType) {
                                    ForEach(TransmissionType.allCases, id: \.self){ type in
                                        Text(String(type.rawValue))
                                            .tag(type)
                                    }
                                }
                                .padding(4)
                                .background(Color.white.opacity(0.8))
                                .clipShape(.rect(cornerRadius: 15))
                                .tint(Color.black)
                                
                            }
                              
                            
                            Divider().background(Color.white.opacity(0.2)).padding(.vertical, 4)
                            
                            //description
                            VStack(alignment: .leading, spacing: 4){
                                Text("Description").font(.caption).foregroundStyle(.gray).padding(.leading, 4)
                                
                                BetterEditor(text: $vm.description, placeholder: "Car description", maxHeight: 100)
                                    .betterEditorScrollIndicators(.visible)
                                    
                                    .foregroundStyle(.black)
                                    .frame(minHeight: 100)
                                    .padding()
                                    .background(Color.white.opacity(0.8))
                                    .clipShape(.rect(cornerRadius: 15))
                                    
                            }
                            
                            Divider().background(Color.white.opacity(0.2)).padding(.vertical, 4)
                           
                        }
                        .padding()
                        .glassEffect()
                    }
                    .padding()
                }
                
                if vm.isSaving {
                    ZStack {
                        Color.black.opacity(0.4).ignoresSafeArea()
                        ProgressView("Publishing...").tint(.white).foregroundColor(.white).scaleEffect(1.2)
                    }
                }
            }
            .navigationTitle("Add New Car")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        if vm.hasChanges {
                            showCancelAlert = true
                        }else{
                            dismiss()
                        }
                    }
                    .foregroundColor(.white)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Publish") {
                        Task {
                            let success = await vm.saveNewCar()
                            if success { dismiss() }
                        }
                    }
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                }
            }
            .alert("Unsaved Changes", isPresented: $showCancelAlert) {
                Button("Discard", role: .destructive) { dismiss() }
                Button("Cancel", role: .cancel) {}
            }message: {
                Text("Are you sure you want to discard changes while creating new car? All entered data will be lost.")
            }
        }
    }
}

#Preview {
    AdminAddCarView()
}
