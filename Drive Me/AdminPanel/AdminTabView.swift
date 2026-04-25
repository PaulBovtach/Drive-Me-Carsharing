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
            
            Tab{
                AdminRequestsView()
            }label: {
                Image(systemName: "tray.full.fill")
                Text("Requests")
            }
            
            Tab{
                AutoparkListView()
            }label: {
                Image(systemName: "car.fill")
                Text("Autopark")
            }
            
            Tab{
                Text("Map redactor")
            }label: {
                Image(systemName: "map.fill")
                Text("Map Admin")
            }
            

            Tab{
                AdminProfileView()
            }label: {
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
