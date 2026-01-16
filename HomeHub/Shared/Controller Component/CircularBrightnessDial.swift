//
//  Untitled.swift
//  HomeHub
//
//  Created by Rajendran Eshwaran on 1/15/26.
//

import SwiftUI
import Combine


// MARK: - Circular Brightness Dial

struct CircularBrightnessDial: View {
    @Binding var brightness: Double
    let accentColor: Color
    let onChange: ((Double) -> Void)?

    // Dial configuration
    private let startAngle: Double = 135
    private let dialSize: CGFloat = 250
    private let trackWidth: CGFloat = 30
    private let minValue: Double = 0
    private let maxValue: Double = 100
    private let step: Double = 1

    @State private var isDragging: Bool = false

    init(
        brightness: Binding<Double>,
        accentColor: Color = .yellow,
        onChange: ((Double) -> Void)? = nil
    ) {
        self._brightness = brightness
        self.accentColor = accentColor
        self.onChange = onChange
    }

    var body: some View {
        ZStack {
            // Background track (glassy pipe)
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.1),
                            Color.white.opacity(0.05)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: trackWidth
                )
                .frame(width: dialSize, height: dialSize)

            // Glassy pipe effect - outer glow
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.3),
                            Color.white.opacity(0.05),
                            Color.white.opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: trackWidth + 2
                )
                .blur(radius: 2)
                .frame(width: dialSize, height: dialSize)

            // Active arc (filled portion)
            Circle()
                .trim(from: 0, to: progressValue)
                .stroke(
                    AngularGradient(
                        colors: [
                            accentColor,
                            accentColor.opacity(0.7),
                            accentColor.opacity(0.9)
                        ],
                        center: .center,
                        startAngle: .degrees(startAngle),
                        endAngle: .degrees(startAngle + (270 * progressValue))
                    ),
                    style: StrokeStyle(lineWidth: trackWidth - 4, lineCap: .round)
                )
                .rotationEffect(.degrees(startAngle))
                .frame(width: dialSize, height: dialSize)

            // Inner glassy highlight on active arc
            Circle()
                .trim(from: 0, to: progressValue)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.5),
                            Color.white.opacity(0.0)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    style: StrokeStyle(lineWidth: trackWidth - 10, lineCap: .round)
                )
                .rotationEffect(.degrees(startAngle))
                .frame(width: dialSize, height: dialSize)

            // Brightness scale markers (outside)
            ForEach(0...10, id: \.self) { index in
                BrightnessMarker(
                    index: index,
                    currentBrightness: Int(brightness),
                    dialSize: dialSize,
                    startAngle: startAngle,
                    accentColor: accentColor
                )
            }

            // Thumb/knob indicator
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.white,
                            accentColor.opacity(0.8)
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 12
                    )
                )
                .frame(width: 24, height: 24)
                .shadow(color: accentColor.opacity(0.8), radius: 8, x: 0, y: 0)
                .shadow(color: .white.opacity(0.5), radius: 4, x: 0, y: 0)
                .offset(x: thumbOffset.x, y: thumbOffset.y)
                .scaleEffect(isDragging ? 1.2 : 1.0)
                .animation(.spring(response: 0.3), value: isDragging)

            // Center display (current value)
            VStack(spacing: 4) {
                Text("\(Int(brightness))%")
                    .font(.system(size: 52, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.black, .black.opacity(0.8)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                Text("Brightness")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.black.opacity(0.6))
            }
        }
        .frame(width: dialSize + 80, height: dialSize + 80)
        .contentShape(Circle())
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    isDragging = true
                    updateBrightness(at: value.location)
                }
                .onEnded { _ in
                    isDragging = false
                }
        )
    }

    // MARK: - Computed Properties

    private var progressValue: CGFloat {
        return CGFloat(brightness / maxValue)
    }

    private var thumbOffset: CGPoint {
        let radius = dialSize / 2
        let angle = startAngle + (270 * progressValue)
        let radians = CGFloat(angle * .pi / 180)

        return CGPoint(
            x: Foundation.cos(radians) * radius,
            y: Foundation.sin(radians) * radius
        )
    }

    // MARK: - Methods

    private func updateBrightness(at location: CGPoint) {
        let center = CGPoint(x: (dialSize + 80) / 2, y: (dialSize + 80) / 2)
        let vector = CGPoint(x: location.x - center.x, y: location.y - center.y)

        var angle = atan2(vector.y, vector.x) * 180 / .pi
        angle = angle - startAngle
        if angle < 0 { angle += 360 }

        guard angle >= 0 && angle <= 270 else { return }

        let progress = angle / 270
        var newValue = progress * maxValue

        newValue = round(newValue / step) * step
        newValue = max(minValue, min(maxValue, newValue))

        if newValue != brightness {
            brightness = newValue
            onChange?(newValue)
        }
    }
}


#Preview("Brightness Dial") {
    ZStack {
        Color(red: 0.1, green: 0.1, blue: 0.15).ignoresSafeArea()

        CircularBrightnessDial(
            brightness: .constant(75),
            accentColor: .yellow,
            onChange: { value in
                print("Brightness changed to: \(value)")
            }
        )
    }
}
