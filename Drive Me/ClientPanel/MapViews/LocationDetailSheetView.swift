//
//  LocationDetailSheetView.swift
//  Drive Me
//
//  Created by Paul Bovtach on 06.04.2026.
//

import SwiftUI

struct LocationDetailSheetView: View {
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
