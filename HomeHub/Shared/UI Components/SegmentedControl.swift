//
//  SegmentedControl.swift
//  HomeHub
//
//  Created by Rajendran Eshwaran on 1/12/26.
//

import SwiftUI

struct SegmentedControl<T: RawRepresentable & CaseIterable & Hashable>: View where T.RawValue == String {
    @Binding var selection: T
    let options: [T]
    let accentColor: Color
    let label: String?

    init(
        selection: Binding<T>,
        options: [T]? = nil,
        accentColor: Color = .white,
        label: String? = nil
    ) {
        self._selection = selection
        self.options = options ?? Array(T.allCases as! [T])
        self.accentColor = accentColor
        self.label = label
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let label = label {
                Text(label)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.black)
            }

            HStack(spacing: 8) {
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selection = option
                        }
                    }) {
                        Text(option.rawValue)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(selection == option ? .black : .black.opacity(0.5))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background {
                                if selection == option {
                                    // Selected button - glassy effect
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    accentColor.opacity(0.5),
                                                    accentColor.opacity(0.3)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(
                                                    LinearGradient(
                                                        colors: [
                                                            Color.white.opacity(0.4),
                                                            Color.white.opacity(0.0)
                                                        ],
                                                        startPoint: .top,
                                                        endPoint: .center
                                                    )
                                                )
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(
                                                    LinearGradient(
                                                        colors: [
                                                            Color.white.opacity(0.6),
                                                            Color.white.opacity(0.2)
                                                        ],
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    ),
                                                    lineWidth: 1
                                                )
                                        )
                                        .shadow(color: accentColor.opacity(0.4), radius: 8, x: 0, y: 4)
                                } else {
                                    // Unselected button - subtle glassy
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white.opacity(0.08))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                                        )
                                }
                            }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(8)
            .background {
                // Container glassy background
                RoundedRectangle(cornerRadius: 18)
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
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.2),
                                        Color.white.opacity(0.0)
                                    ],
                                    startPoint: .top,
                                    endPoint: .center
                                )
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
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
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        }
    }
}

#Preview {
    ZStack {
        Color.blue.ignoresSafeArea()

        VStack(spacing: 30) {
            // Fan Speed Example
            SegmentedControl(
                selection: .constant(ACState.FanSpeed.medium),
                accentColor: .blue,
                label: "Fan Speed"
            )

            // AC Mode Example
            SegmentedControl(
                selection: .constant(ACState.ACMode.cool),
                accentColor: .cyan,
                label: "Mode"
            )

            // Light Color Example
            SegmentedControl(
                selection: .constant(LightState.LightColor.white),
                options: [.white, .warmWhite, .red, .blue],
                accentColor: .yellow,
                label: "Color"
            )
        }
        .padding()
    }
}
