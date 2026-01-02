//
//  HomeView.swift
//  HomeHub
//
//  Created by RajayGoms on 12/15/25.
//

import SwiftUI
import Combine

struct HomeView: View {
    var body: some View {
        ZStack {
            Color.background
            GenericNavigation(action: {}, navigationTitle: "", isBackEnable: false, backgroundColor: .clear, foregroundColor: .text, leadingView: {
                
            }, trailingView: {
                
            })
        }.ignoresSafeArea(edges: .all)
    }
}


#Preview {
    HomeView()
}
