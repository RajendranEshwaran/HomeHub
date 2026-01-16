//
//  MenuItemButton.swift
//  HomeHub
//
//  Created by Rajendran EShwaran on 1/16/26.
//
import SwiftUI
import Combine

// MARK: - Menu Item Button

struct MenuItemButton: View {
    let item: MenuItem
    @State private var isPressed: Bool = false

    var body: some View {
        Button(action: item.action) {
            HStack(spacing: 16) {
                // Icon
                Image(systemName: item.icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(.black.opacity(0.7))
                    .frame(width: 28)

                // Title
                Text(item.title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.black.opacity(0.8))

                Spacer()

                // Arrow
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.black.opacity(0.3))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background {
                // Glassy button effect
                RoundedRectangle(cornerRadius: 14)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.background.opacity(isPressed ? 0.9 : 0.6),
                                Color.background.opacity(isPressed ? 0.7 : 0.3)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.5),
                                        Color.white.opacity(0.0)
                                    ],
                                    startPoint: .top,
                                    endPoint: .center
                                )
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.8),
                                        Color.white.opacity(0.3)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
            }
        }
        .buttonStyle(PressableButtonStyle(isPressed: $isPressed))
    }
}


// MARK: - Pressable Button Style

struct PressableButtonStyle: ButtonStyle {
    @Binding var isPressed: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .onChange(of: configuration.isPressed) { _, newValue in
                isPressed = newValue
            }
            .animation(.spring(response: 0.2), value: configuration.isPressed)
    }
}
