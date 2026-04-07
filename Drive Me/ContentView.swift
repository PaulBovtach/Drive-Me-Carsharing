//
//  ContentView.swift
//  Drive Me
//
//  Created by Paul Bovtach on 24.03.2026.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        ZStack {
            if authManager.isAuthenticated {
                if authManager.isAdmin {
                    AdminTabView()
                        .transition(.opacity)
                } else {
                    ClientTabView()
                        .transition(.opacity)
                }
            } else {
                ClientTabView()
            }
        }
        
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthManager(preview: true))
}
