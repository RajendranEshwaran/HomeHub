//
//  ActionColorButton.swift
//  HomeHub
//
//  Created by Rajendran Eshwaran on 1/20/26.
//

import SwiftUI

struct ActionColorButton: View {
    var color: Color = .purple
    var isSelected: Bool = false
    var onTap: () -> Void = {}

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 10) {
                Circle()
                    .fill(color)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: isSelected ? 3 : 0)
                    )
                    .shadow(color: color.opacity(0.5), radius: isSelected ? 8 : 4, x: 0, y: 4)
            }
            .foregroundColor(isSelected ? .white : .primary)
            
            .padding(3)
            .background { glassyBackground }
        }
        .buttonStyle(.plain)
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }

    private var glassyBackground: some View {
        Circle()
            .fill(
                LinearGradient(
                    colors: [
                        color.opacity(isSelected ? 0.8 : 0.2),
                        color.opacity(isSelected ? 0.6 : 0.1)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(isSelected ? 0.3 : 0.5),
                                Color.white.opacity(0.0)
                            ],
                            startPoint: .top,
                            endPoint: .center
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(isSelected ? 0.9 : 0.6),
                                Color.white.opacity(isSelected ? 0.4 : 0.2)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: isSelected ? 2 : 1
                    )
            )
            .shadow(
                color: color.opacity(isSelected ? 0.4 : 0.1),
                radius: isSelected ? 8 : 4,
                x: 0,
                y: isSelected ? 4 : 2
            )
    }
}
