//
//  PodcastEpisodeRowView.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 24/12/2025.
//

import SwiftUI

struct PodcastEpisodeRowView: View {
    let podcast: PodcastEntity
    var body: some View {
        PodcastEpisodeCellView(podcast: podcast)
    }
}
