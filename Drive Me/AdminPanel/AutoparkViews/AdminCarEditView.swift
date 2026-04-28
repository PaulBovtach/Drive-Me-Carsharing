import SwiftUI
import BetterSwiftUITextEditor

struct AdminCarEditView: View {
    @StateObject private var vm: AdminCarEditViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var showPhotoEditor = false
    
    
    init(car: Car) {
        _vm = StateObject(wrappedValue: AdminCarEditViewModel(car: car))
    }
    
    
    var body: some View {
        ZStack {

            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 50/255, green: 80/255, blue: 40/255),
                    Color(red: 20/255, green: 40/255, blue: 15/255)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    ZStack(alignment: .topTrailing){
                        ImageCardCarousel(car: vm.car)
                        
                        VStack{
                            Button{
                                showPhotoEditor = true
                            }label: {
                                Image(systemName: "pencil.circle")
                                    .font(.system(size: 32, weight: .medium))
                                    
                            }
                            .background(Color.green)
                            .buttonStyle(.glass)
                            .clipShape(.capsule)
                            .environment(\.colorScheme, .dark)
                        }
                        .padding(.trailing, 15)
                    }
                    
                    
                        
                    
                    // form
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Vehicle Details")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                        
                        //car brand
                        VStack(alignment: .leading, spacing: 4){
                            Text("Car Brand").font(.caption).foregroundStyle(.gray).padding(.leading, 4)
                            
                            TextField("Brand", text: $vm.brand, prompt: Text("Brand Name").foregroundStyle(.gray.opacity(0.9)))
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
                            Text("Car Model").font(.caption).foregroundStyle(.gray).padding(.leading, 4)
                            
                            TextField("Model", text: $vm.model, prompt: Text("Model Name").foregroundStyle(.gray.opacity(0.9)))
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
                                    TextField("Consumption", text: $vm.consumption)
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
                            
                            BetterEditor(text: $vm.description, placeholder: "Type car description", maxHeight: 100)
                                .betterEditorScrollIndicators(.visible)
                                
                                .foregroundStyle(.black)
                                .frame(minHeight: 100)
                                .padding()
                                .background(Color.white.opacity(0.8))
                                .clipShape(.rect(cornerRadius: 15))
                                
                        }
                        
                        Divider().background(Color.white.opacity(0.2)).padding(.vertical, 4)
                        
                        // availability toggle
                        Toggle(isOn: $vm.isAvailable) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Available for Rent").foregroundColor(.white).font(.headline)
                                Text(vm.isAvailable ? "Visible to customers" : "Unavailable for rent")
                                    .font(.caption).foregroundColor(vm.isAvailable ? .green : .gray)
                            }
                        }
                        .tint(.green)
                    }
                    .glassEffect()
                    .padding()
                }
                .padding(.bottom, 30)
            }
            
            // indicator while saving
            if vm.isSaving {
                Color.black.opacity(0.3).ignoresSafeArea()
                ProgressView().tint(.white).scaleEffect(1.5)
            }
        }
        .sheet(isPresented: $showPhotoEditor){
            AdminCarPhotoEditorView(vm: vm)
                
        }
        
        .navigationTitle("Edit Vehicle")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    Task{
                        await vm.updateFields()
                    }
                }
                .fontWeight(.bold)
                .foregroundColor(.green)
                .disabled(vm.isSaving)
            }
        }
    }
    
}


#Preview {
    AdminCarEditView(car: Car(id: UUID(), brand: "BWM", model: "M5", year: 2012, consumption: 10.4, fuelType: "Diesel", transmissionType: "Automatic", isAvailable: true, imageUrls: [], pricePerDay: 100, description: "BMW stands for Bayerische Motoren Werke, which translates to Bavarian Motor Works in English. It is a renowned German manufacturer of luxury automobiles, motorcycles, and engines headquartered in Munich, known for its focus on performance, innovation, and premium engineering. "))
}
