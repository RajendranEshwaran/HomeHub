//
//  EditActionView.swift
//  HomeHub
//
//  Created by Rajendran Eshwaran on 1/12/26.
//


import SwiftUI
import Combine

struct EditActionView: View {
    @EnvironmentObject private var coordinator: Coordinator
    var status: profileState { isEdit ? .save : .edit }
    @State private var isEdit: Bool = false
    @State private var householdMembers: [InvitePerson] = [
        InvitePerson(name: "Rajay", email: "rajay@example.com")
    ]
  
    @StateObject private var authViewModel = AuthMVVM()
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            VStack{
                // Navigation Header
                GenericNavigation(
                    action: {},
                    navigationTitle: "Edit Action",
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
                            
                        }, label: {
                            Image(systemName: "plus")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 18, height: 18)
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
                ).padding(20)
                
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
