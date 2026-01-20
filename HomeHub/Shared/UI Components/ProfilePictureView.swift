//
//  ProfilePictureView.swift
//  HomeHub
//
//  Created by RajayGoms on 1/20/26.
//

import SwiftUI

struct ProfilePictureView: View {
    var image: Image?
    var size: CGFloat = 120
    var isEditable: Bool = false
    var onTap: () -> Void = {}

    var body: some View {
        Button(action: onTap) {
            ZStack {
                profileImage
                    .frame(width: size, height: size)
                    .clipShape(Circle())
                    .overlay(glassyBorder)
                    .shadow(color: .purple.opacity(0.3), radius: 10, x: 0, y: 5)
                    .shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 10)

                if isEditable {
                    editOverlay
                }
            }
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.3), value: isEditable)
    }

    @ViewBuilder
    private var profileImage: some View {
        if let image = image {
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } else {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.purple.opacity(0.4),
                                Color.indigo.opacity(0.5)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.4),
                                        Color.white.opacity(0.0)
                                    ],
                                    startPoint: .top,
                                    endPoint: .center
                                )
                            )
                    )

                Image(systemName: "person.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size * 0.5, height: size * 0.5)
                    .foregroundColor(.white.opacity(0.8))
            }
        }
    }

    private var glassyBorder: some View {
        Circle()
            .stroke(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.8),
                        Color.white.opacity(0.3)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 3
            )
    }

    private var editOverlay: some View {
        ZStack {
            Circle()
                .fill(Color.black.opacity(0.4))
                .frame(width: size, height: size)

            VStack(spacing: 4) {
                Image(systemName: "camera.fill")
                    .font(.system(size: size * 0.2))
                Text("Change")
                    .font(.system(size: size * 0.12, weight: .medium))
            }
            .foregroundColor(.white)
        }
        .transition(.opacity)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        VStack(spacing: 30) {
            ProfilePictureView(
                image: nil,
                size: 120,
                isEditable: false,
                onTap: {}
            )

            ProfilePictureView(
                image: nil,
                size: 120,
                isEditable: true,
                onTap: {}
            )

            ProfilePictureView(
                image: Image(systemName: "person.crop.circle.fill"),
                size: 100,
                isEditable: true,
                onTap: {}
            )
        }
    }
}
