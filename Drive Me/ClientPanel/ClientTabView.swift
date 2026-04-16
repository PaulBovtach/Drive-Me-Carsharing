//
//  ClientTabView.swift
//  Drive Me
//
//  Created by Paul Bovtach on 07.04.2026.
//

import SwiftUI

struct ClientTabView: View {
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
    ClientTabView()
}
