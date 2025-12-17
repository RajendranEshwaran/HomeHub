//
//  AuthButton.swift
//  HomeHub
//
//  Created by Rajendran Eshwaran on 12/17/25.
//

import SwiftUI

struct AuthButton<Label: View> : View {
    
    enum ButtonStyle {
        case standard, premium, enterprise
        var backgroundColor: Color {
            switch self {
            case .standard: Color.button
            case .premium: Color.yellow
            case .enterprise: Color.clear
            }
        }
    }
    
    let buttonTitle: String
    let buttonAction: ()-> Void
    @ViewBuilder let label: () -> Label
    let buttonStyle: ButtonStyle
    
    var body: some View {
        Button(action: buttonAction, label: {
            Text(buttonTitle)
                .foregroundStyle(.white)
                .padding(.horizontal, 100)
                .padding(.vertical, 15)
                .background {
                    // A 3x3 Mesh Gradient creates a liquid-like surface
                    MeshGradient(width: 3, height: 3, points: [
                        [0, 0], [0.5, 0], [1, 0],
                        [0, 0.5], [0.5, 0.5], [1, 0.5],
                        [0, 1], [0.5, 1], [1, 1]
                    ], colors: [
                        .indigo, .indigo, .indigo,
                        .indigo, .indigo, .indigo,
                        .indigo, .indigo, .indigo
                    ])
                    .blur(radius: 10)
                    .overlay(.white.opacity(0.1)) // Glossy layer
                }
                .clipShape(.rect(cornerRadius: 15))
                .shadow(color:.gray, radius: 6, y: 5)
            
        })
    }
    
}
