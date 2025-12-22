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
        ZStack {
            Color.background
            NavigationStack {
                VStack(spacing: 24) {
                    headerView.padding(20)
                    
                    subHeaderView

                    inputFieldsView.padding(20)
                    
                    termsConditionView.padding(20)
                    
                    actionButton.padding(20)
                    
                    if let error = authViewModel.errorMessage {
                        errorView(message: error)
                    }
                    
                    // secondaryActionsView
                    
                }.padding(12)
                
                //.navigationTitle(authNavigationTitle)
            }
        }.ignoresSafeArea(edges: .all)
    }
    
    @ViewBuilder
    private var headerView: some View {
        switch authViewModel.authCurrentSteps {
        default:
            if let bodyText1 = self.authNavigationTitle?[1] {
                Text(bodyText1)
                    .font(.largeTitle)
                    .foregroundStyle(.text)
                    .fontWeight(.bold)
                    .lineLimit(2)
            }
        }
    }
    
    @ViewBuilder
    private var subHeaderView: some View {
        HStack() {
            if let bodyText1 = self.authNavigationTitle?[2] {
                Text(bodyText1)
                    .font(.subheadline)
                    .foregroundStyle(.text)
                    .fontWeight(.light)
                
                Button(action: {}, label: {
                    Text(authViewModel.buttonState.alternateButtonTitle)
                        .font(.subheadline)
                        .font(.system(size: 12))
                        .foregroundStyle(.text)
                        .fontWeight(.semibold)
                    
                    
                })
            }
        }.padding(.trailing, 120)
    }
    
    @ViewBuilder
    private var termsConditionView: some View {
        if let termText = self.authNavigationTitle?[3] {
            Text(termText)
                .foregroundStyle(.text)
                .fontWeight(.thin)
                .lineLimit(2)
                .frame(alignment: .leading)
        }
    }
    
    @ViewBuilder
    private var inputFieldsView: some View {
        switch authViewModel.authCurrentSteps {
        case .emailEntry, .forgotpassword:
            
            TextField("Email", text: $authViewModel.email)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .disabled(authViewModel.isLoading)
                .padding(.horizontal, 12)
            //.padding(.vertical, 10)
                .frame(height: 60)
                .background {
                    // A 3x3 Mesh Gradient creates a liquid-like surface
                    MeshGradient(width: 3, height: 3, points: [
                        [0, 0], [0.5, 0], [1, 0],
                        [0, 0.5], [0.5, 0.5], [1, 0.5],
                        [0, 1], [0.5, 1], [1, 1]
                    ], colors: [
                        .background, .background, .background,
                        .background, .background, .background,
                        .background, .background, .background
                    ])
                    .overlay(.white.opacity(0.1)) // Glossy layer
                    .clipShape(.rect(cornerRadius: 15))
                }
        case .login:
            
            SecureField("Password", text: $authViewModel.password)
                .textFieldStyle(.roundedBorder)
                .disabled(authViewModel.isLoading)
            
            if authViewModel.authCurrentSteps == .signup {
                Text("Password must be at least 8 characters")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        case .signup:
            signUPFormField
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
    
    private var signUPFormField: some View {
        VStack {
            CustomTextField(placeholder: "FirstName", text: $authViewModel.firstName)
            CustomTextField(placeholder: "LastName", text: $authViewModel.lastName)
            CustomTextField(placeholder: "Email", text: $authViewModel.email)
            SecureField("Password", text: $authViewModel.password)
                .textFieldStyle(.roundedBorder)
                .disabled(authViewModel.isLoading)
        }
    }
    
    private var actionButton: some View {
        AuthButton(buttonAction: {
            
        }, content: {
            Text(authViewModel.buttonState.title)
        })
    }
}


#Preview {
    AuthView()
}
