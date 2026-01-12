//
//  EpisodeResponse.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 12/12/2025.
//

import Foundation
import FeedKit
internal import XMLKit

// MARK: - EpisodeResponse
final class EpisodeEntity: Identifiable {
    var id: UUID = UUID()
    var title: String?
    var pubDate: Date
    var content: String?
    var imageUrl: String?
    var itunesDuration: TimeInterval?
    var audio: String?
    var type: String?
    

    enum CodingKeys: String, CodingKey {
        case title
        case pubDate
        case content = "description"
        case itunesDuration = "itunes:duration"
        case audio = "url"
        case type
    }

    init(feedItem: RSSFeedItem) {
        self.title = feedItem.title ?? ""
        self.content = feedItem.description ?? ""
        self.pubDate = feedItem.pubDate ?? Date()
        self.imageUrl = feedItem.iTunes?.image?.attributes?.href
        self.itunesDuration = feedItem.iTunes?.duration
        self.audio = feedItem.enclosure?.attributes?.url
        self.type = feedItem.enclosure?.attributes?.type
    }

    init(
        title: String,
        pubDate: Date,
        content: String,
        imageUrl: String?,
        itunesDuration: TimeInterval?,
        url: String,
        type: String) {
            
        self.title = title
        self.pubDate = pubDate
        self.content = content
        self.imageUrl = imageUrl
        self.itunesDuration = itunesDuration
        self.audio = url
        self.type = type
    }
}


extension EpisodeEntity {
    func toPersistence() -> EpisodePersistenceModel {
        EpisodePersistenceModel(
            title: self.title ?? "Untitled Episode",
            pubDate: self.pubDate,                      
            content: self.content ?? "",
            imageUrl: self.imageUrl,
            itunesDuration: self.itunesDuration ?? 0,
            audioUrl: self.audio ?? "",
            type: self.type ?? "audio")
    }
}

extension EpisodeEntity: Equatable, Hashable {
    static func == (lhs: EpisodeEntity, rhs: EpisodeEntity) -> Bool {
        lhs.episodeID == rhs.episodeID
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(episodeID)
    }
}
