//
//  RssFeedUseCaseImpl.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 23/12/2025.
//

import Foundation

/// A concrete implementation of `RssFeedUseCase` that fetches and parses episodes from an RSS feed.
///
/// This class uses a repository conforming to `CastHubRepository` to retrieve RSS feed data
/// and converts the fetched episode DTOs into domain entities.
class RssFeedUseCaseImpl: RssFeedUseCase {

    /// The repository used to fetch RSS feed data.
    private let repository: CastHubRepository

    /// Initializes the use case with the given RSS feed repository.
    ///
    /// - Parameter repository: The repository responsible for fetching RSS feed data.
    init(repository: CastHubRepository) {
        self.repository = repository
    }

    /// Fetches and parses episodes from the specified RSS feed URL.
    ///
    /// - Parameter feedURL: The URL string of the RSS feed to fetch.
    /// - Returns: An array of `EpisodeEntity` objects parsed from the feed.
    /// - Throws: An error if fetching or parsing the feed fails.
    func execute(feedURL: String) async throws -> [EpisodeEntity] {
        let response = try await repository.fetchRssFeed(from: feedURL)
        let dtos = response.channel?.episodes ?? []
        return dtos.map { $0.toDomain() }
    }
}
