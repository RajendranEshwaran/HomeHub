//
//  ActionDeviceCard.swift
//  HomeHub
//
//  Created by Rajendran Eshwaran on 1/20/26.
//

import SwiftUI

struct ActionDeviceCard: View {
    let deviceName: String
    let roomName: String
    var icon: String = "lightbulb.fill"
    var iconColor: Color = .yellow
    @Binding var isOn: Bool
    var onToggle: ((Bool) -> Void)?

    var body: some View {
        HStack(spacing: 12) {
            deviceIcon

            deviceInfo

            Spacer()

            toggleButton
        }
        .padding(12)
        .background { cardBackground }
    }

    private var deviceIcon: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            iconColor.opacity(0.3),
                            iconColor.opacity(0.15)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 50, height: 50)
                .overlay(
                    Circle()
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
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.7),
                                    Color.white.opacity(0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: iconColor.opacity(0.3), radius: 4, x: 0, y: 2)

            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(iconColor)
        }
    }

    private var deviceInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(deviceName)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)

            Text(roomName)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }

    private var toggleButton: some View {
        Button {
            isOn.toggle()
            onToggle?(isOn)
        } label: {
            ZStack {
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [
                                isOn ? Color.purple.opacity(0.7) : Color.gray.opacity(0.3),
                                isOn ? Color.purple.opacity(0.5) : Color.gray.opacity(0.2)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 30)
                    .overlay(
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(isOn ? 0.4 : 0.3),
                                        Color.white.opacity(0.0)
                                    ],
                                    startPoint: .top,
                                    endPoint: .center
                                )
                            )
                    )
                    .overlay(
                        Capsule()
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(isOn ? 0.8 : 0.5),
                                        Color.white.opacity(isOn ? 0.3 : 0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .shadow(
                        color: isOn ? Color.purple.opacity(0.4) : Color.black.opacity(0.1),
                        radius: isOn ? 6 : 3,
                        x: 0,
                        y: 2
                    )

                HStack(spacing: 0) {
                    Text("ON")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(isOn ? .white : .white.opacity(0.4))
                        .frame(width: 34)

                    Text("OFF")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(isOn ? .white.opacity(0.4) : .white)
                        .frame(width: 34)
                }

                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white,
                                Color.white.opacity(0.9)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 24, height: 24)
                    .shadow(color: .black.opacity(0.15), radius: 2, x: 0, y: 1)
                    .offset(x: isOn ? -26 : 26)
            }
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isOn)
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.7),
                        Color.white.opacity(0.6)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
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
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.7),
                                Color.white.opacity(0.2)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}

struct ActionDeviceCardList: View {
    @Binding var devices: [DeviceItem]

    var body: some View {
        VStack(spacing: 12) {
            ForEach($devices) { $device in
                ActionDeviceCard(
                    deviceName: device.name,
                    roomName: device.roomName,
                    icon: device.icon,
                    iconColor: device.color,
                    isOn: $device.isOn
                )
            }
        }
    }
}

struct DeviceItem: Identifiable {
    let id: UUID
    var name: String
    var roomName: String
    var icon: String
    var color: Color
    var isOn: Bool

    init(id: UUID = UUID(), name: String, roomName: String, icon: String = "lightbulb.fill", color: Color = .yellow, isOn: Bool = false) {
        self.id = id
        self.name = name
        self.roomName = roomName
        self.icon = icon
        self.color = color
        self.isOn = isOn
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()

        VStack(spacing: 16) {
            ActionDeviceCard(
                deviceName: "Ceiling Light",
                roomName: "Living Room",
                icon: "lightbulb.fill",
                iconColor: .yellow,
                isOn: .constant(true)
            )

            ActionDeviceCard(
                deviceName: "Air Conditioner",
                roomName: "Bedroom",
                icon: "air.conditioner.horizontal.fill",
                iconColor: .cyan,
                isOn: .constant(false)
            )

            ActionDeviceCard(
                deviceName: "Smart TV",
                roomName: "Living Room",
                icon: "tv.fill",
                iconColor: .indigo,
                isOn: .constant(true)
            )

            ActionDeviceCard(
                deviceName: "Speaker",
                roomName: "Kitchen",
                icon: "speaker.wave.2.fill",
                iconColor: .pink,
                isOn: .constant(false)
            )
        }
        .padding()
    }
}
