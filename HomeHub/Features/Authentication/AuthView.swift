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
        VStack {
            Text("login view")
        }
    }
    
    private func errorView(message: String) -> some View {
        Text(message)
    }
    
    private var navigationTitle: [String]? {
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


