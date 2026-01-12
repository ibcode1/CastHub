//
//  CastHubService.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 12/12/2025.
//


import Foundation
import IbFoundation
import FeedKit
internal import XMLKit

final class CastHubService: CastHubRepository {
    private let limit = Config.batchSize
    private let apiService: ApiServiceProtocol

    init(apiService: ApiServiceProtocol) {
        self.apiService = apiService
    }
}

extension CastHubService: CastHubSearchable {
    func searchPodcasts(for query: String, offset: Int) async throws -> PodcastResponse {
        // 1. Create URL Builder
        let urlBuilder = createURLBuilder(
            path: "/search",
            parameters: [
                "term"  : query,
                "media" : "podcast",
                "limit" : String(limit),
                "offset": "\(offset)"
            ])
        //2. Get response object
        let podcastResponse: PodcastResponse = try await
        loadURLAndDecode(from: urlBuilder)

        //3. Return Data
        return podcastResponse
    }
}

extension CastHubService: CastHubRssFeed {
    func fetchRssFeed(from feedURL: String) async throws -> RssFeedResponse {
        let secureFeedURL = feedURL.contains("https") ? feedURL : feedURL.replacingOccurrences(of: "http", with: "https")

        guard let url = URL(string: secureFeedURL) else {
            throw URLError(.badURL)
        }

        // FeedKit 10+ async/await API
        let rssFeed = try await RSSFeed(url: url)

        // Map FeedKit's RSSFeed to your custom RssFeedResponse
        guard let feedChannel = rssFeed.channel else {
            throw URLError(.cannotParseResponse)
        }

        let channel = Channel(
            title: feedChannel.title ?? "",
            content: feedChannel.description,
            lastbuildDate: feedChannel.lastBuildDate,
            itunesimage: feedChannel.image?.url,
            episodes: feedChannel.items?.map { item in
                let dateFormatter = DateFormatter()
                            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                            dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
                return EpisodeDTO(
                    title: item.title,
                    pubDate: item.pubDate.map { dateFormatter.string(from: $0)},
                    link: item.link,
                    content: item.description,
                    itunesDuration: item.iTunes?.duration ?? TimeInterval(),
                    itunesImage: item.iTunes?.image?.attributes?.href.map { EpisodeDTO.ITunesImage(href: $0) } ?? EpisodeDTO.ITunesImage(href: ""),
                    url: item.enclosure?.attributes?.url ?? "",
                    type: item.enclosure?.attributes?.type ?? ""
                )
            }
        )
        return RssFeedResponse(channel: channel)
    }
}

private extension CastHubService {
    func createURLBuilder(
        path: String,
        headers: [String: String]? = nil,
        parameters: [String: String]? = nil
    ) -> URLBuilding? {

        var builder = URLBuilder(host: Config.baseAPIHost, basePath: Config.basePath, path: path)

        if let headers {
            for (key, value) in headers {
                builder = builder.addHeader(field: key, value: value)
            }
        }

        if let parameters {
            for (key, value) in parameters {
                if let updated = builder.addQueryItem(name: key, value: value) {
                    builder = updated
                } else {
                    // If adding a query item fails, you can choose to return nil or skip it.
                    // Here we choose to fail the whole builder:
                    return nil
                }
            }
        }

        return builder
    }

    func loadURLAndDecode<T: Decodable>(from urlBuilder: URLBuilding?) async throws -> T {
        guard let urlBuilder else { throw URLError(.badURL)}
        return try await apiService.fetchData(for: urlBuilder)
    }
}
