//
//  GenericNavigation.swift
//  HomeHub
//
//  Created by RajayGoms on 12/22/25.
//

import SwiftUI
import Foundation
import Combine

struct GenericNavigation<leadingView: View, trailingView: View> : View {
    let action:() -> Void
    var navigationTitle: String
    var isBackEnable: Bool = false
    let backgroundColor: Color
    let foregroundColor: Color
    var leading: leadingView
    var trailing: trailingView
    
    
    init(action: @escaping () -> Void, navigationTitle: String, isBackEnable: Bool, backgroundColor: Color, foregroundColor: Color, @ViewBuilder leadingView: () -> leadingView, @ViewBuilder trailingView: () -> trailingView) {
        self.action = action
        self.navigationTitle = navigationTitle
        self.isBackEnable = isBackEnable
        self.leading = leadingView()
        self.trailing = trailingView()
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
    }
    
    
    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea(edges: .top)
                HStack {
                    leading
                        .frame(width: 44, height: 44)
                    
                    Spacer()
                    
                    Text(navigationTitle)
                        .font(.headline)
                        .foregroundColor(foregroundColor)
                    
                    Spacer()
                    
                    trailing
                        .frame(width: 44, height: 44)
                }
                    .padding(.horizontal)
        }
    }
}
