//
//  SchedulerView.swift
//  HomeHub
//
//  Created by Rajendran Eshwaran on 1/30/26.
//

import SwiftUI

struct SchedulerView: View {
    @EnvironmentObject var coordinator: Coordinator
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var schedulerViewModel: SchedulerViewModel

    @State private var showAddSchedule = false

    var body: some View {
        ZStack {
            GlassyBackground()

            VStack(spacing: 0) {
                // Navigation
                GenericNavigation(
                    action: {},
                    navigationTitle: "Scheduler",
                    isBackEnable: true,
                    isForwardEnable: false,
                    backgroundColor: .clear,
                    foregroundColor: .white,
                    leadingView: {
                        Button(action: {
                            coordinator.coordinatorPopToPreviousPage()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .frame(width: 40, height: 40)
                                .background(Color.white.opacity(0.1))
                                .clipShape(Circle())
                        }
                    },
                    trailingView: {
                        Button(action: { showAddSchedule = true }) {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .frame(width: 40, height: 40)
                                .background(
                                    LinearGradient(
                                        colors: [.indigo, .purple],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .clipShape(Circle())
                        }
                    }
                )
                .frame(height: 60)

                ScrollView {
                    VStack(spacing: 20) {
                        if schedulerViewModel.schedules.isEmpty {
                            emptyStateView
                        } else {
                            // Active Schedules
                            let activeSchedules = schedulerViewModel.schedules.filter { $0.isEnabled }
                            if !activeSchedules.isEmpty {
                                scheduleSection(title: "Active", schedules: activeSchedules)
                            }

                            // Inactive Schedules
                            let inactiveSchedules = schedulerViewModel.schedules.filter { !$0.isEnabled }
                            if !inactiveSchedules.isEmpty {
                                scheduleSection(title: "Inactive", schedules: inactiveSchedules)
                            }
                        }
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showAddSchedule) {
            AddEditScheduleView(
                schedulerViewModel: schedulerViewModel,
                devices: homeViewModel.devices,
                existingSchedule: nil
            )
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
                .frame(height: 80)

            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.indigo.opacity(0.3), .purple.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)

                Image(systemName: "calendar.badge.clock")
                    .font(.system(size: 50))
                    .foregroundStyle(.white.opacity(0.8))
            }

            Text("No Schedules Yet")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.white)

            Text("Create schedules to automate your\ndevices at specific times")
                .font(.system(size: 16))
                .foregroundStyle(.white.opacity(0.6))
                .multilineTextAlignment(.center)
                .lineSpacing(4)

            Button(action: { showAddSchedule = true }) {
                HStack(spacing: 10) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 20))
                    Text("Create Schedule")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 30)
                .padding(.vertical, 15)
                .background(
                    LinearGradient(
                        colors: [.indigo, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(Capsule())
                .shadow(color: .purple.opacity(0.4), radius: 15, x: 0, y: 8)
            }
            .padding(.top, 20)

            Spacer()
        }
        .padding(.horizontal, 40)
    }

    @ViewBuilder
    private func scheduleSection(title: String, schedules: [DeviceSchedule]) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.white.opacity(0.8))
                .padding(.horizontal, 20)

            ForEach(schedules) { schedule in
                SchedulerCard(
                    schedule: schedule,
                    onToggle: { _ in
                        schedulerViewModel.toggleSchedule(schedule)
                    },
                    onEdit: {
                        // TODO: Open edit sheet
                    },
                    onDelete: {
                        schedulerViewModel.deleteSchedule(schedule)
                    }
                )
                .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    SchedulerView()
        .environmentObject(Coordinator())
        .environmentObject(HomeViewModel())
        .environmentObject(SchedulerViewModel())
}
