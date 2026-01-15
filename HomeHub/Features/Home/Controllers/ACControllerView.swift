//
//  ACControllerView.swift
//  HomeHub
//
//  Created by Rajendran Eshwaran on 1/12/26.
//

import SwiftUI

struct ACControllerView: View {
    let state: ACState
    let onTemperatureChange: (Double) -> Void
    let onFanSpeedChange: (ACState.FanSpeed) -> Void
    let onModeChange: (ACState.ACMode) -> Void

    @State private var localTemperature: Double
    @State private var localFanSpeed: ACState.FanSpeed
    @State private var localMode: ACState.ACMode
    @EnvironmentObject private var coordinator: Coordinator
    init(
        state: ACState,
        onTemperatureChange: @escaping (Double) -> Void,
        onFanSpeedChange: @escaping (ACState.FanSpeed) -> Void,
        onModeChange: @escaping (ACState.ACMode) -> Void
    ) {
        self.state = state
        self.onTemperatureChange = onTemperatureChange
        self.onFanSpeedChange = onFanSpeedChange
        self.onModeChange = onModeChange
        self._localTemperature = State(initialValue: state.temperature)
        self._localFanSpeed = State(initialValue: state.fanSpeed)
        self._localMode = State(initialValue: state.mode)
    }

    var body: some View {
    
            VStack(spacing: 25) {
                
                // Circular Temperature Dial
                CircularTemperatureDial(
                    temperature: $localTemperature,
                    minTemp: 16,
                    maxTemp: 30,
                    step: 1,
                    onChange: { newValue in
                        onTemperatureChange(newValue)
                    }
                )
                
                // Fan Speed Control
                SegmentedControl(
                    selection: $localFanSpeed,
                    accentColor: .cyan,
                    label: "Fan Speed"
                )
                .onChange(of: localFanSpeed) { oldValue, newValue in
                    onFanSpeedChange(newValue)
                }
                
                // Mode Control
                SegmentedControl(
                    selection: $localMode,
                    accentColor: .blue,
                    label: "Mode"
                )
                .onChange(of: localMode) { oldValue, newValue in
                    onModeChange(newValue)
                }
            }
            .padding(20)
            .background {
                RoundedRectangle(cornerRadius: 25)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.15),
                                Color.white.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.3),
                                Color.white.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            )
            .shadow(color: .blue.opacity(0.3), radius: 15, x: 0, y: 8)
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 10)
    }
}

#Preview {
    ZStack {
        Color(.background).ignoresSafeArea()

        ACControllerView(
            state: ACState(temperature: 24.0, fanSpeed: .medium, mode: .cool),
            onTemperatureChange: { temp in print("Temperature: \(temp)") },
            onFanSpeedChange: { speed in print("Fan Speed: \(speed)") },
            onModeChange: { mode in print("Mode: \(mode)") }
        )
        .padding()
    }
}
