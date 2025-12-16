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
    @EnvironmentObject private var coordinator: Coordinator
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            coordinator.currentPageView(view: coordinator.rootPage)
                .navigationDestination(for: AppPages.self) { page in
                    coordinator.currentPageView(view: page)
                        .environmentObject(coordinator)
                }
            
                .sheet(item: $coordinator.currentSheet){ sheet in
                    coordinator.currentSheetView(sheet: sheet)
                        .environmentObject(coordinator)
                }
            
                .fullScreenCover(item: $coordinator.currentFullCover){ cover in
                    coordinator.currentFullCoverView(cover: cover)
                        .environmentObject(coordinator)
                }
        }.environmentObject(coordinator)
    }
}
