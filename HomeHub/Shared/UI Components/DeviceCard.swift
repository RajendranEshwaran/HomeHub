//
//  DeviceCard.swift
//  HomeHub
//
//  Created by Rajendran Eshwaran on 1/5/26.
//

import SwiftUI
import Combine
import Foundation

struct DeviceCard: View {
    let device: Device
    let onToggle: (Bool) -> Void
    let onDelete: () -> Void

    var body: some View {
        VStack(spacing: 15) {
            //MARK: Top Section - Icons and Edit Button
            HStack {
                Image(systemName: device.iconLeft)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.white)

                Image(systemName: device.iconRight)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.white)

                Spacer()

                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.white)
                }
            }
            .padding(.horizontal, 15)
            .padding(.top, 15)

            //MARK: Center Section - Device Name and Status
            VStack(alignment: .leading, spacing: 5) {
                Text(device.deviceName)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)

                Text(device.deviceStatus)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(.white.opacity(0.7))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 15)

            Spacer()

            //MARK: Bottom Section - On/Off Switches
            HStack(spacing: 10) {
                Button(action: {
                    onToggle(true)
                }) {
                    Text("ON")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(device.isOn ? .white : .white.opacity(0.5))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(device.isOn ? Color.white.opacity(0.3) : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }

                Button(action: {
                    onToggle(false)
                }) {
                    Text("OFF")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(!device.isOn ? .white : .white.opacity(0.5))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(!device.isOn ? Color.white.opacity(0.3) : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .padding(.horizontal, 15)
            .padding(.bottom, 15)
        }
        .frame(width: 150, height: 180)
        .background {
            ZStack {
                MeshGradient(width: 3, height: 3, points: [
                    [0, 0], [0.5, 0], [1, 0],
                    [0, 0.5], [0.5, 0.5], [1, 0.5],
                    [0, 1], [0.5, 1], [1, 1]
                ],
                    colors: [
                        device.bgColor.opacity(1.0), device.bgColor.opacity(1.0), device.bgColor.opacity(1.0),
                        device.bgColor.opacity(1.0), device.bgColor.opacity(1.0), device.bgColor.opacity(1.0),
                        device.bgColor.opacity(1.0), device.bgColor.opacity(1.0), device.bgColor.opacity(1.0)
                    ]
                )
                .blur(radius: 10)

                LinearGradient(
                    gradient: Gradient(colors: [
                        .white.opacity(0.4),
                        .white.opacity(0.2),
                        .white.opacity(0.1)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            .white.opacity(0.2),
                            .white.opacity(0.2)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: device.bgColor.opacity(0.3), radius: 10, x: 0, y: 5)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 10)
    }
}

