//
//  Enums.swift
//  HomeHub
//
//  Created by Rajendran Eshwaran on 1/20/26.
//

enum profileState: String {
    case edit = "Edit"
    case save = "Save"
    var title: String { return self.rawValue }
}
