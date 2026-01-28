//
//  SectionView.swift
//  HomeHub
//
//  Created by Rajendran Eshwaran on 1/20/26.
//

import SwiftUI

struct SectionView<Content: View>: View {
    let title: String
    let content: Content
    var headerAlignment: HorizontalAlignment = .leading
    var spacing: CGFloat = 12

    init(
        title: String,
        headerAlignment: HorizontalAlignment = .leading,
        spacing: CGFloat = 12,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.headerAlignment = headerAlignment
        self.spacing = spacing
        self.content = content()
    }

    var body: some View {
        VStack(alignment: headerAlignment, spacing: spacing) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)

            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()

        VStack(spacing: 24) {
            SectionView(title: "Notes") {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.white.opacity(0.2))
                    .frame(height: 60)
            }

            SectionView(title: "Settings", spacing: 16) {
                VStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.white.opacity(0.2))
                        .frame(height: 50)
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.white.opacity(0.2))
                        .frame(height: 50)
                }
            }
        }
        .padding()
    }
}
