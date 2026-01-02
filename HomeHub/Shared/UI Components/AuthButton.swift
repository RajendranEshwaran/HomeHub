//
//  AuthButton.swift
//  HomeHub
//
//  Created by Rajendran Eshwaran on 12/17/25.
//

import SwiftUI

struct AuthButton<Content: View> : View {
    
    let buttonAction: () -> Void
    let content: Content
    let state: AuthStepsModel?
    init(buttonAction: @escaping () -> Void, @ViewBuilder content: () -> Content, state: AuthStepsModel?) {
        self.buttonAction = buttonAction
        self.content = content()
        self.state = state
    }
    
    var body: some View {
            Button(action: buttonAction) {
                content
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .foregroundStyle(.white)
                    .fontWeight(.semibold)
                   // .padding(.horizontal, 100)
                   // .padding(.vertical, 15)
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
            }
        }
}
