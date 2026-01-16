//
//  ACController.swift
//  HomeHub
//
//  Created by Rajendran Eshwaran on 1/15/26.
//

import SwiftUI

struct CircularTemperatureDial: View {
    @Binding var temperature: Double
    let minTemp: Double
    let maxTemp: Double
    let step: Double
    let onChange: ((Double) -> Void)?

    // Dial configuration
    private let startAngle: Double = 135  // Start from bottom-left
    private let endAngle: Double = 405    // End at bottom-right (270° sweep)
    private let dialSize: CGFloat = 250
    private let trackWidth: CGFloat = 30

    @State private var isDragging: Bool = false

    init(
        temperature: Binding<Double>,
        minTemp: Double = 16,
        maxTemp: Double = 30,
        step: Double = 1,
        onChange: ((Double) -> Void)? = nil
    ) {
        self._temperature = temperature
        self.minTemp = minTemp
        self.maxTemp = maxTemp
        self.step = step
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
                            Color.cyan,
                            Color.blue,
                            Color.cyan.opacity(0.8)
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

            // Temperature scale markers (outside)
            ForEach(Int(minTemp)...Int(maxTemp), id: \.self) { temp in
                TemperatureMarker(
                    temp: temp,
                    minTemp: Int(minTemp),
                    maxTemp: Int(maxTemp),
                    currentTemp: Int(temperature),
                    dialSize: dialSize,
                    startAngle: startAngle
                )
            }

            // Thumb/knob indicator
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.white,
                            Color.cyan.opacity(0.8)
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 12
                    )
                )
                .frame(width: 24, height: 24)
                .shadow(color: .cyan.opacity(0.8), radius: 8, x: 0, y: 0)
                .shadow(color: .white.opacity(0.5), radius: 4, x: 0, y: 0)
                .offset(x: thumbOffset.x, y: thumbOffset.y)
                .scaleEffect(isDragging ? 1.2 : 1.0)
                .animation(.spring(response: 0.3), value: isDragging)

            // Center display (current value)
            VStack(spacing: 4) {
                Text("\(Int(temperature))°")
                    .font(.system(size: 56, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.black, .black.opacity(0.8)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                Text("Celsius")
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
                    updateTemperature(at: value.location)
                }
                .onEnded { _ in
                    isDragging = false
                }
        )
    }

    // MARK: - Computed Properties

    private var progressValue: CGFloat {
        let range = maxTemp - minTemp
        return CGFloat((temperature - minTemp) / range)
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

    private func updateTemperature(at location: CGPoint) {
        let center = CGPoint(x: (dialSize + 80) / 2, y: (dialSize + 80) / 2)
        let vector = CGPoint(x: location.x - center.x, y: location.y - center.y)

        // Calculate angle from center
        var angle = atan2(vector.y, vector.x) * 180 / .pi

        // Normalize angle to our dial's coordinate system
        angle = angle - startAngle
        if angle < 0 { angle += 360 }

        // Only update if within valid range (0-270 degrees)
        guard angle >= 0 && angle <= 270 else { return }

        // Convert angle to temperature
        let progress = angle / 270
        let range = maxTemp - minTemp
        var newTemp = minTemp + (progress * range)

        // Snap to step
        newTemp = round(newTemp / step) * step
        newTemp = max(minTemp, min(maxTemp, newTemp))

        if newTemp != temperature {
            temperature = newTemp
            onChange?(newTemp)
        }
    }
}

// MARK: - Temperature Marker View

struct TemperatureMarker: View {
    let temp: Int
    let minTemp: Int
    let maxTemp: Int
    let currentTemp: Int
    let dialSize: CGFloat
    let startAngle: Double

    private var angle: Double {
        let range = Double(maxTemp - minTemp)
        let progress = Double(temp - minTemp) / range
        return startAngle + (270 * progress)
    }

    private var isActive: Bool {
        temp <= currentTemp
    }

    private var isMajor: Bool {
        temp % 2 == 0
    }

    var body: some View {
        let radius = dialSize / 2 + (isMajor ? 30 : 24)
        let radians = CGFloat(angle * .pi / 180)
        let x = Foundation.cos(radians) * radius
        let y = Foundation.sin(radians) * radius

        Group {
            if isMajor {
                // Major marker with number
                Text("\(temp)")
                    .font(.system(size: 12, weight: isActive ? .bold : .regular))
                    .foregroundStyle(isActive ? .black : .black.opacity(0.4))
            } else {
                // Minor marker (dot)
                Circle()
                    .fill(isActive ? Color.black.opacity(0.6) : Color.black.opacity(0.2))
                    .frame(width: 4, height: 4)
            }
        }
        .offset(x: x, y: y)
    }
}


// MARK: - Brightness Marker View

struct BrightnessMarker: View {
    let index: Int
    let currentBrightness: Int
    let dialSize: CGFloat
    let startAngle: Double
    let accentColor: Color

    private var angle: Double {
        let progress = Double(index) / 10.0
        return startAngle + (270 * progress)
    }

    private var isActive: Bool {
        index * 10 <= currentBrightness
    }

    var body: some View {
        let radius = dialSize / 2 + 30
        let radians = CGFloat(angle * .pi / 180)
        let x = Foundation.cos(radians) * radius
        let y = Foundation.sin(radians) * radius

        Text("\(index * 10)")
            .font(.system(size: 11, weight: isActive ? .bold : .regular))
            .foregroundStyle(isActive ? .black : .black.opacity(0.4))
            .offset(x: x, y: y)
    }
}

// MARK: - Preview

#Preview("Temperature Dial") {
    ZStack {
        Color(red: 0.1, green: 0.1, blue: 0.15).ignoresSafeArea()

        CircularTemperatureDial(
            temperature: .constant(24),
            onChange: { temp in
                print("Temperature changed to: \(temp)")
            }
        )
    }
}

