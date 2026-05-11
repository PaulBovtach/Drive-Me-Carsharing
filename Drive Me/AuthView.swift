//
//  AuthView.swift
//  Drive Me
//

import SwiftUI

enum Field {
    case email, password, confirmPassword, name, surname, phoneNumber
}

struct AuthView: View {
    @EnvironmentObject var authManager: AuthManager
    

    @StateObject private var viewModel = AuthViewModel()
    @FocusState private var focusedField: Field?
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 50/255, green: 80/255, blue: 40/255),
                    Color(red: 35/255, green: 60/255, blue: 25/255),
                    Color(red: 20/255, green: 40/255, blue: 15/255)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button(action: { authManager.showAuthView = false }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 50)
                            .clipShape(Circle())
                    }
                    .buttonStyle(.glass)
                    .environment(\.colorScheme, .dark)
                    Spacer()
                }
                .padding(.horizontal)
                
                Spacer()
                
                ScrollView {
                    VStack(spacing: 8) {
                        Text(viewModel.isLoginMode ? "Welcome back" : "Create account")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        
                        Text(viewModel.isLoginMode ? "Login to continue booking" : "Register to rent our best cars!")
                            .foregroundStyle(.white)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                    
                    VStack(spacing: 16) {
                        // Email
                        TextField("", text: $viewModel.email, prompt: Text("Email").foregroundStyle(.gray.opacity(0.9)))
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.black)
                            .clipShape(.capsule)
                            .padding(.horizontal, 32)
                            .focused($focusedField, equals: .email)
                            .submitLabel(.next)
                            .autocorrectionDisabled(true)
                            .onSubmit { focusedField = .password }
                        
                        // Password
                        SecureField("", text: $viewModel.password, prompt: Text("Password").foregroundStyle(.gray.opacity(0.9)))
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.black)
                            .clipShape(.capsule)
                            .padding(.horizontal, 32)
                            .focused($focusedField, equals: .password)
                            .submitLabel(viewModel.isLoginMode ? .done : .next)
                            .onSubmit { focusedField = viewModel.isLoginMode ? nil : .confirmPassword }
                        
                        // Registration fields
                        if !viewModel.isLoginMode {
                            SecureField("", text: $viewModel.confirmPassword, prompt: Text("Confirm password").foregroundStyle(.gray.opacity(0.9)))
                                .padding()
                                .background(Color.white)
                                .foregroundColor(.black)
                                .clipShape(.capsule)
                                .padding(.horizontal, 32)
                                .focused($focusedField, equals: .confirmPassword)
                                .submitLabel(.next)
                                .onSubmit { focusedField = .name }
                            
                            // Name
                            TextField("", text: $viewModel.name, prompt: Text("Name").foregroundStyle(.gray.opacity(0.9)))
                                .keyboardType(.default)
                                .textInputAutocapitalization(.words)
                                .autocorrectionDisabled(true)
                                .padding()
                                .background(Color.white)
                                .foregroundColor(.black)
                                .clipShape(.capsule)
                                .padding(.horizontal, 32)
                                .focused($focusedField, equals: .name)
                                .submitLabel(.next)
                                .onSubmit { focusedField = .surname }
                            
                            // Surname
                            TextField("", text: $viewModel.surname, prompt: Text("Surname").foregroundStyle(.gray.opacity(0.9)))
                                .keyboardType(.default)
                                .textInputAutocapitalization(.words)
                                .autocorrectionDisabled(true)
                                .padding()
                                .background(Color.white)
                                .foregroundColor(.black)
                                .clipShape(.capsule)
                                .padding(.horizontal, 32)
                                .focused($focusedField, equals: .surname)
                                .submitLabel(.next)
                                .onSubmit { focusedField = .phoneNumber }
                            
                            // Phone
                            TextField("", text: $viewModel.phoneNumber, prompt: Text("Phone number").foregroundStyle(.gray.opacity(0.9)))
                                .keyboardType(.phonePad)
                                .padding()
                                .background(Color.white)
                                .foregroundColor(.black)
                                .clipShape(.capsule)
                                .padding(.horizontal, 32)
                                .focused($focusedField, equals: .phoneNumber)
                                .submitLabel(.done)
                                .onSubmit { focusedField = nil }
                        }
                    }
                    
                    // Forgot Password
                    if viewModel.isLoginMode {
                        HStack {
                            Spacer()
                            Button("Forgot password?") {
                                viewModel.resetEmail = viewModel.email
                                viewModel.showResetPasswordAlert = true
                            }
                            .font(.footnote)
                            .fontWeight(.medium)
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.trailing, 40)
                            .padding(.top, 4)
                        }
                    }
                    
                    // Error Message
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(Color.red.opacity(0.9))
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                            .padding(.top, 8)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                    
                    // Main action button
                    Button {
                        focusedField = nil
                        
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            if viewModel.validateFields() {
                                Task {
                                    if viewModel.isLoginMode {
                                        await authManager.logIn(email: viewModel.email, password: viewModel.password)
                                    } else {
                                        await authManager.register(
                                            email: viewModel.email,
                                            password: viewModel.password,
                                            name: viewModel.name,
                                            surname: viewModel.surname,
                                            phoneNumber: viewModel.phoneNumber
                                        )
                                    }
                                }
                            }
                        }
                    } label: {
                        Text(viewModel.isLoginMode ? "Login" : "Register")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .buttonStyle(.glass)
                    .environment(\.colorScheme, .dark)
                    .padding(.horizontal, 32)
                    .padding(.top, viewModel.errorMessage.isEmpty ? 16 : 8)
                    
                    Spacer()
                    Spacer()
                    
                    // Toggle button
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            viewModel.toggleMode()
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Text(viewModel.isLoginMode ? "Don't have an account?" : "Already have an account?")
                                .foregroundColor(.gray)
                            Text(viewModel.isLoginMode ? " Register" : " Login")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .font(.subheadline)
                        .padding(.top, 24)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .onTapGesture {
            focusedField = nil
        }
        // alert for password resetting
        .alert("Reset Password", isPresented: $viewModel.showResetPasswordAlert) {
            TextField("Enter your email", text: $viewModel.resetEmail)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
            
            Button("Cancel", role: .cancel) { }
            Button("Send Link") {
                Task {
                    await authManager.resetPassword(email: viewModel.resetEmail)
                }
            }
            .disabled(!viewModel.isResetEmailValid)
        } message: {
            Text("Enter your email address and we'll send you a link to reset your password.")
        }
    }
}

#Preview {
    AuthView()
}
