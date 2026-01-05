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

//MARK: - HomeViewModel
class HomeViewModel: ObservableObject {
    @Published var wishes: [Wish]

    init() {
        self.wishes = [
            Wish(greeting: "Good Morning", icon: "sun.and.horizon", bgColor: .orange),
            Wish(greeting: "Good Evening", icon: "sunset", bgColor: .indigo)
        ]
    }
}
