//
//  ContentView.swift
//  Drive Me
//
//  Created by Paul Bovtach on 24.03.2026.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var authManager: AuthManager
    var body: some View {
        
        TabView {
            Tab {
                CarListView()
            } label: {
                Image(systemName: "car")
                Text("Cars")
            }
            Tab {
                BookByDateView()
            }label: {
                Image(systemName: "calendar")
                Text("Dates")
            }
            
            Tab {
                MapInfoView()
            }label: {
                Image(systemName: "map")
                Text("Map")
            }
            
            Tab {
                AccountView()
            }label: {
                Image(systemName: "person")
                Text("Account")
            }
            
            

        }
        .tint(.white)
        
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthManager(preview: true))
}
