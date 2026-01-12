//
//  RssFeedEntity.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 25/12/2025.
//

import Foundation
import IbFoundation
import FeedKit
internal import XMLKit


final class RssFeedEntity {
    var channel: Channel

    init(channel: Channel) {
        self.channel = channel
    }

    // MARK: - Decodable
    private enum CodingKeys: String, CodingKey {
        case channel
    }


    final class Channel {
        var title: String
        var content: String?
        var lastbuildDate: Date?
        var episodes: [EpisodeEntity]?

        enum CodingKeys: String, CodingKey {
            case guid = "podcast:guid"
            case title
            case content = "description"
            case lastBuildDate = "lastBuildDate"
            case episodes = "item"
        }

        init(
            title: String,
            content: String?,
            lastbuildDate: Date?,
            episodes: [EpisodeEntity]?
        ) {
            self.title = title
            self.content = content
            self.lastbuildDate = lastbuildDate
            self.episodes = episodes
        }

        init(feedItem: RSSFeed) {
            self.title = feedItem.channel?.title ?? ""
            self.content = feedItem.channel?.description
            self.lastbuildDate = feedItem.channel?.lastBuildDate
            self.episodes = feedItem.channel?.items?.compactMap{ item in
                EpisodeEntity(
                    title: item.title ?? "",
                    pubDate: item.pubDate ?? Date(),
                    content: item.description ?? "",
                    imageUrl: item.iTunes?.image?.attributes?.href,
                    itunesDuration: item.iTunes?.duration,
                    url: item.enclosure?.attributes?.url ?? "",
                    type: item.enclosure?.attributes?.type ?? ""
                )
            }
        }
    }
}
