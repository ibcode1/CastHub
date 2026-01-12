//
//  EpisodeResponse.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 12/12/2025.
//

import Foundation
import FeedKit

// MARK: RssFeedResponse
struct RssFeedResponse: Decodable, Sendable {
    let channel: Channel?
}

struct Channel: Decodable, Sendable {
    let title: String
    let content: String?
    let lastbuildDate: Date?
    let itunesimage: String?
    let episodes: [EpisodeDTO]?

    enum CodingKeys: String, CodingKey {
        case title
        case content = "description"
        case lastbuildDate
        case itunesimage = "itunes:image"
        case episodes = "item"
    }
}

extension RssFeedResponse {
    func toDomain() -> RssFeedEntity? {
        guard let channel = channel else { return nil }

        let domainChannel = RssFeedEntity.Channel(
            title: channel.title,
            content: channel.content,
            lastbuildDate: channel.lastbuildDate,
            episodes: channel.episodes?.map { $0.toDomain() }
        )

        return RssFeedEntity(channel: domainChannel)
    }
}
