//
//  SettingView.swift
//  HomeHub
//
//  Created by Rajendran Eshwaran on 1/20/26.
//

import SwiftUI
import Combine

struct SettingView: View {
    @EnvironmentObject private var coordinator: Coordinator
    var status: profileState { isEdit ? .save : .edit }
    @State private var isEdit: Bool = false
    @State private var householdMembers: [InvitePerson] = [
        InvitePerson(name: "Rajay", email: "rajay@example.com")
    ]
    @State private var showAddPersonSheet: Bool = false
    @StateObject private var authViewModel = AuthMVVM()
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            VStack{
                // Navigation Header
                GenericNavigation(
                    action: {},
                    navigationTitle: "Setting",
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
                    placeholder: "My Home",
                    text: $authViewModel.firstName,
                    isEditable: isEdit,
                    autocapitalization: .words,
                    bgColor: .white
                ).padding(20)
                
                InviteCard(
                    title: "Household Members",
                    people: $householdMembers,
                    onAddTap: {
                        showAddPersonSheet = true
                    },
                    onPersonTap: { person in
                        // Handle person tap
                    },
                    onRemove: { person in
                        householdMembers.removeAll { $0.id == person.id }
                    },
                    isEditable: isEdit
                )
                .padding(.horizontal, 16)

            
                
                SectionView(title: "Notes") {
                    EditableTextField(
                        placeholder: "Add notes here...",
                        text: $authViewModel.firstName,
                        isEditable: isEdit,
                        autocapitalization: .sentences,
                        bgColor: .white,
                        height: 200
                    )
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
               
                Spacer()
                
                CollectionButton(action: {
                    // remove action
                }, label: {
                    HStack {
                        Text("Remove Setting")
                            .foregroundStyle(.red)
                    }
                    .padding(.horizontal, 10)
                }, bgColor: .white, clipShape: 30, radius: 7, size: CGSize(width: 300, height: 60))
                
                  
            }
            .environmentObject(coordinator)
            .navigationBarHidden(true)
        }
    }
}
