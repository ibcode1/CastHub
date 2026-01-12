//
//  PodacastDetailViewModel.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 23/12/2025.
//

import Foundation
import SwiftData

@MainActor
@Observable
final class PodcastDetailViewModel {
    var episodes: [EpisodeEntity] = []
    var isLoading = false
    var errorMessage: String?

    private let rssUseCase: RssFeedUseCase
    private let savedPodcast: PodcastPersistenceModel?
    private let context: ModelContext

    init(
        rssUseCase: RssFeedUseCase,
        context: ModelContext,
        savedPodcast: PodcastPersistenceModel?) {
            self.rssUseCase = rssUseCase
            self.context = context
            self.savedPodcast = savedPodcast }

    func loadEpisodeFromFeed(feedURL: String) async {
        // guard isLoading == false else { return }

        isLoading = true
        do {
            let results = try await rssUseCase.execute(feedURL: feedURL)
            episodes = results
            print("Fetched episodes:", results.count)

            if let podcast = savedPodcast {
                savedPodcastsEpisodes(results, for: podcast)
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    private func savedPodcastsEpisodes(_ episodes: [EpisodeEntity], for podcast: PodcastPersistenceModel) {
        for episode in episodes {
            let model = EpisodePersistenceModel(
                title: episode.title ?? "",
                pubDate: episode.pubDate,
                content: episode.episodeContent,
                imageUrl: episode.imageUrl,
                itunesDuration: episode.itunesDuration ?? TimeInterval(),
                audioUrl: episode.audio ?? "",
                type: episode.type ?? "")

            model.podcast = podcast
            podcast.episodes.append(model)
            context.insert(model)
            print("Saving episode:", episode.title ?? "", episode.audio ?? "", episode.type ?? "")
        }
        try? context.save()
        
    }
}
