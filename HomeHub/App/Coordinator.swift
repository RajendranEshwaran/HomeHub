//
//  Coordinator.swift
//  HomeHub
//
//  Created by Rajendran EShwaran on 12/16/25.
//

import Foundation
import SwiftUI
import Combine

enum AppPages: Hashable {
    case login
    case signup
    case forgot
    case verification
    case homeView
}

enum AppSheets: String, Identifiable {
    case sheet1
    var id: String { return self.rawValue }
}

enum AppFullCover: String, Identifiable {
    case fullcover1
    var id: String { return self.rawValue }
}

class Coordinator: ObservableObject {
    @Published var currentPage: AppPages?
    @Published var currentSheet: AppSheets?
    @Published var currentFullCover: AppFullCover?
    @Published var navigationPath = NavigationPath()
    @Published var rootPage: AppPages = .login
    
    func coordinatorPresentPage(page: AppPages) { navigationPath.append(page) }
    
    func coordinatorPushPage(page: AppPages) { navigationPath.append(page) }
    
    func coordinatorPresentSheet(sheet: AppSheets) { navigationPath.append(sheet) }
    
    func coordinatorPresentFullCover(cover: AppFullCover) { self.currentFullCover = cover }
    
    func coodinatorDismissPage() { navigationPath.removeLast() }
    
    func coordinatorPopToPreviousPage() { navigationPath.removeLast() }
    
    func coordinatorDissmissFullCover() { self.currentFullCover = nil }
    
    func coordinatorDissmissSheet() { self.currentSheet = nil }
    
    func coordinatorRootToTop() { navigationPath.removeLast( navigationPath.count )}
    
    func coordinatorSetRootPage(root: AppPages) {
        self.rootPage = root
        self.navigationPath.removeLast(navigationPath.count)
    }
    
    @ViewBuilder
    func currentPageView(view: AppPages) -> some View {
        switch view {
        case .login: AuthView()
        case .signup: EmptyView()
        case .forgot: EmptyView()
        case .verification: EmptyView()
        case .homeView: HomeView()
        }
    }
    
    @ViewBuilder
    func currentSheetView(sheet: AppSheets)-> some View {
        switch sheet {
        case .sheet1: EmptyView()
        }
    }
    
    @ViewBuilder
    func currentFullCoverView(cover: AppFullCover)-> some View {
        switch cover {
        case .fullcover1: EmptyView()
        }
    }
}
