//
//  AuthTextField.swift
//  HomeHub
//
//  Created by RajayGoms on 12/22/25.
//

import SwiftUI
import Foundation
import Combine

struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var isLoading: Bool = false
    var body: some View {
        TextField(placeholder, text: $text)
            .textInputAutocapitalization(.never)
            .keyboardType(keyboardType)
            .disabled(isLoading)
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
            .frame(height: 60)
    }
}


struct CustomSecureField: View {
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var isLoading: Bool = false
    
    var body: some View {
        SecureField(placeholder, text: $text)
        .textInputAutocapitalization(.never)
        .keyboardType(keyboardType)
        .disabled(isLoading)
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
        .frame(height: 60)
    }
}
