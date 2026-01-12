//
//  EpisodeRowView.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 23/12/2025.
//

import Foundation
import SwiftUI

@MainActor
@Observable
final class EpisodeRowViewModel {
    var episodeContent = ""
    var error: Error?

    private(set) var episode: EpisodeEntity

    init(episode: EpisodeEntity) {
        self.episode = episode
    }

    func loadEpisodeContent() async {
        episodeContent = await episode.episodeContent.htmlStripped()
    }
}

struct EpisodeRowView: View {
    @State private var viewModel: EpisodeRowViewModel
    init(episode: EpisodeEntity) {
        _viewModel = State(initialValue: EpisodeRowViewModel(episode: episode))
    }
    var body: some View {
        StandardCellView(
            title: viewModel.episode.episodeTitle,
            subtitle: viewModel.episodeContent,
            length: viewModel.episode.duration,
            date: viewModel.episode.episodePublicationDate,
            imageURL: viewModel.episode.image
            )
        .task {
            await viewModel.loadEpisodeContent()
        }
    }
}
