//
//  SchedulerCard.swift
//  HomeHub
//
//  Created by Rajendran Eshwaran on 1/30/26.
//

import SwiftUI

struct SchedulerCard: View {
    let schedule: DeviceSchedule
    let onToggle: (Bool) -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void

    @State private var showDeleteConfirmation = false

    var body: some View {
        HStack(spacing: 15) {
            // Device Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                deviceColor.opacity(0.8),
                                deviceColor.opacity(0.4)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)

                Image(systemName: deviceIcon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(.white)
            }

            // Schedule Info
            VStack(alignment: .leading, spacing: 4) {
                Text(schedule.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)

                Text(schedule.deviceName)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.white.opacity(0.7))

                HStack(spacing: 8) {
                    // Time
                    HStack(spacing: 4) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 10))
                        Text(schedule.formattedTime)
                            .font(.system(size: 12, weight: .medium))
                    }
                    .foregroundStyle(.white.opacity(0.6))

                    // Repeat
                    Text("•")
                        .foregroundStyle(.white.opacity(0.4))

                    Text(schedule.repeatDescription)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.white.opacity(0.6))
                }
            }

            Spacer()

            // Actions
            VStack(spacing: 10) {
                // Toggle
                Toggle("", isOn: Binding(
                    get: { schedule.isEnabled },
                    set: { onToggle($0) }
                ))
                .toggleStyle(SwitchToggleStyle(tint: deviceColor))
                .labelsHidden()

                // Edit & Delete buttons
                HStack(spacing: 8) {
                    Button(action: onEdit) {
                        Image(systemName: "pencil")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.white.opacity(0.7))
                            .frame(width: 28, height: 28)
                            .background(Color.white.opacity(0.1))
                            .clipShape(Circle())
                    }

                    Button(action: { showDeleteConfirmation = true }) {
                        Image(systemName: "trash")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.red.opacity(0.8))
                            .frame(width: 28, height: 28)
                            .background(Color.red.opacity(0.1))
                            .clipShape(Circle())
                    }
                }
            }
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.12),
                            Color.white.opacity(0.05)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
        }
        .overlay(
            RoundedRectangle(cornerRadius: 20)
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
        .opacity(schedule.isEnabled ? 1 : 0.6)
        .alert("Delete Schedule", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to delete '\(schedule.name)'?")
        }
    }

    private var deviceIcon: String {
        switch schedule.deviceType {
        case .ac: return "snowflake"
        case .light: return "lightbulb.fill"
        case .speaker: return "hifispeaker.fill"
        case .musicSystem: return "hifispeaker.2.fill"
        case .television: return "tv.fill"
        case .generic: return "antenna.radiowaves.left.and.right"
        }
    }

    private var deviceColor: Color {
        switch schedule.deviceType {
        case .ac: return .blue
        case .light: return .yellow
        case .speaker: return .purple
        case .musicSystem: return .pink
        case .television: return .orange
        case .generic: return .gray
        }
    }
}

// MARK: - Schedule List View
struct ScheduleListView: View {
    @ObservedObject var viewModel: SchedulerViewModel
    let devices: [Device]
    let onAddNew: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Header
            HStack {
                Text("Schedules")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)

                Spacer()

                Button(action: onAddNew) {
                    HStack(spacing: 6) {
                        Image(systemName: "plus")
                            .font(.system(size: 14, weight: .semibold))
                        Text("Add")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(
                        LinearGradient(
                            colors: [.indigo, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(Capsule())
                }
            }
            .padding(.horizontal, 20)

            if viewModel.schedules.isEmpty {
                // Empty State
                VStack(spacing: 15) {
                    Image(systemName: "calendar.badge.clock")
                        .font(.system(size: 50))
                        .foregroundStyle(.white.opacity(0.4))

                    Text("No Schedules")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.7))

                    Text("Add schedules to automate your devices")
                        .font(.system(size: 14))
                        .foregroundStyle(.white.opacity(0.5))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                // Schedule Cards
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(viewModel.schedules) { schedule in
                            SchedulerCard(
                                schedule: schedule,
                                onToggle: { _ in
                                    viewModel.toggleSchedule(schedule)
                                },
                                onEdit: {
                                    // Handle edit
                                },
                                onDelete: {
                                    viewModel.deleteSchedule(schedule)
                                }
                            )
                            .frame(width: 320)
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
    }
}

#Preview {
    ZStack {
        GlassyBackground()

        ScrollView {
            VStack(spacing: 20) {
                SchedulerCard(
                    schedule: DeviceSchedule(
                        name: "Morning Lights",
                        deviceId: UUID(),
                        deviceName: "Living Room Light",
                        deviceType: .light,
                        time: Date(),
                        repeatDays: [.monday, .tuesday, .wednesday, .thursday, .friday],
                        isEnabled: true,
                        action: .defaultAction(for: .light)
                    ),
                    onToggle: { _ in },
                    onEdit: {},
                    onDelete: {}
                )

                SchedulerCard(
                    schedule: DeviceSchedule(
                        name: "Cool Down",
                        deviceId: UUID(),
                        deviceName: "Bedroom AC",
                        deviceType: .ac,
                        time: Date(),
                        repeatDays: [],
                        isEnabled: false,
                        action: .defaultAction(for: .ac)
                    ),
                    onToggle: { _ in },
                    onEdit: {},
                    onDelete: {}
                )
            }
            .padding(20)
        }
    }
}
