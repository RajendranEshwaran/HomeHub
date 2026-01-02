//
//  CollectionButton.swift
//  HomeHub
//
//  Created by Rajendran Eshwaran on 1/2/26.
//

import SwiftUI
import Combine

struct CollectionButton<Label: View>: View {
    let action: () -> Void
    let label: Label
    var bgColor: Color = .indigo
    var clipShape: CGFloat? = 20
    var radius: CGFloat? = 6
    
    init(action: @escaping () -> Void, @ViewBuilder label: () -> Label, bgColor: Color, clipShape: CGFloat? = nil, radius: CGFloat? = nil) {
        self.action = action
        self.label = label()
        self.bgColor = bgColor
        self.clipShape = clipShape
        self.radius = radius
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 0) {
                label
            }
            .frame(width: 40, height: 40)
            .foregroundStyle(.white)
            .fontWeight(.semibold)
            .background {
                MeshGradient(width: 3, height: 3, points: [
                    [0, 0], [0.5, 0], [1, 0],
                    [0, 0.5], [0.5, 0.5], [1, 0.5],
                    [0, 1], [0.5, 1], [1, 1]
                ], colors: [
                    bgColor, bgColor, bgColor,
                    bgColor, bgColor, bgColor,
                    bgColor, bgColor, bgColor
                ])
                .blur(radius: 0)
                .overlay(.white.opacity(0.1))
            }
            .clipShape(.rect(cornerRadius: clipShape ?? 0))
            .shadow(color:.gray, radius: radius ?? 0, y: 5)
        }
    }
}
