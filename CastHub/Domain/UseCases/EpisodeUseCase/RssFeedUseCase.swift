//
//  RssFeedUseCase.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 23/12/2025.
//

import Foundation

/// A protocol that defines an asynchronous method for fetching and parsing episodes from an RSS feed.
///
/// Conforming types must implement logic to retrieve and parse an RSS feed at a given URL,
/// returning an array of `EpisodeEntity` objects representing the episodes in the feed.
/// The operation is asynchronous and may throw errors if fetching or parsing fails.
protocol RssFeedUseCase {
    /// Fetches and parses episodes from the specified RSS feed URL.
    ///
    /// - Parameter feedURL: The URL string of the RSS feed to fetch.
    /// - Returns: An array of `EpisodeEntity` objects parsed from the feed.
    /// - Throws: An error if fetching or parsing the feed fails.
    func execute(feedURL: String) async throws -> [EpisodeEntity]
}
