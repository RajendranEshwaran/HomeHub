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

//MARK: - HomeViewModel
class HomeViewModel: ObservableObject {
    @Published var wishes: [Wish]
    @Published var homeStatuses: [HomeStatus]
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
    }
}
