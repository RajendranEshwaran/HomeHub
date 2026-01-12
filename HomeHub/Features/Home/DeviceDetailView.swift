//
//  DeviceDetailView.swift
//  HomeHub
//
//  Created by Rajendran Eshwaran on 1/12/26.
//

import SwiftUI
import Foundation
import Combine

struct DeviceDetailView: View {
    @EnvironmentObject private var coordinator: Coordinator
    let deviceDetail: Device
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            VStack {
                GenericNavigation(action: {}, navigationTitle: deviceDetail.deviceName, isBackEnable: true, isForwardEnable: true, backgroundColor: .clear, foregroundColor: .black, leadingView: {
                    TrailingNavigationBarItemButton(icon: "", action: {
                        coordinator.coordinatorPopToPreviousPage()
                    })
                    
                }, trailingView: {}).frame(height: 60)
            }.navigationBarHidden(true)
        }.environmentObject(coordinator)
    }
}
