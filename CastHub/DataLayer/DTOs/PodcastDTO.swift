//
//  PodcastDTO.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 18/12/2025.
//

import Foundation

final class PodcastDTO: Decodable {
    var feedUrl: String?
    var collectionCensoredName: String?
    var artworkUrl100: String?
    var releasedDate: Date?

    enum CodingKeys: String, CodingKey {
        case feedUrl
        case collectionCensoredName = "collectionCensoredName"
        case artworkUrl100
        case releasedDate
    }

    init(feedUrl: String, collectionCensoredName: String, artworkUrl100: String, releasedDate: Date) {
        self.feedUrl = feedUrl
        self.collectionCensoredName = collectionCensoredName
        self.artworkUrl100 = artworkUrl100
        self.releasedDate = releasedDate
    }
}

extension PodcastDTO {
    func toDomain() -> PodcastEntity {
        PodcastEntity(
            feedUrl: feedUrl ?? "",
            collectionCensoredName: collectionCensoredName ?? "",
            artworkUrl100: artworkUrl100 ?? "",
            releasedDate: releasedDate ?? Date(), saved: false)
    }
}
