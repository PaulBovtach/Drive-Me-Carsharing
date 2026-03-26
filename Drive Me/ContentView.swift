//
//  ContentView.swift
//  Drive Me
//
//  Created by Paul Bovtach on 24.03.2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        TabView {
            Tab {
                CarListView()
            } label: {
                Image(systemName: "car")
                Text("Cars")
            }
            
            Tab {
                Text("MapKit integration")
            }label: {
                Image(systemName: "map")
                Text("Map")
            }
            Tab {
                Text("Rent car demanding on date ")
            }label: {
                Image(systemName: "calendar")
                Text("Dates")
            }
            Tab {
                Text("History of bookings and analytics")
            }label: {
                Image(systemName: "book")
                Text("History")
            }
            

        }
        .tint(.white)
        
    }
}

#Preview {
    ContentView()
}
