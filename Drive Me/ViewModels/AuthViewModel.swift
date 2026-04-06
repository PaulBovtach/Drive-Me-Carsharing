//
//  AuthViewModel.swift
//  Drive Me
//
//  Created by Paul Bovtach on 07.04.2026.
//


import SwiftUI
import Foundation
import Combine

class AuthViewModel: ObservableObject {
    @Published var isLoginMode = true
    
    // form fields
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var name = ""
    @Published var surname = ""
    @Published var phoneNumber = ""
    
    // error state
    @Published var errorMessage = ""
    
    // password reset
    @Published var showResetPasswordAlert = false
    @Published var resetEmail = ""
    
    // email validation (reset password)
    var isResetEmailValid: Bool {
        let emailTrimmed = resetEmail.trimmingCharacters(in: .whitespaces)
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: emailTrimmed)
    }
    
    func toggleMode() {
        isLoginMode.toggle()
        errorMessage = ""
        password = ""
        confirmPassword = ""
        name = ""
        surname = ""
        phoneNumber = ""
    }
    
    func validateFields() -> Bool {
        errorMessage = ""
        
        // 1. email
        let emailTrimmed = email.trimmingCharacters(in: .whitespaces)
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        if !NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: emailTrimmed) {
            errorMessage = "Enter a valid email address."
            return false
        }
        
        // 2. Passord (min 8 symbos, at least 1 Caps letter and 1 num)
        let passwordRegex = "^(?=.*[A-Z])(?=.*[0-9]).{8,}$"
        if !NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password) {
            errorMessage = "Password must be 8+ chars, with 1 uppercase and 1 number."
            return false
        }
        
        if !isLoginMode {
            if password != confirmPassword {
                errorMessage = "Passwords do not match."
                return false
            }
            
            // name (2+)
            let nameTrimmed = name.trimmingCharacters(in: .whitespaces)
            let lettersOnlyRegex = "^[a-zA-Zа-яА-ЯіІїЇєЄґҐ\\s-]+$"
            
            if nameTrimmed.count < 2 || !NSPredicate(format: "SELF MATCHES %@", lettersOnlyRegex).evaluate(with: nameTrimmed) {
                errorMessage = "Name must be 2+ letters and contain no numbers."
                return false
            }
            
            // surname(2+)
            let surnameTrimmed = surname.trimmingCharacters(in: .whitespaces)
            if surnameTrimmed.count < 2 || !NSPredicate(format: "SELF MATCHES %@", lettersOnlyRegex).evaluate(with: surnameTrimmed) {
                errorMessage = "Surname must be 2+ letters and contain no numbers."
                return false
            }
            
            // phone number
            let phoneTrimmed = phoneNumber.trimmingCharacters(in: .whitespaces)
            let phoneRegex = "^\\+?[0-9]{10,14}$"
            if !NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phoneTrimmed) {
                errorMessage = "Enter a valid phone number (+380123456789)."
                return false
            }
        }
        
        return true
    }
}
