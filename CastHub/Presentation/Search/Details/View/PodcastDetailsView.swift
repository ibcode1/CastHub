//
//  PodcastDetailsView.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 23/12/2025.
//

import SwiftUI
import IbFoundation
import SwiftData

struct PodcastDetailsView: View {
    @State private var viewModel: PodcastDetailViewModel
    @Environment(PlayerViewModel.self) private var playerViewModel
    let podcast: PodcastEntity

    init(
        podcast: PodcastEntity,
        rssUseCase: RssFeedUseCase,
        context: ModelContext,
        savedPodcast: PodcastPersistenceModel? = nil) {
            self.podcast = podcast
            _viewModel = State(initialValue: PodcastDetailViewModel(
                rssUseCase: rssUseCase,
                context: context,
                savedPodcast: savedPodcast))
        }
    var body: some View {
        ScrollView {
            LazyVStack {
                HStack {
                    PodcastEpisodeRowView(podcast: podcast)
                }
                Divider()
                ForEach(viewModel.episodes, id: \.id) { episode in
                    Button {
                        playerViewModel.selectedEpisode = episode
                        playerViewModel.allEpisodes = viewModel.episodes
                    } label: {
                        EpisodeRowView(episode: episode)
                    }
                    .buttonStyle(.plain)

                }
            }
        }
        .navigationTitle(podcast.censorName)
        .navigationBarTitleDisplayMode(.inline)
        .overlay { emptyStateLoadingView }
        .overlay(loadingOverlayView)
        .task {
            await viewModel.loadEpisodeFromFeed(feedURL: podcast.podcastFeedUrl)
        }
    }
}

private extension PodcastDetailsView {

    @ViewBuilder
    var emptyStateLoadingView: some View {
        if viewModel.episodes.isEmpty && !viewModel.isLoading {
            EmptyStateView(
                title: "Podcast not found",
                description: "No result found",
                icon: "questionmark.diamond",
                yOffset: -88
            )
        }
    }

    @ViewBuilder
    var loadingOverlayView: some View {
        if viewModel.isLoading {
            ProgressView()
        }
    }

    func loadEpisodesIfNeeded() async {
        // If episodes already loaded (from SwiftData or memory), skip
        if !viewModel.episodes.isEmpty { return }

        // Otherwise fetch from RSS (and persist if savedPodcast != nil)
        await viewModel.loadEpisodeFromFeed(feedURL: podcast.podcastFeedUrl)
    }
}
