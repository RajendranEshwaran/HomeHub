//
//  AddDeviceView.swift
//  HomeHub
//
//  Created by Rajendran Eshwaran on 1/5/26.
//

import SwiftUI
import Combine

struct AddDeviceView: View {
    @EnvironmentObject var coordinator: Coordinator
    @EnvironmentObject var viewModel: HomeViewModel

    @State private var deviceName: String = ""
    @State private var deviceStatus: String = ""
    @State private var iconLeft: String = "lightbulb.fill"
    @State private var iconRight: String = "wifi"
    @State private var selectedColor: Color = .orange

    let availableColors: [Color] = [.orange, .blue, .purple, .green, .red, .yellow, .pink, .indigo]
    let availableIcons: [String] = [
        "lightbulb.fill", "tv.fill", "snowflake", "hifispeaker.fill",
        "fan.fill", "lamp.desk.fill", "camera.fill", "lock.fill",
        "wifi", "antenna.radiowaves.left.and.right", "bolt.fill", "wind"
    ]

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea(edges: .all)

            VStack(spacing: 0) {
                //MARK: Navigation
                GenericNavigation(
                    action: {
                        coordinator.coordinatorPopToPreviousPage()
                    },
                    navigationTitle: "Add Device",
                    isBackEnable: true,
                    isForwardEnable: false,
                    backgroundColor: .clear,
                    foregroundColor: .text,
                    leadingView: {
                        Button(action: {
                            coordinator.coordinatorPopToPreviousPage()
                        }, label: {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.black)
                                .aspectRatio(contentMode: .fit)
                        })
                    },
                    trailingView: {}
                )
                .frame(height: 60)

                ScrollView {
                    VStack(spacing: 25) {
                        //MARK: Device Name
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Device Name")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.black)

                            TextField("Enter device name", text: $deviceName)
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .foregroundStyle(.black)
                        }
                        .padding(.horizontal, 20)

                        //MARK: Device Status
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Device Status")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.black)

                            TextField("Enter device status", text: $deviceStatus)
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .foregroundStyle(.black)
                        }
                        .padding(.horizontal, 20)

                        //MARK: Icon Selection
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Left Icon")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.black)
                                .padding()
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(availableIcons, id: \.self) { icon in
                                        Button(action: {
                                            iconLeft = icon
                                        }) {
                                            Image(systemName: icon)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 30, height: 30)
                                                .foregroundStyle(iconLeft == icon ? .black : .black.opacity(0.5))
                                                .padding()
                                                .background(iconLeft == icon ? Color.white.opacity(0.2) : Color.white.opacity(0.05))
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }

                        VStack(alignment: .leading, spacing: 10) {
                            Text("Right Icon")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.black)
                                .padding(.horizontal, 20)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(availableIcons.reversed(), id: \.self) { icon in
                                        Button(action: {
                                            iconRight = icon
                                        }) {
                                            Image(systemName: icon)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 30, height: 30)
                                                .foregroundStyle(iconRight == icon ? .black : .black.opacity(0.5))
                                                .padding()
                                                .background(iconRight == icon ? Color.white.opacity(0.2) : Color.white.opacity(0.05))
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }

                        //MARK: Color Selection
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Device Color")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.black)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(availableColors, id: \.self) { color in
                                        Button(action: {
                                            selectedColor = color
                                        }) {
                                            Circle()
                                                .fill(color)
                                                .frame(width: 50, height: 50)
                                                .overlay(
                                                    Circle()
                                                        .stroke(Color.white, lineWidth: selectedColor == color ? 3 : 0)
                                                )
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }

                        //MARK: Preview
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Preview")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.black)
                                .padding(.horizontal, 20)

                            HStack {
                                Spacer()
                                DeviceCard(
                                    device: Device(
                                        deviceName: deviceName.isEmpty ? "Device Name" : deviceName,
                                        deviceStatus: deviceStatus.isEmpty ? "Status" : deviceStatus,
                                        iconLeft: iconLeft,
                                        iconRight: iconRight,
                                        bgColor: selectedColor,
                                        isOn: false
                                    ),
                                    onToggle: { _ in },
                                    onEdit: {}
                                )
                                Spacer()
                            }
                        }
                        .padding(.top, 20)

                        //MARK: Add Button
                        CollectionButton(
                            action: {
                                if !deviceName.isEmpty && !deviceStatus.isEmpty {
                                    viewModel.addDevice(
                                        deviceName: deviceName,
                                        deviceStatus: deviceStatus,
                                        iconLeft: iconLeft,
                                        iconRight: iconRight,
                                        bgColor: selectedColor
                                    )
                                    coordinator.coordinatorPopToPreviousPage()
                                }
                            },
                            label: {
                                Text("Add Device")
                                    .font(.system(size: 18, weight: .bold))
                            },
                            bgColor: .green,
                            clipShape: 15,
                            radius: 8,
                            size: CGSize(width: 200, height: 55)
                        )
                        .padding(.top, 30)
                        .padding(.bottom, 50)
                    }
                    .padding(.top, 20)
                }
            }
        }
        .navigationBarHidden(true)
    }
}
