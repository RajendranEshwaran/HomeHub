//
//  ProfileView.swift
//  HomeHub
//
//  Created by Rajendran Eshwaran on 1/16/26.
//

import SwiftUI
import Combine

struct ProfileView: View {
    
    var status: profileState { isEdit ? .save : .edit }
    
    @EnvironmentObject private var coordinator: Coordinator
    @State private var isEdit: Bool = false
    @State private var fullName: String = ""
    @State private var email: String = ""
    @StateObject private var authViewModel = AuthMVVM()
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            VStack{
                // Navigation Header
                GenericNavigation(
                    action: {},
                    navigationTitle: "Profile",
                    isBackEnable: true,
                    isForwardEnable: true,
                    backgroundColor: .clear,
                    foregroundColor: .text,
                    leadingView: {
                        TrailingNavigationBarItemButton(icon: "", action: {
                            coordinator.coordinatorPopToPreviousPage()
                        }, fontColor: .white)
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
                
                VStack(spacing: 16) {
                    
                    ProfilePictureView(
                        image: nil,
                        size: 120,
                        isEditable: isEdit,
                        onTap: {
                            // Handle profile picture change
                        }
                    )
                    
                    
                    EditableTextField(
                        placeholder: authViewModel.firstName,
                        text: $authViewModel.firstName,
                        isEditable: isEdit,
                        autocapitalization: .words,
                        bgColor: .purple
                    )
                    
                    EditableTextField(
                        placeholder: authViewModel.lastName,
                        text: $authViewModel.lastName,
                        isEditable: isEdit,
                        autocapitalization: .words,
                        bgColor: .purple
                    )

                    EditableTextField(
                        placeholder: authViewModel.email,
                        text: $email,
                        isEditable: isEdit,
                        keyboardType: .emailAddress,
                        bgColor: .purple
                    )

                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
            }
        }.environmentObject(coordinator)
        .navigationBarHidden(true)
    }
}

#Preview {
    ProfileView()
}
