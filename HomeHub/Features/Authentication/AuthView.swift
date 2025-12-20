//
//  AuthView.swift
//  HomeHub
//
//  Created by RajayGoms on 12/17/25.
//

import SwiftUI

struct AuthView: View {
    @StateObject private var authViewModel = AuthMVVM()
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // headerView
                
                inputFieldsView
                
                // actionButton
                
                if let error = authViewModel.errorMessage {
                    errorView(message: error)
                }
                
                // secondaryActionsView
                
                Spacer()
            }
            .padding()
            //.navigationTitle(authNavigationTitle)
        }
    }
    
        
        @ViewBuilder
        private var inputFieldsView: some View {
            switch authViewModel.authCurrentSteps {
            case .emailEntry, .forgotpassword:
                TextField("Email", text: $authViewModel.email)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .disabled(authViewModel.isLoading)
                
            case .login, .signup:
                TextField("Email", text: $authViewModel.email)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .disabled(authViewModel.isLoading)
                
                SecureField("Password", text: $authViewModel.password)
                    .textFieldStyle(.roundedBorder)
                    .disabled(authViewModel.isLoading)
                
                if authViewModel.authCurrentSteps == .signup {
                    Text("Password must be at least 8 characters")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
            case .verfication:
                TextField("Verification Code", text: $authViewModel.verificationCode)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                    .disabled(authViewModel.isLoading)
                    .multilineTextAlignment(.center)
                    .font(.system(.title2, design: .monospaced))
                
                Text("Enter the 6-digit code sent to your email")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    
    private func errorView(message: String) -> some View {
        Text(message)
    }
    
    private var authNavigationTitle: [String]? {
        switch authViewModel.authCurrentSteps {
        case .emailEntry: return ["Welcome",
                                  "Enter your email to log in", "Don't have account?", "I agreed the Privacy & Policy"]
        case .login: return ["Login",
                             "Enter your password to log in", "Forgot your password?", "I agreed the Privacy & Policy"]
        case .signup: return ["Signup", "Let's make you new member of home", "Already have account", "I agreed the Privacy & Policy"]
        case .verfication: return ["Verification", "Enter your verification code to log in", "Didn't get the code", "I agreed the Privacy & Policy"]
        case .forgotpassword: return ["Reset Password", "Create your new password", "Don't have account", "I agreed the Privacy & Policy"]
        }
    }
    
}


