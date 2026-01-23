//
//  AddActionView.swift
//  HomeHub
//
//  Created by RajayGoms on 1/20/26.
//

import SwiftUI
import Combine

struct AddActionView: View {
    @EnvironmentObject private var coordinator: Coordinator
    var status: profileState { isEdit ? .save : .edit }
    @State private var isEdit: Bool = false
    @State private var householdMembers: [InvitePerson] = [
        InvitePerson(name: "Rajay", email: "rajay@example.com")
    ]
  
    @StateObject private var authViewModel = AuthMVVM()
    @State private var selectedColor: Color = .orange
    @State private var selectedActionId: UUID?
    let availableColors: [Color] = [.orange, .blue, .purple, .green, .red, .yellow, .pink, .indigo]
    @State private var isOn: Bool = false
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            VStack{
                // Navigation Header
                GenericNavigation(
                    action: {},
                    navigationTitle: "Add New Action",
                    isBackEnable: true,
                    isForwardEnable: true,
                    backgroundColor: .clear,
                    foregroundColor: .text,
                    leadingView: {
                        TrailingNavigationBarItemButton(icon: "", action: {
                            coordinator.coordinatorPopToPreviousPage()
                        })
                    },
                    trailingView: {
                        Button(action: {
                            isEdit.toggle()
                        }, label: {
                            Text(status.title)
                                .foregroundColor(.black)
                        })
                    }
                )
                .frame(height: 60)
                
                EditableTextField(
                    placeholder: "Enter Action Name",
                    text: $authViewModel.firstName,
                    isEditable: isEdit,
                    autocapitalization: .words,
                    bgColor: .white
                )
                .padding(.horizontal, 20)

                SectionView(title: "Select Action Color") {
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(availableColors, id: \.self) { color in

                                ActionColorButton(color: color, isSelected: false, onTap: {
                                    selectedColor = color
                                })
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)

                SectionView(title: "Action Devices", content: {
                    
                    VStack{
                        Text("You can turn ON or OFF any devices so you can access all devices in a one click ")
                            .foregroundStyle(.gray)
                            .font(.system(size: 12))
                            .padding(12)
                        
                        ActionDeviceCard(deviceName: "test", roomName: "test", isOn: $isOn)
                    }
                })
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                Spacer()
                
        
            }
            .environmentObject(coordinator)
            .navigationBarHidden(true)
        }
    }
}
