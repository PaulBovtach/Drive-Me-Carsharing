//
//  AuthView.swift
//  Drive Me
//
//  Created by Paul Bovtach on 26.03.2026.
//

import SwiftUI

enum Field {
    case email
    case password
    case confirmPassword
    case name
    case surname
    case phoneNumber
}

struct AuthView: View {
    @EnvironmentObject var authManager: AuthManager
    
    @State private var isLoginMode = true
    @FocusState private var focusedField: Field?
    
    //login and registration
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var name = ""
    @State private var surname = ""
    @State private var phoneNumber = ""
    
    
    var body: some View {
        ZStack{
            
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 50/255, green: 80/255, blue: 40/255),   // Top: Warm, earthy forest green
                    Color(red: 35/255, green: 60/255, blue: 25/255),   // Middle: Deeper forest mid-tone
                    Color(red: 20/255, green: 40/255, blue: 15/255)    // Bottom: Very dark, shadowed underbrush
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            
            VStack {
                // MARK: - Upper navigation panel
                HStack {
                    Button(action: {
                        authManager.showAuthView = false
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 50)
                            .clipShape(Circle())
                            //.glassy()
                    }
                    .buttonStyle(.glass)
                    .environment(\.colorScheme, .dark)
                    Spacer()
                }
                .padding(.horizontal)
                
                Spacer()
                
                //MARK: Content
                ScrollView {
                    // MARK: - Headers
                    VStack(spacing:8){
                        Text(isLoginMode ? "Welcome back" : "Create account")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        
                        Text(isLoginMode ? "Login to continue booking" : "Register, to rent our best cars!")
                            .foregroundStyle(.white)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                    
                    
                    //MARK: Fields to fill
                    VStack(spacing: 16){
                        //email
                        TextField("", text: $email, prompt: Text("Email").foregroundStyle(.gray.opacity(0.9)))
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .padding()
                            .background(Color.white)
                            .clipShape(.capsule)
                            .padding(.horizontal, 32)
                            .focused($focusedField, equals: .email)
                            .submitLabel(.next)
                            .autocorrectionDisabled(true)
                            .onSubmit {
                                focusedField = .password
                            }
                        
                        
                        //password
                        SecureField("", text: $password, prompt: Text("Password").foregroundStyle(.gray.opacity(0.9)))
                            .padding()
                            .background(Color.white)
                            .clipShape(.capsule)
                            .padding(.horizontal, 32)
                            .focused($focusedField, equals: .password)
                            .submitLabel(isLoginMode ? .done : .next)
                            .onSubmit {
                                focusedField = isLoginMode ? nil : .confirmPassword
                            }
                        
                        //registration fields
                        if !isLoginMode {
                            //confirm password
                            SecureField("", text: $confirmPassword, prompt: Text("Confirm password").foregroundStyle(.gray.opacity(0.9)))
                                .padding()
                                .background(Color.white)
                                .clipShape(.capsule)
                                .padding(.horizontal, 32)
                                .focused($focusedField, equals: .confirmPassword)
                                .submitLabel(.next)
                                .onSubmit {
                                    focusedField = .name
                                }
                            
                            //name
                            TextField("", text: $name, prompt: Text("Name").foregroundStyle(.gray.opacity(0.9)))
                                .keyboardType(.asciiCapable)
                                .autocorrectionDisabled(true)
                                .padding()
                                .background(Color.white)
                                .clipShape(.capsule)
                                .padding(.horizontal, 32)
                                .focused($focusedField, equals: .name)
                                .submitLabel(.next)
                                .onSubmit {
                                    focusedField = .surname
                                }
                            
                            //surname
                            TextField("", text: $surname, prompt: Text("Surname").foregroundStyle(.gray.opacity(0.9)))
                                .keyboardType(.asciiCapable)
                                .autocorrectionDisabled(true)
                                .padding()
                                .background(Color.white)
                                .clipShape(.capsule)
                                .padding(.horizontal, 32)
                                .focused($focusedField, equals: .surname)
                                .submitLabel(.next)
                                .onSubmit {
                                    focusedField = .phoneNumber
                                }
                            
                            TextField("", text: $phoneNumber, prompt: Text("Phone number").foregroundStyle(.gray.opacity(0.9)))
                                .keyboardType(.phonePad)
                                .padding()
                                .background(Color.white)
                                .clipShape(.capsule)
                                .padding(.horizontal, 32)
                                .focused($focusedField, equals: .phoneNumber)
                                .submitLabel(.done)
                                .onSubmit {
                                    focusedField = nil
                                }
                            
                        }
                        
                        
                        
                        
                    }
                    
                    Button {
                        focusedField = nil
                        if isLoginMode { print("logining") } else { print("registrating") }
                    } label: {
                        Text(isLoginMode ? "Login" : "Register")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            //.glassy()
                    }
                    //.buttonStyle(BouncyGlassButtonStyle())
                    .buttonStyle(.glass)
                    .environment(\.colorScheme, .dark)
                    .padding(.horizontal, 32)
                    .padding(.top, 8)
                    

                    
                    Spacer()
                    Spacer()
                    
                    //MARK: Toggle button
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            isLoginMode.toggle()
                            password = ""
                            confirmPassword = ""
                            name = ""
                            surname = ""
                            phoneNumber = ""
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Text(isLoginMode ? "Don't have an account?" : "Already have an account?")
                                .foregroundColor(.gray)
                            Text(isLoginMode ? " Register" : " Login")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .font(.subheadline)
                    }
                    
                }
            }
            
        }
        .onTapGesture {
            focusedField = nil
        }
    }
}
#Preview {
    AuthView()
}
