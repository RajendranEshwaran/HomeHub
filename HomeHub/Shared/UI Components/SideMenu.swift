//
//  SideMenu.swift
//  HomeHub
//
//  Created by Rajendran Eshwaran on 1/16/26.
//
import SwiftUI
import Combine

// MARK: - Side Menu View

struct SideMenuView<Header: View>: View {
    let isOpen: Bool
    let onClose: () -> Void
    let menuItems: [MenuItem]
    let header: () -> Header

    init(
        isOpen: Bool,
        onClose: @escaping () -> Void,
        menuItems: [MenuItem],
        @ViewBuilder header: @escaping () -> Header
    ) {
        self.isOpen = isOpen
        self.onClose = onClose
        self.menuItems = menuItems
        self.header = header
    }

    var body: some View {
        ZStack {
            // Dim background
            if isOpen {
                Color.background.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            onClose()
                        }
                    }
            }

            // Side menu
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    // Header
                    header()
                        .padding(.horizontal, 24)
                        .padding(.top, 60)
                        .padding(.bottom, 30)

                    // Divider
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.0),
                                    Color.white.opacity(0.3),
                                    Color.white.opacity(0.0)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(height: 1)
                        .padding(.horizontal, 20)

                    // Menu Items
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 8) {
                            ForEach(menuItems) { item in
                                MenuItemButton(item: item)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 20)
                    }

                    Spacer()

                    // App version
                    Text("HomeHub v1.0.0")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.black.opacity(0.4))
                        .padding(.horizontal, 24)
                        .padding(.bottom, 30)
                }
                .frame(width: 280)
                .background {
                    // Glassy background
                    ZStack {
                        // Base gradient
                        LinearGradient(
                            colors: [
                                Color.background.opacity(0.95),
                                Color.background.opacity(0.85)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )

                        // Glass shine effect
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.8),
                                Color.white.opacity(0.0)
                            ],
                            startPoint: .top,
                            endPoint: .center
                        )

                        // Subtle color tint
                        LinearGradient(
                            colors: [
                                Color.cyan.opacity(0.05),
                                Color.purple.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    }
                    .ignoresSafeArea()
                }
                .overlay(alignment: .trailing) {
                    // Right edge border
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.5),
                                    Color.white.opacity(0.2)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 1)
                }
                .shadow(color: .black.opacity(0.15), radius: 20, x: 5, y: 0)
                .offset(x: isOpen ? 0 : -300)

                Spacer()
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isOpen)
    }
}
