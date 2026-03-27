//
//  Drive_MeApp.swift
//  Drive Me
//
//  Created by Paul Bovtach on 24.03.2026.
//

import SwiftUI

@main
struct Drive_MeApp: App {
    @StateObject private var authManager = AuthManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authManager)
                .fullScreenCover(isPresented: $authManager.showAuthView) {
                    AuthView()
                        .environmentObject(authManager)
                }
            
            
            
        }
    }
}
