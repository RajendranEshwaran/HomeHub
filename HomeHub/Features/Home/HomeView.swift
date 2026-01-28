//
//  HomeView.swift
//  HomeHub
//
//  Created by Rajendran Eshwaran on 12/15/25.
//

import SwiftUI
import Combine

struct HomeView: View {
    @EnvironmentObject private var viewModel: HomeViewModel
    @EnvironmentObject private var coordinator: Coordinator
    @State private var isSideMenuOpen: Bool = false

    let coloms = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]

    var body: some View {
        ZStack {
            GlassyBackground()

//            Color.background
//                .ignoresSafeArea(edges: .all)
            VStack(spacing: 0) {

                //MARK: Navigation
                GenericNavigation(action: {}, navigationTitle: "Home View", isBackEnable: true, isForwardEnable: true, backgroundColor: .clear, foregroundColor: .white, leadingView: {
                    //MARK: leading button action - Open Side Menu

                    CollectionButton(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            isSideMenuOpen = true
                        }
                    }, label: {
                        Image(systemName: "square.grid.2x2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15, height: 15)
                    }, bgColor: .indigo, clipShape: 30, radius: 6, size: CGSize(width: 50, height: 50))


                }, trailingView: {
                    //MARK: trailing button action

                    CollectionButton(action: {
                        coordinator.coordinatorPushPage(page: .profileView)
                    }, label: {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                    }, bgColor: .indigo, clipShape: 30, radius: 6, size: CGSize(width: 50, height: 50))

                }).frame(height: 60)

                ScrollView {
                    VStack(spacing: 0) {
                        HStack(spacing: 15) {
                            //MARK: Wish Display
                            ForEach(viewModel.wishes) { wish in
                                CollectionButton(action: {}, label: {
                                    HStack {
                                        Image(systemName: wish.icon)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20, height: 20)

                                        Text(wish.greeting)
                                            .font(.headline)
                                    }
                                    .padding(.horizontal, 10)
                                }, bgColor: wish.bgColor, clipShape: 30, radius: 10, size: CGSize(width: 180, height: 55))
                            }
                        }
                        .padding(.top, 20)
                        Spacer()
                        HStack(spacing: 15) {
                            //MARK: Home Status Display
                            ForEach(viewModel.homeStatuses) { status in
                                CollectionButton(action: {}, label: {
                                    HStack {
                                        Image(systemName: status.icon)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20, height: 20)

                                        Text(status.status)
                                            .font(.headline)
                                    }
                                    .padding(.horizontal, 10)
                                }, bgColor: status.bgColor, clipShape: 30, radius: 10, size: CGSize(width: 180, height: 55))
                            }
                        }

                        // MARK: White line
                        Rectangle()
                            .fill(.white)
                            .frame(height: 6)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 20)

                        // MARK: Available Devices
                        HStack {
                            Text("Available Devices")
                                .font(.system(size: 18, weight: .bold, design: .default))
                                .padding(.leading, 20)
                                .foregroundStyle(.white)

                            ZStack {
                                Text("\(viewModel.availableDevices)")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                Circle()
                                    .fill(Color.black)
                                    .frame(width: 25, height: 25)
                                    .zIndex(-1)
                            }

                            Spacer()
                        }

                        // MARK: Device Cards
                        LazyVGrid(columns: coloms, spacing: 20) {
                            ForEach(viewModel.devices) { device in
                                DeviceCard(
                                    device: device,
                                    onToggle: { isOn in
                                        viewModel.toggleDevice(device: device, isOn: isOn)
                                    },
                                    onDelete: {
                                        viewModel.removeDevice(device: device)
                                    })
                                .onTapGesture {
                                    coordinator.coordinatorPushPage(page: .deviceDetailView(device: device))
                                }
                            }
                        }
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                }
            }

            // MARK: Plus button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    CollectionButton(action: {
                        coordinator.coordinatorPushPage(page: .addDeviceView)
                    }, label: {
                        HStack {
                            Image(systemName: "plus")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                        }
                        .padding(.horizontal, 10)
                    }, bgColor: .buttonPlus, clipShape: 30, radius: 7, size: CGSize(width: 60, height: 60))
                    Spacer()
                }
                .padding(.bottom, 20)
            }

            // MARK: Side Menu
            DefaultSideMenu(
                isOpen: isSideMenuOpen,
                onClose: {
                    isSideMenuOpen = false
                },
                onEditProfile: {
                    isSideMenuOpen = false
                    coordinator.coordinatorPushPage(page: .profileView)
                },
                onEditAction: {
                    isSideMenuOpen = false
                    coordinator.coordinatorPushPage(page: .editActionView)
                },
                onAddNewAction: {
                    isSideMenuOpen = false
                    coordinator.coordinatorPushPage(page: .addActionView)
                },
                onAddNewDevice: {
                    isSideMenuOpen = false
                    coordinator.coordinatorPushPage(page: .addDeviceView)
                },
                onSettings: {
                    isSideMenuOpen = false
                    coordinator.coordinatorPushPage(page: .settingView)
                },
                onLogout: {
                    isSideMenuOpen = false
                    coordinator.coordinatorRootToTop()
                }
            )
        }
        .environmentObject(coordinator)
        .environmentObject(viewModel)
        .navigationBarHidden(true)
    }
}


#Preview {
    HomeView()
        .environmentObject(Coordinator())
        .environmentObject(HomeViewModel())
}
