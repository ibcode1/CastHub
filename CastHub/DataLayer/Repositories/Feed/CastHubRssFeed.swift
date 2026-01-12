//
//  CastHubRssFeed.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 23/12/2025.
//

import Foundation

protocol CastHubRssFeed {
    /// Fetches and parses an RSS feed from the given URL string.
    ///
    /// - Parameter feedURL: The URL string of the RSS feed to fetch.
    /// - Returns: A `RssFeedResponse` containing the results of the feed retrieval and parsing.
    /// - Throws: An error if the feed cannot be fetched or parsed.
    func fetchRssFeed(from feedURL: String) async throws -> RssFeedResponse
}
