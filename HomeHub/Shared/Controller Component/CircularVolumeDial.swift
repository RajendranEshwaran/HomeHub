//
//  CircularVolumeDial.swift
//  HomeHub
//
//  Created by Rajendran Eshwaran on 1/16/26.
//

import SwiftUI

struct CircularVolumeDial: View {
    @Binding var volume: Double
    let onChange: ((Double) -> Void)?
    var accentColor: Color = .purple
    // Dial configuration
    private let startAngle: Double = 135
    private let dialSize: CGFloat = 250
    private let trackWidth: CGFloat = 30
    private let minValue: Double = 0
    private let maxValue: Double = 100
    private let step: Double = 1
    

    @State private var isDragging: Bool = false

    init(
        volume: Binding<Double>,
        onChange: ((Double) -> Void)? = nil,
        accentColor: Color
    ) {
        self._volume = volume
        self.onChange = onChange
        self.accentColor = accentColor
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

            // Volume scale markers (outside)
            ForEach(0...10, id: \.self) { index in
                VolumeMarker(
                    index: index,
                    currentVolume: Int(volume),
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
            VStack(spacing: 8) {
                Image(systemName: volumeIcon)
                    .font(.system(size: 28, weight: .medium))
                    .foregroundStyle(.black.opacity(0.6))

                Text("\(Int(volume))%")
                    .font(.system(size: 52, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.black, .black.opacity(0.8)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                Text("Volume")
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
                    updateVolume(at: value.location)
                }
                .onEnded { _ in
                    isDragging = false
                }
        )
    }

    // MARK: - Computed Properties

    private var progressValue: CGFloat {
        return CGFloat(volume / maxValue)
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

    private var volumeIcon: String {
        if volume == 0 {
            return "speaker.slash.fill"
        } else if volume < 33 {
            return "speaker.wave.1.fill"
        } else if volume < 66 {
            return "speaker.wave.2.fill"
        } else {
            return "speaker.wave.3.fill"
        }
    }

    // MARK: - Methods

    private func updateVolume(at location: CGPoint) {
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

        if newValue != volume {
            volume = newValue
            onChange?(newValue)
        }
    }
}

// MARK: - Volume Marker View

struct VolumeMarker: View {
    let index: Int
    let currentVolume: Int
    let dialSize: CGFloat
    let startAngle: Double

    private var angle: Double {
        let progress = Double(index) / 10.0
        return startAngle + (270 * progress)
    }

    private var isActive: Bool {
        index * 10 <= currentVolume
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

#Preview {
    ZStack {
        Color(red: 0.1, green: 0.1, blue: 0.15).ignoresSafeArea()

        CircularVolumeDial(
            volume: .constant(65),
            onChange: { value in
                print("Volume changed to: \(value)")
            }, accentColor: .accentColor
        )
    }
}
