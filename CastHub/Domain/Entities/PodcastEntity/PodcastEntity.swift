//
//  PodcastEntity.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 12/12/2025.
//

import Foundation
import IbFoundation

final class PodcastEntity: Decodable, Identifiable {
    var id = UUID()
    var feedUrl: String?
    var collectionCensoredName: String?
    var artworkUrl100: String?
    var releasedDate: Date?
    var saved: Bool

    enum CodingKeys: String, CodingKey {
        case feedUrl
        case collectionCensoredName = "collectionCensoredName"
        case artworkUrl100
        case releasedDate
        case saved
    }

    init(feedUrl: String?, collectionCensoredName: String?, artworkUrl100: String?, releasedDate: Date, saved: Bool) {
        self.feedUrl = feedUrl
        self.collectionCensoredName = collectionCensoredName
        self.artworkUrl100 = artworkUrl100
        self.releasedDate = releasedDate
        self.saved = saved
    }

    required convenience init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)
        let feedUrl = try container.decodeIfPresent(String.self, forKey: .feedUrl)
        let collectionCensoredName = try container.decode(String.self, forKey: .collectionCensoredName)
        let artworkUrl100 = try container.decode(String.self, forKey: .artworkUrl100)
        let releasedDate = try container.decode(Date.self, forKey: .releasedDate)
        let saved = try container.decode(Bool.self, forKey: .saved)

        self.init(
            feedUrl: feedUrl,
            collectionCensoredName: collectionCensoredName,
            artworkUrl100: artworkUrl100,
            releasedDate: releasedDate,
            saved: saved

        )
    }
}

extension PodcastEntity {
    func toPersistence() -> PodcastPersistenceModel {
        PodcastPersistenceModel(
            id: self.id,
            title: self.collectionCensoredName ?? "",
            feedUrl: self.feedUrl ?? "",
            artworkUrl: self.artworkUrl100,
            saved: self.saved
            //releasedDate: self.releasedDate
        )
    }
}
