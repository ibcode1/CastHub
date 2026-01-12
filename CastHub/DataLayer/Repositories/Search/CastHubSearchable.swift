//
//  CastHubSearchable.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 16/12/2025.
//

import Foundation
/// A protocol that defines an asynchronous method for searching podcasts based on a query.
///
/// Conforming types must implement logic to fetch podcast search results for a given query and pagination offset.
/// The operation is asynchronous and may throw errors if the search fails.
protocol CastHubSearchable {
    /// Searches for podcasts matching the given query and pagination offset.
    ///
    /// - Parameters:
    ///   - query: The search string to match podcasts against.
    ///   - offset: The number of items to skip (for pagination).
    /// - Returns: A `PodcastResponse` containing the search results.
    /// - Throws: An error if the search fails.
    func searchPodcasts(for query: String, offset: Int) async throws -> PodcastResponse
}
