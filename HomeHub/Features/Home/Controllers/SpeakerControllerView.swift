//
//  SpeakerControllerView.swift
//  HomeHub
//
//  Created by Rajendran Eshwaran on 1/12/26.
//

import SwiftUI

struct SpeakerControllerView: View {
    let state: SpeakerState
    let onVolumeChange: (Double) -> Void
    let onPlayPauseToggle: () -> Void
    let deviceDetail: Device
    @State private var localVolume: Double

    init(
        state: SpeakerState,
        onVolumeChange: @escaping (Double) -> Void,
        onPlayPauseToggle: @escaping () -> Void,
        deviceDetail: Device
    ) {
        self.state = state
        self.onVolumeChange = onVolumeChange
        self.onPlayPauseToggle = onPlayPauseToggle
        self._localVolume = State(initialValue: state.volume)
        self.deviceDetail = deviceDetail
    }

    var body: some View {
        VStack(spacing: 25) {
            // Circular Volume Dial
            CircularVolumeDial(
                volume: $localVolume,
                onChange: { newValue in
                    onVolumeChange(newValue)
                }, accentColor: deviceDetail.deviceType == .speaker ? Color.purple : (deviceDetail.deviceType == .television ? .orange : .red))
            
            
            // Now Playing
            VStack(alignment: .leading, spacing: 10) {
                Text("Now Playing")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.black)

                Text(state.currentTrack)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.black.opacity(0.9))
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white.opacity(0.1))
            }

            // Playback Controls
            HStack(spacing: 20) {
                Spacer()

                // Play/Pause Button
                Button(action: onPlayPauseToggle) {
                    Image(systemName: state.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .foregroundStyle(.white)
                        .shadow(color: .purple.opacity(0.5), radius: 10, x: 0, y: 5)
                }
                .buttonStyle(.plain)

                Spacer()
            }
            .padding(.vertical, 10)
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
        .shadow(color: .purple.opacity(0.3), radius: 15, x: 0, y: 8)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 10)
    }
}

#Preview {
    ZStack {
        Color(red: 0.1, green: 0.1, blue: 0.15).ignoresSafeArea()

        SpeakerControllerView(
            state: SpeakerState(volume: 65.0, isPlaying: true, currentTrack: "Summer Vibes Mix"),
            onVolumeChange: { volume in print("Volume: \(volume)") },
            onPlayPauseToggle: { print("Play/Pause toggled") }, deviceDetail: Device(deviceName: "", deviceStatus: "", iconLeft: "", iconRight: "", bgColor: .accentColor, isOn: true, deviceType: .ac)
        )
        .padding()
    }
}
