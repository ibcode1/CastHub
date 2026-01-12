//
//  SearchRowView.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 22/12/2025.
//

import SwiftUI

struct SearchRowView: View {
    var podcast: PodcastEntity

    var body: some View {
        StandardCellView(
            title: podcast.censorName,
            date: podcast.podcastDate,
            imageURL: podcast.image
        )
    }
}

// TODO: - Add new example for Podcast model
#Preview {
    SearchRowView(podcast: PodcastEntity.example)
}
