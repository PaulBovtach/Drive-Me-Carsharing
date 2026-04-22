//
//  AdminCarPhotoEditorView.swift
//  Drive Me
//
//  Created by Paul Bovtach on 22.04.2026.
//

import SwiftUI

struct AdminCarPhotoEditorView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm: AdminCarEditViewModel
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    AdminCarPhotoEditorView(vm: AdminCarEditViewModel(car: Car(id: UUID(), brand: "BWM", model: "M5", year: 2012, consumption: 10.4, fuelType: "Diesel", transmissionType: "Automatic", isAvailable: true, imageUrls: [], pricePerDay: 100, description: "BMW stands for Bayerische Motoren Werke, which translates to Bavarian Motor Works in English. It is a renowned German manufacturer of luxury automobiles, motorcycles, and engines headquartered in Munich, known for its focus on performance, innovation, and premium engineering. ")))
}
