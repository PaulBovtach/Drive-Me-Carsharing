//
//  AdminProfileView.swift
//  Drive Me
//
//  Created by Paul Bovtach on 07.04.2026.
//

import SwiftUI

struct AdminProfileView: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "person.crop.circle.fill.badge.checkmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.green)
                    .padding(.top, 40)
                
                VStack(spacing: 8) {
                    Text("Admin Panel")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    if let email = authManager.currentUserProfile?.email {
                        Text(email)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    Task {
                        await authManager.signOut()
                    }
                }) {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                        Text("Log Out")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red.opacity(0.8))
                    .cornerRadius(16)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
            }
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    AdminProfileView()
}
