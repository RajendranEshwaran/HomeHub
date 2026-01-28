//
//  GenericNavigation.swift
//  HomeHub
//
//  Created by Rajendran Eshwaran on 12/22/25.
//

import SwiftUI
import Foundation
import Combine

struct GenericNavigation<leadingView: View, trailingView: View> : View {
    let action:() -> Void
    var navigationTitle: String
    var isBackEnable: Bool = false
    var isForwardEnable: Bool = false
    let backgroundColor: Color
    let foregroundColor: Color
    var leading: leadingView
    var trailing: trailingView
    
    
    init(action: @escaping () -> Void, navigationTitle: String, isBackEnable: Bool, isForwardEnable: Bool, backgroundColor: Color, foregroundColor: Color, @ViewBuilder leadingView: () -> leadingView, @ViewBuilder trailingView: () -> trailingView) {
        self.action = action
        self.navigationTitle = navigationTitle
        self.isBackEnable = isBackEnable
        self.isForwardEnable = isForwardEnable
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
                     
                    if isBackEnable {
                        leading
                            .frame(width: 44, height: 44)
                        
                    }
                    Spacer()
                    Text(navigationTitle)
                        .font(.headline)
                        .foregroundColor(foregroundColor)
                        .frame(alignment: .center)
                    
                    Spacer()
                    if isForwardEnable {
                        trailing
                            .frame(width: 44, height: 44)
                    }
                }
                    .padding(.horizontal)
        }
    }
}
