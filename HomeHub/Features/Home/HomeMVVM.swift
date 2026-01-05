//
//  HomeMVVM.swift
//  HomeHub
//
//  Created by RajayGoms on 12/17/25.
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

//MARK: - Device Model
struct Device: Identifiable {
    let id = UUID()
    let deviceName: String
    let deviceStatus: String
    let iconLeft: String
    let iconRight: String
    let bgColor: Color
    var isOn: Bool
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
            Device(deviceName: "Smart TV", deviceStatus: "Connected", iconLeft: "tv.fill", iconRight: "wifi", bgColor: .orange, isOn: true),
            Device(deviceName: "Air Conditioner", deviceStatus: "Cool Mode", iconLeft: "snowflake", iconRight: "wind", bgColor: .blue, isOn: true),
            Device(deviceName: "Smart Lights", deviceStatus: "Disconnected", iconLeft: "lightbulb.fill", iconRight: "antenna.radiowaves.left.and.right.slash", bgColor: .yellow, isOn: false),
            Device(deviceName: "Speaker", deviceStatus: "Playing", iconLeft: "hifispeaker.fill", iconRight: "music.note", bgColor: .purple, isOn: true)
        ]
    }
}
