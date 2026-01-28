//
//  CoordinatorView.swift
//  HomeHub
//
//  Created by Rajendran Eshwaran on 12/16/25.
//

import Foundation
import SwiftUI
import Combine

struct CoordinatorView: View {
    @StateObject private var coordinator = Coordinator()
    @StateObject private var homeViewModel = HomeViewModel()
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            coordinator.currentPageView(view: coordinator.rootPage)
                .navigationDestination(for: AppPages.self) { page in
                    coordinator.currentPageView(view: page)
                        .environmentObject(coordinator)
                        .environmentObject(homeViewModel)
                }

                .sheet(item: $coordinator.currentSheet){ sheet in
                    coordinator.currentSheetView(sheet: sheet)
                        .environmentObject(coordinator)
                        .environmentObject(homeViewModel)
                }

                .fullScreenCover(item: $coordinator.currentFullCover){ cover in
                    coordinator.currentFullCoverView(cover: cover)
                        .environmentObject(coordinator)
                        .environmentObject(homeViewModel)
                }
        }
        .environmentObject(coordinator)
        .environmentObject(homeViewModel)
    }
}
