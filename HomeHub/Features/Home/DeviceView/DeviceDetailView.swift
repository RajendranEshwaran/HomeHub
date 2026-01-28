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
    @EnvironmentObject private var viewModel: HomeViewModel
    let deviceDetail: Device

    var body: some View {
        ZStack {
//            Color.background
//                .ignoresSafeArea()
            GlassyBackground()
            VStack(spacing: 0) {
                // Navigation Header
                GenericNavigation(
                    action: {},
                    navigationTitle: deviceDetail.deviceName,
                    isBackEnable: true,
                    isForwardEnable: false,
                    backgroundColor: .clear,
                    foregroundColor: .white,
                    leadingView: {
                        TrailingNavigationBarItemButton(icon: "", action: {
                            coordinator.coordinatorPopToPreviousPage()
                        }, fontColor: .white)
                    },
                    trailingView: {}
                )
                .frame(height: 60)

                ScrollView {
                    VStack(spacing: 30) {
                        // Device Info Card
                        deviceInfoCard()

                        // Controller based on device type
                        controllerView()
                            .padding(.horizontal, 20)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                }
            }
            .navigationBarHidden(true)
        }
        .environmentObject(coordinator)
    }

    @ViewBuilder
    private func deviceInfoCard() -> some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: deviceDetail.iconLeft)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(.white)

                Image(systemName: deviceDetail.iconRight)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(.white)

                Spacer()

                // ON/OFF Status
                Text(deviceDetail.isOn ? "ON" : "OFF")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        deviceDetail.isOn
                            ? Color.green.opacity(0.3)
                            : Color.red.opacity(0.3)
                    )
                    .clipShape(Capsule())
            }
            .padding(.horizontal, 20)

            Text(deviceDetail.deviceName)
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)

            Text(deviceDetail.deviceStatus)
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(.white.opacity(0.8))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
        }
        .padding(.vertical, 30)
        .frame(maxWidth: .infinity)
        .background {
            ZStack {
                MeshGradient(
                    width: 3,
                    height: 3,
                    points: [
                        [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                        [0.0, 0.5], [0.5, 0.5], [1.0, 0.5],
                        [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
                    ],
                    colors: [
                        deviceDetail.bgColor, deviceDetail.bgColor.opacity(0.8), deviceDetail.bgColor,
                        deviceDetail.bgColor.opacity(0.8), deviceDetail.bgColor.opacity(0.6), deviceDetail.bgColor.opacity(0.8),
                        deviceDetail.bgColor, deviceDetail.bgColor.opacity(0.8), deviceDetail.bgColor
                    ]
                )
                .blur(radius: 10)

                LinearGradient(
                    colors: [
                        Color.white.opacity(0.4),
                        Color.white.opacity(0.2),
                        Color.white.opacity(0.1)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.5),
                            Color.white.opacity(0.2)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        )
        .shadow(color: deviceDetail.bgColor.opacity(0.3), radius: 15, x: 0, y: 8)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 10)
        .padding(.horizontal, 20)
    }

    @ViewBuilder
    private func controllerView() -> some View {
        switch deviceDetail.deviceType {
        case .ac:
            if let acState = deviceDetail.acState {
                ACControllerView(
                    state: acState,
                    onTemperatureChange: { temp in
                        viewModel.updateACTemperature(device: deviceDetail, temperature: temp)
                    },
                    onFanSpeedChange: { speed in
                        viewModel.updateACFanSpeed(device: deviceDetail, speed: speed)
                    },
                    onModeChange: { mode in
                        viewModel.updateACMode(device: deviceDetail, mode: mode)
                    }
                )
            } else {
                emptyStateView()
            }

        case .light:
            if let lightState = deviceDetail.lightState {
                LightControllerView(
                    state: lightState,
                    onBrightnessChange: { brightness in
                        viewModel.updateLightBrightness(device: deviceDetail, brightness: brightness)
                    },
                    onColorChange: { color in
                        viewModel.updateLightColor(device: deviceDetail, color: color)
                    }
                )
            } else {
                emptyStateView()
            }

        case .speaker, .television:
            if let speakerState = deviceDetail.speakerState {
                SpeakerControllerView(
                    state: speakerState,
                    onVolumeChange: { volume in
                        viewModel.updateSpeakerVolume(device: deviceDetail, volume: volume)
                    },
                    onPlayPauseToggle: {
                        viewModel.toggleSpeakerPlayback(device: deviceDetail)
                    }, deviceDetail: deviceDetail)
            } else {
                emptyStateView()
            }
            
        case .musicSystem:
            if let musicState = deviceDetail.musicSystemState {
                MusicSystemControllerView(
                    state: musicState,
                    onVolumeChange: { volume in
                        viewModel.updateMusicSystemVolume(device: deviceDetail, volume: volume)
                    },
                    onPlayPauseToggle: {
                        viewModel.toggleMusicSystemPlayback(device: deviceDetail)
                    },
                    onSeek: { position in
                        viewModel.seekMusicSystemTrack(device: deviceDetail, position: position)
                    },
                    onPrevious: {
                        viewModel.musicSystemPreviousTrack(device: deviceDetail)
                    },
                    onNext: {
                        viewModel.musicSystemNextTrack(device: deviceDetail)
                    }
                )
            } else {
                emptyStateView()
            }

        case .generic:
            genericDeviceView()
        }
    }

    @ViewBuilder
    private func emptyStateView() -> some View {
        VStack(spacing: 15) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 40))
                .foregroundStyle(.white.opacity(0.6))

            Text("No controller available")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.white.opacity(0.8))

            Text("This device doesn't have control settings configured.")
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(.white.opacity(0.6))
                .multilineTextAlignment(.center)
        }
        .padding(40)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.1))
        }
    }

    @ViewBuilder
    private func genericDeviceView() -> some View {
        VStack(spacing: 20) {
            Image(systemName: "antenna.radiowaves.left.and.right")
                .font(.system(size: 50))
                .foregroundStyle(.white.opacity(0.7))

            Text("Generic Device")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white)

            Text("This is a generic smart device without specific controls.")
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
        .padding(40)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.1))
        }
    }
}
