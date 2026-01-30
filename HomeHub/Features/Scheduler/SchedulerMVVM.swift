//
//  SchedulerMVVM.swift
//  HomeHub
//
//  Created by Rajendran Eshwaran on 1/30/26.
//

import Foundation
import SwiftUI
import Combine

// MARK: - Schedule Model
struct DeviceSchedule: Identifiable, Hashable, Codable {
    let id: UUID
    var name: String
    var deviceId: UUID
    var deviceName: String
    var deviceType: DeviceType
    var time: Date
    var repeatDays: Set<Weekday>
    var isEnabled: Bool
    var action: ScheduleAction

    init(
        id: UUID = UUID(),
        name: String,
        deviceId: UUID,
        deviceName: String,
        deviceType: DeviceType,
        time: Date,
        repeatDays: Set<Weekday> = [],
        isEnabled: Bool = true,
        action: ScheduleAction
    ) {
        self.id = id
        self.name = name
        self.deviceId = deviceId
        self.deviceName = deviceName
        self.deviceType = deviceType
        self.time = time
        self.repeatDays = repeatDays
        self.isEnabled = isEnabled
        self.action = action
    }

    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: time)
    }

    var repeatDescription: String {
        if repeatDays.isEmpty {
            return "Once"
        } else if repeatDays.count == 7 {
            return "Every day"
        } else if repeatDays == [.saturday, .sunday] {
            return "Weekends"
        } else if repeatDays == [.monday, .tuesday, .wednesday, .thursday, .friday] {
            return "Weekdays"
        } else {
            return repeatDays.sorted { $0.rawValue < $1.rawValue }
                .map { $0.shortName }
                .joined(separator: ", ")
        }
    }
}

// MARK: - Weekday
enum Weekday: Int, Codable, CaseIterable, Hashable {
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7

    var shortName: String {
        switch self {
        case .sunday: return "Sun"
        case .monday: return "Mon"
        case .tuesday: return "Tue"
        case .wednesday: return "Wed"
        case .thursday: return "Thu"
        case .friday: return "Fri"
        case .saturday: return "Sat"
        }
    }

    var initial: String {
        switch self {
        case .sunday: return "S"
        case .monday: return "M"
        case .tuesday: return "T"
        case .wednesday: return "W"
        case .thursday: return "T"
        case .friday: return "F"
        case .saturday: return "S"
        }
    }
}

// MARK: - Schedule Action
struct ScheduleAction: Hashable, Codable {
    var turnOn: Bool
    var acSettings: ACScheduleSettings?
    var lightSettings: LightScheduleSettings?
    var speakerSettings: SpeakerScheduleSettings?

    static func defaultAction(for deviceType: DeviceType) -> ScheduleAction {
        switch deviceType {
        case .ac:
            return ScheduleAction(
                turnOn: true,
                acSettings: ACScheduleSettings(),
                lightSettings: nil,
                speakerSettings: nil
            )
        case .light:
            return ScheduleAction(
                turnOn: true,
                acSettings: nil,
                lightSettings: LightScheduleSettings(),
                speakerSettings: nil
            )
        case .speaker, .musicSystem, .television:
            return ScheduleAction(
                turnOn: true,
                acSettings: nil,
                lightSettings: nil,
                speakerSettings: SpeakerScheduleSettings()
            )
        case .generic:
            return ScheduleAction(
                turnOn: true,
                acSettings: nil,
                lightSettings: nil,
                speakerSettings: nil
            )
        }
    }
}

// MARK: - Device-Specific Schedule Settings
struct ACScheduleSettings: Hashable, Codable {
    var temperature: Double = 24.0
    var fanSpeed: ACState.FanSpeed = .medium
    var mode: ACState.ACMode = .cool
}

struct LightScheduleSettings: Hashable, Codable {
    var brightness: Double = 100.0
    var color: LightState.LightColor = .white
}

struct SpeakerScheduleSettings: Hashable, Codable {
    var volume: Double = 50.0
    var playMusic: Bool = false
}

// MARK: - Scheduler ViewModel
class SchedulerViewModel: ObservableObject {
    @Published var schedules: [DeviceSchedule] = []

    func addSchedule(_ schedule: DeviceSchedule) {
        schedules.append(schedule)
    }

    func updateSchedule(_ schedule: DeviceSchedule) {
        if let index = schedules.firstIndex(where: { $0.id == schedule.id }) {
            schedules[index] = schedule
        }
    }

    func deleteSchedule(_ schedule: DeviceSchedule) {
        schedules.removeAll { $0.id == schedule.id }
    }

    func toggleSchedule(_ schedule: DeviceSchedule) {
        if let index = schedules.firstIndex(where: { $0.id == schedule.id }) {
            schedules[index].isEnabled.toggle()
        }
    }

    func schedules(for device: Device) -> [DeviceSchedule] {
        schedules.filter { $0.deviceId == device.id }
    }
}
