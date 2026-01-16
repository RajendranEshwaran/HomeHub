//
//  SideMenuView.swift
//  HomeHub
//
//  Created by Rajendran Eshwaran on 1/16/26.
//

import SwiftUI

// MARK: - Menu Item Model

struct MenuItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let action: () -> Void
}

// MARK: - Default Side Menu

struct DefaultSideMenu: View {
    let isOpen: Bool
    let onClose: () -> Void
    let onEditProfile: () -> Void
    let onEditAction: () -> Void
    let onAddNewAction: () -> Void
    let onAddNewDevice: () -> Void
    let onSettings: () -> Void
    let onLogout: () -> Void

    var body: some View {
        SideMenuView(
            isOpen: isOpen,
            onClose: onClose,
            menuItems: [
                MenuItem(title: "Edit Profile", icon: "person.circle", action: onEditProfile),
                MenuItem(title: "Edit Action", icon: "slider.horizontal.3", action: onEditAction),
                MenuItem(title: "Add New Action", icon: "plus.circle", action: onAddNewAction),
                MenuItem(title: "Add New Device", icon: "plus.rectangle.on.rectangle", action: onAddNewDevice),
                MenuItem(title: "Settings", icon: "gearshape", action: onSettings),
                MenuItem(title: "Logout", icon: "rectangle.portrait.and.arrow.right", action: onLogout)
            ]
        ) {
            // Header with user info
            VStack(alignment: .leading, spacing: 12) {
                // Profile image
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.cyan, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 70, height: 70)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 30, weight: .medium))
                            .foregroundStyle(.white)
                            
                    )
                    .overlay(
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
                                lineWidth: 2
                            )
                    )
                    .shadow(color: .purple.opacity(0.3), radius: 10, x: 0, y: 5)
                    .padding(.leading, 70)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Welcome")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.black.opacity(0.5))
                       
                    Text("John Doe")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.black.opacity(0.8))
                }.padding(.leading, 70)
                .frame(alignment: .center)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color(red: 0.1, green: 0.1, blue: 0.15).ignoresSafeArea()

        DefaultSideMenu(
            isOpen: true,
            onClose: { print("Close") },
            onEditProfile: { print("Edit Profile") },
            onEditAction: { print("Edit Action") },
            onAddNewAction: { print("Add New Action") },
            onAddNewDevice: { print("Add New Device") },
            onSettings: { print("Settings") },
            onLogout: { print("Logout") }
        )
    }
}
