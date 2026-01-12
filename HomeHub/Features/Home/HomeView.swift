//
//  HomeView.swift
//  HomeHub
//
//  Created by Rajendran Eshwaran on 12/15/25.
//

import SwiftUI
import Combine

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject private var coordinator: Coordinator
    let rows = [
            GridItem(.flexible(), spacing: 200),
            GridItem(.flexible(), spacing: 200)
        ]
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea(edges: .all)

            VStack(spacing: 0) {

                //MARK: Navigation
                GenericNavigation(action: {}, navigationTitle: "Home View", isBackEnable: true, isForwardEnable: true, backgroundColor: .clear, foregroundColor: .text, leadingView: {
                    //MARK: leading button action

                    CollectionButton(action: {}, label: {
                        Image(systemName: "square.grid.2x2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15, height: 15)
                    }, bgColor: .indigo, clipShape: 30, radius: 6, size: CGSize(width: 50, height: 50))


                }, trailingView: {
                    //MARK: trailing button action

                    CollectionButton(action: {}, label: {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                    }, bgColor: .indigo, clipShape: 30, radius: 6, size: CGSize(width: 50, height: 50))

                }).frame(height: 60)

                ScrollView {
                    GeometryReader { geometry in
                        VStack {
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
                                .frame(width: geometry.size.width, height: 6)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 20)
                            
                            // MARK: Available Devices
                            HStack {
                                Text("Available Devices")
                                    .font(.system(size: 18, weight: .bold, design: .default))
                                    .padding(.leading, 20)

                                ZStack() {
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

                            // MARK: Rooms Names
                            HStack {
                                Text("First room")
                                    .font(.system(size: 15, weight: .regular, design: .default))
                                    .foregroundStyle(.gray)
                                    .padding(.leading, 20)

                                Spacer()
                            }
                            .padding(.top, 10)

                            // MARK: Device Cards
                            LazyHGrid(rows: rows, spacing: 50) {
                                ForEach(viewModel.devices) { device in
                                    DeviceCard(
                                        device: device,
                                        onToggle: { isOn in
                                            viewModel.toggleDevice(device: device, isOn: isOn)
                                        },
                                        onEdit: {
                                            // Handle edit action
                                           
                                        })
                                    .onTapGesture {
                                        coordinator.coordinatorPushPage(page: .deviceDetailView(device: device))
                                    }
                                }
                            }
                            .padding(.top, 55)
                            .padding(.horizontal, 20)
                        
                        }
                        .padding(.top, 20)
                        .frame(width: geometry.size.width)
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
        }
        .environmentObject(coordinator)
        .environmentObject(viewModel)
        .navigationBarHidden(true)
    }
}


#Preview {
    HomeView()
        .environmentObject(Coordinator())
}
