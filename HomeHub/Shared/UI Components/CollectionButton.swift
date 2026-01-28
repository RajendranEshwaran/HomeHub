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
    var size: CGSize? = CGSize(width: 40, height: 40)
    init(action: @escaping () -> Void, @ViewBuilder label: () -> Label, bgColor: Color, clipShape: CGFloat? = nil, radius: CGFloat? = nil, size: CGSize? = nil) {
        self.action = action
        self.label = label()
        self.bgColor = bgColor
        self.clipShape = clipShape
        self.radius = radius
        self.size = size
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 0) {
                label
            }
            .frame(width: size?.width, height: size?.height)
            .foregroundStyle(.white)
            .fontWeight(.semibold)
            .background {
                ZStack {
                    MeshGradient(width: 3, height: 3, points: [
                        [0, 0], [0.5, 0], [1, 0],
                        [0, 0.5], [0.5, 0.5], [1, 0.5],
                        [0, 1], [0.5, 1], [1, 1]
                    ],
                        colors: [
                            bgColor.opacity(1.0), bgColor.opacity(1.0), bgColor.opacity(1.0),
                            bgColor.opacity(1.0), bgColor.opacity(1.0), bgColor.opacity(1.0),
                            bgColor.opacity(1.0), bgColor.opacity(1.0), bgColor.opacity(1.0)
                        ]
                    )
                    .blur(radius: radius ?? 0)

                    LinearGradient(
                        gradient: Gradient(colors: [
                            .white.opacity(0.4),
                            .white.opacity(0.2),
                            .white.opacity(0.1)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: clipShape ?? 0)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                .white.opacity(0.2),
                                .white.opacity(0.2)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            )
            //.border(.white, width: 0.75)
            .clipShape(.rect(cornerRadius: clipShape ?? 0))
            .shadow(color: bgColor.opacity(0.3), radius: radius ?? 0, x: 0, y: 5)
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 10)
            
        }
    }
}
