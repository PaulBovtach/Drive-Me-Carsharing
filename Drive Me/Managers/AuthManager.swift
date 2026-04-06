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
    
    
    @Published var currentUser: User? //supabase auth User struct
    @Published var currentUserProfile: UserProfile? //our own User struct
    @Published var showAuthView: Bool = false
    
    var isAuthenticated: Bool { return currentUser != nil }
    var isAdmin: Bool { return currentUserProfile?.role == "admin"}
    
    init(preview: Bool = false) {
        if preview { return }
    
        Task {
            for await state in supabase.auth.authStateChanges {
                if [.initialSession, .signedIn, .signedOut].contains(state.event){
                    self.currentUser = state.session?.user
                    
                    if state.session?.user != nil {
                        await fetchUser()
                    } else {
                        self.currentUser = nil
                        self.currentUserProfile = nil
                    }
                }
            }
        }
    }
    
    
    //MARK: Registration
    func register(email: String, password: String, name: String, surname: String, phoneNumber: String) async {
        
        do {
            // Creating user in hidded table 'auth.users'
            let response = try await supabase.auth.signUp(email: email, password: password)
            
            // Getting a user's id from table 'auth.users'
            let userId = response.user.id
            
            // Forming user's row in table 'profiles'
            let newProfile = UserProfile(id: userId, name: name, surname: surname, role: "client", phoneNumber: phoneNumber, email: email)
            
            // Writing to my table 'profiles'
            try await supabase.from("profiles").insert(newProfile).execute()
            
            self.currentUserProfile = newProfile
            
            print("Successfully registered!")
            self.showAuthView = false
            
        } catch {
            print("Failed to register: \(error.localizedDescription)")
        }
        
    }
    
    //MARK: Log In
    func logIn(email: String, password: String) async {
        do{
            try await supabase.auth.signIn(email: email, password: password)
            print("Successfully logined!")
            self.showAuthView = false
        }catch {
            print("Failed to log in: \(error.localizedDescription)")
        }
    }
    
    //MARK: Fetch profile
    func fetchUser() async {
        guard let userId = currentUser?.id else { return }
        
        do {
            let profile: UserProfile = try await supabase
                .from("profiles")
                .select()
                .eq("id", value: userId)
                .single()
                .execute()
                .value
            self.currentUserProfile = profile
        } catch {
            print("Failed to download profile: \(error.localizedDescription)")
            
        }
    }
    
    
    // MARK: signOut
    func signOut() async {
        do {
            try await supabase.auth.signOut()
            
            self.currentUser = nil
            self.currentUserProfile = nil
            
            print("Successfully signed out!")
        } catch {
            print("Failed to sign out: \(error.localizedDescription)")
        }
    }
    
}
