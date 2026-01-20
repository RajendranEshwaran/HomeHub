//
//  EditableTextField.swift
//  HomeHub
//
//  Created by RajayGoms on 1/20/26.
//

import SwiftUI
import UIKit

struct EditableTextField: View {
    let placeholder: String
    @Binding var text: String
    var isEditable: Bool = true
    var keyboardType: UIKeyboardType = .default
    var isLoading: Bool = false
    var autocapitalization: TextInputAutocapitalization = .never

    var body: some View {
        Group {
            if isEditable {
                TextField(placeholder, text: $text)
                    .textInputAutocapitalization(autocapitalization)
                    .keyboardType(keyboardType)
                    .disabled(isLoading)
            } else {
                HStack {
                    Text(text.isEmpty ? placeholder : text)
                        .foregroundColor(text.isEmpty ? .gray.opacity(0.6) : .primary)
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 12)
        .frame(height: 60)
        .background {
            glassyBackground
        }
        .animation(.easeInOut(duration: 0.3), value: isEditable)
    }

    private var glassyBackground: some View {
        RoundedRectangle(cornerRadius: 14)
            .fill(
                LinearGradient(
                    colors: [
                        Color.purple.opacity(isEditable ? 0.3 : 0.15),
                        Color.purple.opacity(isEditable ? 0.3 : 0.15)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(isEditable ? 0.5 : 0.3),
                                Color.white.opacity(0.0)
                            ],
                            startPoint: .top,
                            endPoint: .center
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(isEditable ? 0.8 : 0.5),
                                Color.white.opacity(isEditable ? 0.3 : 0.15)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: isEditable ? 1 : 0.5
                    )
            )
            .shadow(
                color: .black.opacity(isEditable ? 0.08 : 0.03),
                radius: isEditable ? 8 : 4,
                x: 0,
                y: isEditable ? 4 : 2
            )
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        VStack(spacing: 20) {
            EditableTextField(
                placeholder: "Editable Field",
                text: .constant("Hello World"),
                isEditable: true
            )

            EditableTextField(
                placeholder: "Non-Editable Field",
                text: .constant("Read Only Text"),
                isEditable: false
            )

            EditableTextField(
                placeholder: "Empty Placeholder",
                text: .constant(""),
                isEditable: false
            )
        }
        .padding()
    }
}
