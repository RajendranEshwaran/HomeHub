//
//  BackButton.swift
//  HomeHub
//
//  Created by Rajendran Eshwaran on 1/12/26.
//

import SwiftUI
import Combine

struct TrailingNavigationBarItemButton: View {
    let icon: String?
    let action: () -> Void
    let fontColor: Color?
    var body: some View {
        VStack{
            Button(action: action, label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(fontColor)
                    .aspectRatio(contentMode: .fit)
            })
        }
    }
}


struct LeadingNavigationBarItemButton: View {
    let icon: String?
    let action: () -> Void
    let fontColor: Color?
    var body: some View {
        VStack{
            Button(action: action, label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(fontColor)
                    .aspectRatio(contentMode: .fit)
            })
        }
    }
}
