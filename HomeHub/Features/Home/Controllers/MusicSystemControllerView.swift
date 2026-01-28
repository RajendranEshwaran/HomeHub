//
//  MusicSystemControllerView.swift
//  HomeHub
//
//  Created by Rajendran Eshwaran on 1/12/26.
//

import SwiftUI

struct MusicSystemControllerView: View {
    let state: MusicSystemState
    let onVolumeChange: (Double) -> Void
    let onPlayPauseToggle: () -> Void
    let onSeek: (Double) -> Void
    let onPrevious: () -> Void
    let onNext: () -> Void

    @State private var localVolume: Double
    @State private var localPosition: Double

    init(
        state: MusicSystemState,
        onVolumeChange: @escaping (Double) -> Void,
        onPlayPauseToggle: @escaping () -> Void,
        onSeek: @escaping (Double) -> Void,
        onPrevious: @escaping () -> Void,
        onNext: @escaping () -> Void
    ) {
        self.state = state
        self.onVolumeChange = onVolumeChange
        self.onPlayPauseToggle = onPlayPauseToggle
        self.onSeek = onSeek
        self.onPrevious = onPrevious
        self.onNext = onNext
        self._localVolume = State(initialValue: state.volume)
        self._localPosition = State(initialValue: state.trackPosition)
    }

    var body: some View {
        VStack(spacing: 25) {
            // Volume Control
            VStack(spacing: 15) {
                HStack {
                    Text("Volume")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                    Spacer()
                    Text("\(Int(localVolume))%")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                }

                HStack(spacing: 15) {
                    Image(systemName: "speaker.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(.white.opacity(0.7))
                        .frame(width: 24)

                    Slider(value: $localVolume, in: 0...100, step: 1.0)
                        .accentColor(.purple)
                        .onChange(of: localVolume) { oldValue, newValue in
                            onVolumeChange(newValue)
                        }

                    Image(systemName: "speaker.wave.3.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(.white.opacity(0.7))
                        .frame(width: 24)
                }
            }
            .padding(20)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white.opacity(0.1))
            }

            // Now Playing Info
            VStack(alignment: .leading, spacing: 12) {
                Text("Now Playing")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(.white.opacity(0.7))

                Text(state.currentTrack)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.white)
                    .lineLimit(2)

                HStack {
                    Image(systemName: "music.note.list")
                        .font(.system(size: 12))
                        .foregroundStyle(.white.opacity(0.6))

                    Text(state.currentPlaylist)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white.opacity(0.8))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white.opacity(0.1))
            }

            // Track Progress
            VStack(spacing: 10) {
                Text("Progress")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: 15) {
                    Text(formatTime(localPosition))
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.white.opacity(0.7))
                        .frame(width: 40, alignment: .leading)

                    Slider(value: $localPosition, in: 0...state.trackDuration, step: 1.0)
                        .accentColor(.cyan)
                        .onChange(of: localPosition) { oldValue, newValue in
                            onSeek(newValue)
                        }

                    Text(formatTime(state.trackDuration))
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.white.opacity(0.7))
                        .frame(width: 40, alignment: .trailing)
                }
            }
            .padding(20)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white.opacity(0.1))
            }

            // Playback Controls
            HStack(spacing: 30) {
                // Previous Button
                Button(action: onPrevious) {
                    Image(systemName: "backward.fill")
                        .resizable()
                        .frame(width: 30, height: 25)
                        .foregroundStyle(.white)
                }
                .buttonStyle(.plain)

                // Play/Pause Button
                Button(action: onPlayPauseToggle) {
                    Image(systemName: state.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .foregroundStyle(.white)
                        .shadow(color: .purple.opacity(0.5), radius: 10, x: 0, y: 5)
                }
                .buttonStyle(.plain)

                // Next Button
                Button(action: onNext) {
                    Image(systemName: "forward.fill")
                        .resizable()
                        .frame(width: 30, height: 25)
                        .foregroundStyle(.white)
                }
                .buttonStyle(.plain)
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

    private func formatTime(_ seconds: Double) -> String {
        let minutes = Int(seconds) / 60
        let remainingSeconds = Int(seconds) % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
}

#Preview {
    ZStack {
        Color.background.ignoresSafeArea()

        MusicSystemControllerView(
            state: MusicSystemState(
                volume: 60.0,
                isPlaying: true,
                currentTrack: "Bohemian Rhapsody",
                currentPlaylist: "Rock Classics",
                trackPosition: 90.0,
                trackDuration: 354.0
            ),
            onVolumeChange: { volume in print("Volume: \(volume)") },
            onPlayPauseToggle: { print("Play/Pause toggled") },
            onSeek: { position in print("Seek to: \(position)") },
            onPrevious: { print("Previous track") },
            onNext: { print("Next track") }
        )
        .padding()
    }
}
