//
//  GlassyBackground.swift
//  HomeHub
//
//  Created by Rajendran Eshwaran on 1/28/26.
//

import SwiftUI

struct GlassyBackground: View {
    var primaryColor: Color = .white
    var secondaryColor: Color = .white
    var accentColor: Color = .white

    var body: some View {
        ZStack {
            // Base dark gradient
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.05, blue: 0.12),
                    Color(red: 0.08, green: 0.06, blue: 0.15),
                    Color(red: 0.04, green: 0.04, blue: 0.10)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            // Mesh gradient for depth
            MeshGradient(
                width: 3,
                height: 3,
                points: [
                    [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                    [0.0, 0.5], [0.6, 0.4], [1.0, 0.5],
                    [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
                ],
                colors: [
                    primaryColor.opacity(0.3), secondaryColor.opacity(0.2), accentColor.opacity(0.2),
                    secondaryColor.opacity(0.15), primaryColor.opacity(0.25), accentColor.opacity(0.15),
                    accentColor.opacity(0.2), primaryColor.opacity(0.2), secondaryColor.opacity(0.3)
                ]
            )
            .blur(radius: 60)

            // Top-left accent glow
            Circle()
                .fill(
                    RadialGradient(
                        colors: [secondaryColor.opacity(0.3), .clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: 200
                    )
                )
                .frame(width: 400, height: 400)
                .offset(x: -100, y: -200)
                .blur(radius: 40)

            // Bottom-right accent glow
            Circle()
                .fill(
                    RadialGradient(
                        colors: [primaryColor.opacity(0.25), .clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: 150
                    )
                )
                .frame(width: 300, height: 300)
                .offset(x: 150, y: 400)
                .blur(radius: 50)

            // Subtle texture overlay
            Rectangle()
                .fill(.white.opacity(0.02))
        }
        .ignoresSafeArea()
    }
}

// MARK: - Glassy Card Modifier
struct GlassyCard: ViewModifier {
    var cornerRadius: CGFloat = 20
    var opacity: Double = 0.1

    func body(content: Content) -> some View {
        content
            .background {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(opacity + 0.05),
                                Color.white.opacity(opacity)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius))
            }
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.3),
                                Color.white.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
    }
}

extension View {
    func glassyCard(cornerRadius: CGFloat = 20, opacity: Double = 0.1) -> some View {
        modifier(GlassyCard(cornerRadius: cornerRadius, opacity: opacity))
    }
}

#Preview {
    ZStack {
        GlassyBackground()

        VStack(spacing: 20) {
            Text("Glassy Background")
                .font(.largeTitle.bold())
                .foregroundStyle(.white)

            Text("With customizable colors")
                .font(.headline)
                .foregroundStyle(.white.opacity(0.7))

            // Example glassy card
            VStack(spacing: 10) {
                Text("Glassy Card")
                    .font(.headline)
                    .foregroundStyle(.white)
                Text("Using .glassyCard() modifier")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
            }
            .padding(20)
            .glassyCard()
        }
    }
}
