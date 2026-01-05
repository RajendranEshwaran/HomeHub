//
//  HomeView.swift
//  HomeHub
//
//  Created by RajayGoms on 12/15/25.
//

import SwiftUI
import Combine

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea(edges: .all)

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

                Spacer()

                ScrollView {
                    HStack(spacing: 15) {
                        //MARK: Wish Display
                        ForEach(viewModel.wishes) { wish in
                            CollectionButton(action: {}, label: {
                                HStack {
                                    Image(systemName: wish.icon)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 20)

                                    Text(wish.greeting)
                                        .font(.headline)
                                }
                                .padding(.horizontal, 10)
                            }, bgColor: wish.bgColor, clipShape: 30, radius: 10, size: CGSize(width: 200, height: 50))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
    }
}


#Preview {
    HomeView()
        .environmentObject(Coordinator())
}
