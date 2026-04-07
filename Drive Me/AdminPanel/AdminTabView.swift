//
//  AdminTabView.swift
//  Drive Me
//
//  Created by Paul Bovtach on 07.04.2026.
//

import SwiftUI

struct AdminTabView: View {
    var body: some View {
        TabView {
            Text("New bookings")
                .tabItem {
                    Image(systemName: "tray.full.fill")
                    Text("Requests")
                }
            

            Text("Autopark")
                .tabItem {
                    Image(systemName: "car.fill")
                    Text("Fleet")
                }
            
            Text("Map redactor")
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Map Admin")
                }
            

            AdminProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Profile")
                }
        }
        .tint(.white)
    }
}

#Preview {
    AdminTabView()
}
