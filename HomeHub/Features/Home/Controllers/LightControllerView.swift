//
//  LightControllerView.swift
//  HomeHub
//
//  Created by Rajendran Eshwaran on 1/12/26.
//

import SwiftUI

struct LightControllerView: View {
    let state: LightState
    let onBrightnessChange: (Double) -> Void
    let onColorChange: (LightState.LightColor) -> Void

    @State private var localBrightness: Double
    @State private var localColor: LightState.LightColor

    init(
        state: LightState,
        onBrightnessChange: @escaping (Double) -> Void,
        onColorChange: @escaping (LightState.LightColor) -> Void
    ) {
        self.state = state
        self.onBrightnessChange = onBrightnessChange
        self.onColorChange = onColorChange
        self._localBrightness = State(initialValue: state.brightness)
        self._localColor = State(initialValue: state.color)
    }

    private var colorForCurrentSelection: Color {
        switch localColor {
        case .white: return .white
        case .warmWhite: return Color(red: 1.0, green: 0.95, blue: 0.8)
        case .red: return .red
        case .green: return .green
        case .blue: return .blue
        case .yellow: return .yellow
        case .purple: return .purple
        case .orange: return .orange
        }
    }

    var body: some View {
        VStack(spacing: 25) {
            // Circular Brightness Dial
            CircularBrightnessDial(
                brightness: $localBrightness,
                accentColor: colorForCurrentSelection,
                onChange: { newValue in
                    onBrightnessChange(newValue)
                }
            )

            // Color Picker
            VStack(alignment: .leading, spacing: 15) {
                Text("Color")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.black)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(LightState.LightColor.allCases, id: \.self) { color in
                            ColorCircle(
                                color: color,
                                isSelected: localColor == color,
                                action: {
                                    localColor = color
                                    onColorChange(color)
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 5)
                    .padding(.vertical, 5)
                }
            }
            .padding(20)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white.opacity(0.1))
            }
        }
        .padding(20)
        .background {
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.15),
                            Color.white.opacity(0.05)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        }
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.3),
                            Color.white.opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        )
        .shadow(color: .yellow.opacity(0.3), radius: 15, x: 0, y: 8)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 10)
    }
}

struct ColorCircle: View {
    let color: LightState.LightColor
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Circle()
                .fill(swiftUIColor)
                .frame(width: 50, height: 50)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: isSelected ? 3 : 0)
                )
                .shadow(color: swiftUIColor.opacity(0.5), radius: isSelected ? 8 : 4, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }

    private var swiftUIColor: Color {
        switch color {
        case .white:
            return .white
        case .warmWhite:
            return Color(red: 1.0, green: 0.95, blue: 0.8)
        case .red:
            return .red
        case .green:
            return .green
        case .blue:
            return .blue
        case .yellow:
            return .yellow
        case .purple:
            return .purple
        case .orange:
            return .orange
        }
    }
}

#Preview {
    ZStack {
        Color(.background).ignoresSafeArea()

        LightControllerView(
            state: LightState(brightness: 75.0, color: .white),
            onBrightnessChange: { brightness in print("Brightness: \(brightness)") },
            onColorChange: { color in print("Color: \(color)") }
        )
        .padding()
    }
}
