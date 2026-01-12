//
//  PersistenceRepositoryImpl.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 30/12/2025.
//

import SwiftUI
import SwiftData
import IbToolKit


struct SubcribedListView: View {

    @Environment(\.modelContext) private var context
    @Environment(\.rssUseCase) private var rssUseCase

    // SwiftData fetch — reactive, updates automatically
    @Query(sort: \PodcastPersistenceModel.title)
    private var podcasts: [PodcastPersistenceModel]

    // ViewModel — handles use cases only
    @State private var viewModel: SubscribedViewModel
    init(viewModel: SubscribedViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(podcasts) { podcast in
                    NavigationLink {
                        PodcastDetailViewFromSavedData(
                            podcast: podcast,
                            rssUseCase: rssUseCase,
                            context: context)
                    } label: {
                        PodcastRow(podcast: podcast)
                        {
                            Task { await viewModel.deletePodcast(podcast) }
                        }
                    }
                }
            }
            .navigationTitle("Saved Podcasts")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Wipe") {
                        Task { await viewModel.wipeDatabase() }
                    }
                }
            }
        }
    }
}

struct PodcastDetailViewFromSavedData: View {
    @State var podcast: PodcastPersistenceModel

    @Environment(\.modelContext) private var context
    @Environment(\.rssUseCase) private var rssUseCase
    @Environment(PlayerViewModel.self) private var playerViewModel

    @State private var viewModel: PodcastDetailViewModel

    init(podcast: PodcastPersistenceModel,rssUseCase: RssFeedUseCase, context: ModelContext) {
        self.podcast = podcast
        print("DEBUG type:", type(of: rssUseCase))
        _viewModel = State(initialValue:
                            PodcastDetailViewModel(
                                rssUseCase: rssUseCase,
                                context: context,
                                savedPodcast: podcast
                            )
        )
    }

    var body: some View {
        ScrollView {
            VStack {
                // Artwork
                AsyncImage(url: URL(string: podcast.artworkUrl ?? "")) { image in
                    image
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 390, height: 320)
                        .clipped()
                } placeholder: {
                    Color(.systemGroupedBackground)
                    ProgressView()
                }

                // Title
                VStack(alignment: .center, spacing: 4.0) {
                    Text(podcast.title)
                        .ibFont(.h5Bold)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .minimumScaleFactor(0.6)
                }
                Divider()

                HStack {
                    Text("\(podcast.episodes.count) Episodes")
                        .ibFont(.h5Bold)
                }

                // Episodes
                if podcast.episodes.isEmpty && viewModel.episodes.isEmpty {
                    Text("No episodes available")
                        .foregroundStyle(.secondary)
                } else {
                    VStack(alignment: .leading, spacing: 12) {

                        // Persisted episodes first
                        ForEach(podcast.episodes) { episode in
                            Button {
                                playerViewModel.selectedEpisode = episode.toDomain()
                                playerViewModel.allEpisodes = podcast.episodes.map({ $0.toDomain()})
                            } label: {
                                EpisodeRowView(episode: episode.toDomain())
                            }
                            .buttonStyle(.plain)
                        }
                        // If new episodes were fetched but not yet persisted
                        ForEach(viewModel.episodes, id: \.id) { episode in
                            EpisodeRowView(episode: episode)
                        }
                    }
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle(podcast.title)
        .navigationBarTitleDisplayMode(.inline)
        .overlay(loadingOverlay)
        .task {
            await loadEpisodesIfNeeded()
        }
    }
}

private extension PodcastDetailViewFromSavedData {

    @ViewBuilder
    var loadingOverlay: some View {
        if viewModel.isLoading {
            ProgressView()
        }
    }

    /// Load episodes only if needed
    func loadEpisodesIfNeeded() async {
        // If episodes already persisted → no need to fetch
        if !podcast.episodes.isEmpty { return }
        print("Persisted episodes:", podcast.episodes.count)

        // Otherwise fetch from RSS and persist
        await viewModel.loadEpisodeFromFeed(feedURL: podcast.feedUrl)
    }
}
