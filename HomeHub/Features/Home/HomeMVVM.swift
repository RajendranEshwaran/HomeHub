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

//MARK: - HomeViewModel
class HomeViewModel: ObservableObject {
    @Published var wishes: [Wish]
    @Published var homeStatuses: [HomeStatus]
    @Published var homeRooms: [HomeRoom]
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
    }
}
