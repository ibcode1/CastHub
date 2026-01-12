//
//  PodcastPersistenceModel.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 29/12/2025.
//

import Foundation
import SwiftData

@Model
final class PodcastPersistenceModel {
    @Attribute(.unique)
    var id: UUID = UUID()
    var title: String
    var artworkUrl: String?
    var releasedDate: Date?
    var feedUrl: String
    var saved: Bool


    
    @Relationship(deleteRule: .nullify)
    var episodes: [EpisodePersistenceModel]

    init(
        id: UUID,
        title: String,
        feedUrl: String,
        artworkUrl: String?,
        saved: Bool) {
        self.id = id
        self.title = title
        self.artworkUrl = artworkUrl
        self.feedUrl = feedUrl
        self.saved = saved
        self.episodes = []
    }
}
extension PodcastPersistenceModel {
    @MainActor
    func toDomain() -> PodcastEntity {
        PodcastEntity(
            feedUrl: feedUrl,
            collectionCensoredName: title,
            artworkUrl100: artworkUrl,
            releasedDate: releasedDate ?? Date(),
            saved: saved )
    }
}

extension PodcastPersistenceModel {
    var image: URL? {
        guard let artworkUrl else { return nil }
        return URL(string: artworkUrl)
    }
}
