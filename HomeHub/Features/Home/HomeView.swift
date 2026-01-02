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
            VStack(spacing: 0) {
               
                //MARK: Navigation
                GenericNavigation(action: {}, navigationTitle: "Home View", isBackEnable: true, isForwardEnable: true, backgroundColor: .clear, foregroundColor: .text, leadingView: {
                    //MARK: leading button action

                    CollectionButton(action: {}, label: {
                        Image(systemName: "square.grid.2x2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15, height: 15)
                    }, bgColor: .indigo, clipShape: 30, radius: 6)
                    
                    
                }, trailingView: {
                    //MARK: trailing button action
                    
                    CollectionButton(action: {}, label: {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                    }, bgColor: .indigo, clipShape: 30, radius: 6)
                   
                }).frame(height: 50)
                
                //Spacer()
            }
        }.ignoresSafeArea(edges: .all)
    }
}


#Preview {
    HomeView()
        .environmentObject(Coordinator())
}
