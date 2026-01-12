//
//  EmptyStateView.swift
//  PodcastHub
//
//  Created by Ibrahim fuseini on 02/09/2024.
//

import SwiftUI

struct EmptyStateView: View {

    let title: String
    let description: String
    let icon: String
    var yOffset: CGFloat = 0

    var body: some View {
        ContentUnavailableView {
            Label(title, systemImage: icon)
        } description: {
            Text(description)
        } actions: {
        }
        .offset(y: yOffset)
    }
}

#Preview {
    EmptyStateView(title: "TITLE", description: "DESCRIPTION", icon: "questionmark.diamond")
}
