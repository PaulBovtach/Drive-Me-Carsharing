//
//  AuthManager.swift
//  Drive Me
//
//  Created by Paul Bovtach on 26.03.2026.
//

import Foundation
import Combine
import Supabase

@MainActor
class AuthManager: ObservableObject {
    
    //is user logined now? (Stores profile from Supabase)
    @Published var currentUser: User?
    
    @Published var showAuthView: Bool = false
    
    var isAuthenticated: Bool {
        return currentUser != nil
    }
    
    init() {
        Task{
            for await state in supabase.auth.authStateChanges {
                if [.initialSession, .signedIn, .signedOut].contains(state.event){
                    self.currentUser = state.session?.user
                }
            }
            
        }
        
    }
    
}
