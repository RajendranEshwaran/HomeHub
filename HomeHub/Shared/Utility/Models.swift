//
//  Models.swift
//  HomeHub
//
//  Created by RajayGoms on 1/20/26.
//
import SwiftUI

struct InvitePerson: Identifiable {
    let id: UUID
    var name: String
    var email: String
    var image: Image?

    init(id: UUID = UUID(), name: String, email: String, image: Image? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.image = image
    }
}
