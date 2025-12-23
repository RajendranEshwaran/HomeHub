//
//  AuthMVVM.swift
//  HomeHub
//
//  Created by RajayGoms on 12/17/25.
//

import SwiftUI
import Combine
import Foundation

// MARK: AuthModel

enum AuthStepsModel {
    case emailEntry
    case login
    case signup
    case verfication
    case forgotpassword
}

enum AuthButtonState {
    case next(isEnabled: Bool)
    case login(isEnabled: Bool)
    case signup(isEnabled: Bool)
    case verifycode(isEnabled: Bool)
    case forgotpassword(isEnabled: Bool)
    
    var title: String {
        switch self {
        case .next: return "Next"
        case .login: return "Login"
        case .signup: return "Signup"
        case .verifycode: return "VerifyCode"
        case .forgotpassword: return "ForgotPassword"
        }
    }
    
    var alternateButtonTitle: String {
        switch self {
        case .next: return "SignUp"
        case .login: return "Reset Now"
        case .signup: return ""
        case .verifycode: return "Resent Code"
        case .forgotpassword: return ""
        }
    }
    
    var isEnabled: Bool {
        switch self {
        case .next(let enabled), .login(let enabled), .signup(let enabled), .verifycode(let enabled), .forgotpassword(let enabled): return enabled
        }
    }
    
    // Control back navigation based on state
    var allowsBackNavigation: Bool {
        switch self {
        case .next: return false          // Can't go back from welcome
        case .login: return true           // Can go back to welcome
        case .signup: return true          // Can go back to previous
        case .verifycode: return true    // Can go back to home
        case .forgotpassword: return true           // Can't go back, completes flow
        }
    }
}

@MainActor
class AuthMVVM: ObservableObject {
    @Published var authCurrentSteps: AuthStepsModel = .emailEntry
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var verificationCode: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = ""

    private weak var coordinator: Coordinator?

    init(coordinator: Coordinator? = nil) {
            self.coordinator = coordinator
        }

    func setCoordinator(_ coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    var buttonState: AuthButtonState {
        switch authCurrentSteps {
        case .emailEntry:
            return .next(isEnabled: isEmailValid)
        case .login:
            return .login(isEnabled: isLoginValid)
        case .signup:
            return .signup(isEnabled: isSignupValid)
        case .verfication:
            return .verifycode(isEnabled: isVerifyCodeValid)
        case .forgotpassword:
            return .forgotpassword(isEnabled: isEmailValid)
        }
    }
    
    var isEmailValid: Bool {
        email.contains("@") && !email.isEmpty
    }
    
    var isLoginValid: Bool {
        !password.isEmpty && password.count >= 6 && isEmailValid
    }
    
    var isSignupValid: Bool {
        !password.isEmpty && password.count >= 6 && isEmailValid
    }
    
    var isVerifyCodeValid: Bool {
        verificationCode.count == 6
    }
    
    func handleButtonAction() async {
        self.isLoading = true
        self.errorMessage = nil
        
        do {
            switch authCurrentSteps {
            case .emailEntry: try await checkEmailExits()
            case .login: try await attemptLogin()
            case .signup: try await attemptSignup()
            case .verfication: try await attemptVerifyPassword()
            case .forgotpassword: try await attemptForgotPassword()
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    func checkEmailExits() async throws {
        let emailExists = email.contains("existing")
        authCurrentSteps = .login
    }
    
    func attemptLogin() async throws {
//        if isEmailValid && self.password.count >= 6 {
//
//        }
        coordinator?.coordinatorSetRootPage(root: .homeView)
    }
    
    func attemptSignup() async throws {
        authCurrentSteps = .verfication
    }
    
    func attemptForgotPassword() async throws {
        authCurrentSteps = .verfication
    }
    
    func attemptVerifyPassword() async throws {
        
    }
    
    func switchToForgotPassword() {
        authCurrentSteps = .forgotpassword
    }
        
    func switchToSignup() {
        authCurrentSteps = .signup
    }
}
