//
//  ContentView.swift
//  Drive Me
//
//  Created by Paul Bovtach on 24.03.2026.
//

import SwiftUI

struct ContentView: View {

    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        ZStack {
            if !hasSeenOnboarding {
                OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
                    .transition(.asymmetric(insertion: .identity, removal: .move(edge: .leading)))
            } else {
                Group {
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
                            .transition(.opacity)
                    }
                }
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: hasSeenOnboarding)
        .animation(.easeInOut, value: authManager.isAuthenticated)
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthManager(preview: true))
}
