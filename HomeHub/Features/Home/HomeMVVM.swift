//
//  HomeMVVM.swift
//  HomeHub
//
//  Created by Rajendran Eshwaran on 12/17/25.
//

import Foundation
import Combine
import SwiftUI

//MARK: - Wish Model
struct Wish: Identifiable {
    let id = UUID()
    let greeting: String
    let icon: String
    let bgColor: Color
}

//MARK: - Home Status Model
struct HomeStatus: Identifiable {
    let id = UUID()
    let status: String
    let icon: String
    let bgColor: Color
}

//MARK: - Home Room Model
struct HomeRoom: Identifiable {
    let id = UUID()
    let roomName: String
    let icon: String
    let bgColor: Color
    let deviceCount: Int
}

//MARK: - Device Type
enum DeviceType: String, Codable, Hashable {
    case ac = "Air Conditioner"
    case light = "Light"
    case speaker = "Speaker"
    case musicSystem = "Music System"
    case television = "Smart TV"
    case generic = "Generic Device"
}

//MARK: - AC State
struct ACState: Hashable, Codable {
    var temperature: Double = 24.0 // Celsius
    var fanSpeed: FanSpeed = .medium
    var mode: ACMode = .cool

    enum FanSpeed: String, Codable, CaseIterable, Hashable {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
        case auto = "Auto"
    }

    enum ACMode: String, Codable, CaseIterable, Hashable {
        case cool = "Cool"
        case heat = "Heat"
        case fan = "Fan"
        case dry = "Dry"
    }
}

//MARK: - Light State
struct LightState: Hashable, Codable {
    var brightness: Double = 100.0 // 0-100
    var color: LightColor = .white

    enum LightColor: String, Codable, CaseIterable, Hashable {
        case white = "White"
        case warmWhite = "Warm White"
        case red = "Red"
        case green = "Green"
        case blue = "Blue"
        case yellow = "Yellow"
        case purple = "Purple"
        case orange = "Orange"
    }
}

//MARK: - Speaker State
struct SpeakerState: Hashable, Codable {
    var volume: Double = 50.0 // 0-100
    var isPlaying: Bool = false
    var currentTrack: String = "No track playing"
}

//MARK: - Music System State
struct MusicSystemState: Hashable, Codable {
    var volume: Double = 50.0 // 0-100
    var isPlaying: Bool = false
    var currentTrack: String = "No track"
    var currentPlaylist: String = "Default"
    var trackPosition: Double = 0.0 // In seconds
    var trackDuration: Double = 180.0 // In seconds
}

//MARK: - Device Model
struct Device: Identifiable, Hashable {
    let id = UUID()
    let deviceName: String
    var deviceStatus: String
    let iconLeft: String
    let iconRight: String
    let bgColor: Color
    var isOn: Bool
    let deviceType: DeviceType
    var acState: ACState?
    var lightState: LightState?
    var speakerState: SpeakerState?
    var musicSystemState: MusicSystemState?
}

//MARK: - HomeViewModel
class HomeViewModel: ObservableObject {
    @Published var wishes: [Wish]
    @Published var homeStatuses: [HomeStatus]
    @Published var homeRooms: [HomeRoom]
    @Published var devices: [Device]
    @Published var availableDevices: Int = 0

    init() {
        self.wishes = [
            Wish(greeting: "Good Morning", icon: "sun.and.horizon", bgColor: .red),
            Wish(greeting: "Good Evening", icon: "sunset", bgColor: .buttonPurple)
        ]

        self.homeStatuses = [
            HomeStatus(status: "I'm leaving", icon: "figure.walk.departure", bgColor: .green),
            HomeStatus(status: "In home", icon: "house.fill", bgColor: .indigo)
        ]

        self.homeRooms = [
            HomeRoom(roomName: "Living Room", icon: "sofa.fill", bgColor: .orange, deviceCount: 4),
            HomeRoom(roomName: "Bedroom", icon: "bed.double.fill", bgColor: .purple, deviceCount: 3),
            HomeRoom(roomName: "Kitchen", icon: "fork.knife", bgColor: .green, deviceCount: 2),
            HomeRoom(roomName: "Bathroom", icon: "shower.fill", bgColor: .blue, deviceCount: 1)
        ]

        self.devices = [
            Device(
                deviceName: "Smart TV",
                deviceStatus: "Connected",
                iconLeft: "tv.fill",
                iconRight: "wifi",
                bgColor: .orange,
                isOn: true,
                deviceType: .television,
                acState: nil,
                lightState: nil,
                speakerState: SpeakerState(volume: 50.0, isPlaying: true, currentTrack: "Summer Vibes Mix"),
                musicSystemState: nil
            ),
            Device(
                deviceName: "Air Conditioner",
                deviceStatus: "24°C - Cool Mode",
                iconLeft: "snowflake",
                iconRight: "wind",
                bgColor: .blue,
                isOn: true,
                deviceType: .ac,
                acState: ACState(temperature: 24.0, fanSpeed: .medium, mode: .cool),
                lightState: nil,
                speakerState: nil,
                musicSystemState: nil
            ),
            Device(
                deviceName: "Smart Lights",
                deviceStatus: "100% Brightness",
                iconLeft: "lightbulb.fill",
                iconRight: "antenna.radiowaves.left.and.right",
                bgColor: .yellow,
                isOn: true,
                deviceType: .light,
                acState: nil,
                lightState: LightState(brightness: 100.0, color: .white),
                speakerState: nil,
                musicSystemState: nil
            ),
            Device(
                deviceName: "Speaker",
                deviceStatus: "Playing",
                iconLeft: "hifispeaker.fill",
                iconRight: "music.note",
                bgColor: .purple,
                isOn: true,
                deviceType: .speaker,
                acState: nil,
                lightState: nil,
                speakerState: SpeakerState(volume: 50.0, isPlaying: true, currentTrack: "Summer Vibes Mix"),
                musicSystemState: nil
            )
        ]
        updateAvailableDevices()
    }

