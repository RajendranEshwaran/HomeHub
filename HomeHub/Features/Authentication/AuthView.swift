//
//  AuthView.swift
//  HomeHub
//
//  Created by RajayGoms on 12/17/25.
//

import SwiftUI
import Combine

struct AuthView: View {

    @EnvironmentObject private var coordinator: Coordinator
    @StateObject private var authViewModel = AuthMVVM()
    @State private var navigationTitle = ""
    @State private var navigationBackButton: Bool = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 0) {

            GenericNavigation(action: {}, navigationTitle: authNavigationTitle[0], isBackEnable: authViewModel.buttonState.allowsBackNavigation, backgroundColor: .clear, foregroundColor: .text, leadingView: {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .aspectRatio(contentMode: .fit)

                }
            }, trailingView: {
                //Spacer()
            }).frame(height: 50)

            Spacer()

            headerView.padding(20)

            subHeaderView

            inputFieldsView.padding(20)

            termsConditionView.padding(20)

            actionButton.padding(20)

            if let error = authViewModel.errorMessage {
                errorView(message: error)
            }

            Spacer()
        }
        .navigationBarHidden(true)
        .onAppear {
            authViewModel.setCoordinator(coordinator)
        }
    }
    
    
    @ViewBuilder
    private var headerView: some View {
        switch authViewModel.authCurrentSteps {
        default:
                Text(self.authNavigationTitle[1])
                    .font(.largeTitle)
                    .foregroundStyle(.text)
                    .fontWeight(.bold)
                    .lineLimit(2)
        }
    }

    @ViewBuilder
    private var subHeaderView: some View {
        HStack() {
                Text(self.authNavigationTitle[2])
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
        }.padding(.trailing, 120)
    }

    @ViewBuilder
    private var termsConditionView: some View {
            Text(self.authNavigationTitle[3])
                .foregroundStyle(.text)
                .fontWeight(.thin)
                .lineLimit(2)
                .frame(alignment: .leading)
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

    private var authNavigationTitle: [String] {
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
            Task {
                await authViewModel.handleButtonAction()
            }
        }, content: {
            Text(authViewModel.buttonState.title)
        }, state: authViewModel.authCurrentSteps)
    }
}


#Preview {
    AuthView()
}
