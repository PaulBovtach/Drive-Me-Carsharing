//
//  AccountView.swift
//  Drive Me
//
//  Created by Paul Bovtach on 28.03.2026.
//

import SwiftUI
import Supabase

struct AccountView: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        VStack(spacing: 20) {
            
            // Якщо користувач залогінений
            if authManager.isAuthenticated {
                
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(Color.gray.opacity(0.5))
                
                // Показуємо імейл
                Text(authManager.currentUser?.email ?? "Користувач")
                    .font(.title2)
                    .fontWeight(.bold)
                
                // Показуємо роль з нашої таблиці profiles
                Text("Роль: \(authManager.currentUserProfile?.role ?? "невідомо")")
                    .foregroundColor(.secondary)
                
                Spacer()
                
                // Кнопка ВИХОДУ
                Button(action: {
                    Task {
                        await authManager.signOut()
                    }
                }) {
                    Text("Вийти з акаунту")
                        .font(.headline)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(12)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 30)
                
            } else {
                // Якщо користувач ГІСТЬ
                Spacer()
                Text("Ви не авторизовані")
                    .font(.title2)
                
                Button(action: {
                    authManager.showAuthView = true
                }) {
                    Text("Увійти або зареєструватися")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 24)
                Spacer()
            }
        }
        .padding(.top, 40)
    }
}
#Preview {
    AccountView()
        .environmentObject(AuthManager(preview: true))
       
        
}
