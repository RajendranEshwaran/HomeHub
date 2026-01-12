//
//  AuthView.swift
//  HomeHub
//
//  Created by Rajendran Eshwaran on 12/17/25.
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

            GenericNavigation(action: {
                
            }, navigationTitle: authNavigationTitle[0], isBackEnable: authViewModel.buttonState.allowsBackNavigation, isForwardEnable: false, backgroundColor: .clear, foregroundColor: .text, leadingView: {
                Button {
                    //handlingGoBackAction()
                    authViewModel.goBack()
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
        }.environmentObject(coordinator)
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

                Button(action: {
                    authViewModel.handlingAlternateButtonAction()
                }, label: {
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
        case .emailEntry:
            CustomTextField(placeholder: "Email", text: $authViewModel.email)
            
        case .login:
            CustomSecureField(placeholder: "Password", text: $authViewModel.password)
            
        case .signup:
            signUPFormField
            if authViewModel.authCurrentSteps == .signup {
                Text("Password must be at least 8 characters")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        case .forgotpassword:
            CustomTextField(placeholder: "Your Password", text: $authViewModel.password)
            CustomTextField(placeholder: "Re-type Your Password", text: $authViewModel.rePassword)
        case .verfication:
            TextField("Verification Code", text: $authViewModel.verificationCode)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
                //.disabled(authViewModel.isLoading)
                .multilineTextAlignment(.center)
                .font(.system(.title2, design: .monospaced))

            Text("Enter the 6-digit code sent to your email or notification")
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
                                  "Enter your email to log in", "Don't have account?", "I agreed the Privacy & Policy, Terms and Conditions"]
        case .login: return ["Login",
                             "Enter your password to log in", "Forgot your password?", "I agreed the Privacy & Policy"]
        case .signup: return ["Signup", "Let's make you new member of home", "Already have account?", "I agreed the Privacy & Policy"]
        case .verfication: return ["Verification", "Enter your verification code to log in", "Didn't get the code", "I agreed the Privacy & Policy"]
        case .forgotpassword: return ["Reset Password", "Create your new password", "Please enter your passwords", "I agreed the Privacy & Policy"]
        }
    }

    private var signUPFormField: some View {
        VStack {
            CustomTextField(placeholder: "FirstName", text: $authViewModel.firstName)
            CustomTextField(placeholder: "LastName", text: $authViewModel.lastName)
            CustomTextField(placeholder: "Email", text: $authViewModel.email)
            CustomSecureField(placeholder: "Password", text: $authViewModel.password)
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
        .environmentObject(Coordinator())
}