    func addDevice(deviceName: String, deviceStatus: String, iconLeft: String, iconRight: String, bgColor: Color, deviceType: DeviceType = .generic) {
        let newDevice = Device(
            deviceName: deviceName,
            deviceStatus: deviceStatus,
            iconLeft: iconLeft,
            iconRight: iconRight,
            bgColor: bgColor,
            isOn: false,
            deviceType: deviceType,
            acState: deviceType == .ac ? ACState() : nil,
            lightState: deviceType == .light ? LightState() : nil,
            speakerState: deviceType == .speaker || deviceType == .speaker ? SpeakerState() : nil,
            musicSystemState: deviceType == .musicSystem ? MusicSystemState() : nil
        )
        devices.append(newDevice)
        updateAvailableDevices()
    }

    func toggleDevice(device: Device, isOn: Bool) {
        if let index = devices.firstIndex(where: { $0.id == device.id }) {
            devices[index].isOn = isOn
        }
    }

    private func updateAvailableDevices() {
        availableDevices = devices.count
    }

    //MARK: - AC Controls
    func updateACTemperature(device: Device, temperature: Double) {
        if let index = devices.firstIndex(where: { $0.id == device.id }) {
            devices[index].acState?.temperature = temperature
            let mode = devices[index].acState?.mode.rawValue ?? ""
            devices[index].deviceStatus = "\(Int(temperature))°C - \(mode)"
        }
    }

    func updateACFanSpeed(device: Device, speed: ACState.FanSpeed) {
        if let index = devices.firstIndex(where: { $0.id == device.id }) {
            devices[index].acState?.fanSpeed = speed
        }
    }

    func updateACMode(device: Device, mode: ACState.ACMode) {
        if let index = devices.firstIndex(where: { $0.id == device.id }) {
            devices[index].acState?.mode = mode
            let temp = devices[index].acState?.temperature ?? 24
            devices[index].deviceStatus = "\(Int(temp))°C - \(mode.rawValue)"
        }
    }

    //MARK: - Light Controls
    func updateLightBrightness(device: Device, brightness: Double) {
        if let index = devices.firstIndex(where: { $0.id == device.id }) {
            devices[index].lightState?.brightness = brightness
            devices[index].deviceStatus = "\(Int(brightness))% Brightness"
        }
    }

    func updateLightColor(device: Device, color: LightState.LightColor) {
        if let index = devices.firstIndex(where: { $0.id == device.id }) {
            devices[index].lightState?.color = color
            let brightness = devices[index].lightState?.brightness ?? 100
            devices[index].deviceStatus = "\(color.rawValue) - \(Int(brightness))%"
        }
    }

    //MARK: - Speaker Controls
    func updateSpeakerVolume(device: Device, volume: Double) {
        if let index = devices.firstIndex(where: { $0.id == device.id }) {
            devices[index].speakerState?.volume = volume
        }
    }

    func toggleSpeakerPlayback(device: Device) {
        if let index = devices.firstIndex(where: { $0.id == device.id }) {
            devices[index].speakerState?.isPlaying.toggle()
            let playing = devices[index].speakerState?.isPlaying ?? false
            devices[index].deviceStatus = playing ? "Playing" : "Paused"
        }
    }

    //MARK: - Music System Controls
    func updateMusicSystemVolume(device: Device, volume: Double) {
        if let index = devices.firstIndex(where: { $0.id == device.id }) {
            devices[index].musicSystemState?.volume = volume
        }
    }

    func toggleMusicSystemPlayback(device: Device) {
        if let index = devices.firstIndex(where: { $0.id == device.id }) {
            devices[index].musicSystemState?.isPlaying.toggle()
            let playing = devices[index].musicSystemState?.isPlaying ?? false
            devices[index].deviceStatus = playing ? "Playing" : "Paused"
        }
    }

    func seekMusicSystemTrack(device: Device, position: Double) {
        if let index = devices.firstIndex(where: { $0.id == device.id }) {
            devices[index].musicSystemState?.trackPosition = position
        }
    }

    func musicSystemPreviousTrack(device: Device) {
        if let index = devices.firstIndex(where: { $0.id == device.id }) {
            devices[index].musicSystemState?.currentTrack = "Previous Track"
            devices[index].musicSystemState?.trackPosition = 0
        }
    }

    func musicSystemNextTrack(device: Device) {
        if let index = devices.firstIndex(where: { $0.id == device.id }) {
            devices[index].musicSystemState?.currentTrack = "Next Track"
            devices[index].musicSystemState?.trackPosition = 0
        }
    }
}
