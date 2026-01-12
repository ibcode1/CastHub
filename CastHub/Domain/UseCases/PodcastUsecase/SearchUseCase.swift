//
//  PodcastUseCase.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 17/12/2025.
//

import Foundation
import IbFoundation

/// A generic structure representing the result of a paginated query.
///
/// Contains the current page of items and an optional offset indicating the starting point for the next page.
public struct PaginationResult<T> {
    /// The collection of items retrieved in the current page.
    public let items: [T]
    /// The offset to use for fetching the next page, or `nil` if there are no more pages.
    public let nextOffset: Int?

    /// Initializes a new paginated result.
    ///
    /// - Parameters:
    ///   - items: The array of items in the current page.
    ///   - nextOffset: The offset for the next page, or `nil` if there is no next page.
    public init(items: [T], nextOffset: Int?) {
        self.items = items
        self.nextOffset = nextOffset
    }
}

/// A protocol that defines an asynchronous use case for searching with pagination.
///
/// Conforming types must implement logic to perform a search based on a query and pagination offset,
/// returning a paginated result of `PodcastEntity` objects.
protocol SearchUseCase {
    /// Performs a search for podcasts matching the given query and offset.
    ///
    /// - Parameters:
    ///   - query: The search string to match against.
    ///   - offset: The number of items to skip (for pagination).
    /// - Returns: A `PaginationResult<PodcastEntity>` containing the results and next offset.
    /// - Throws: An error if the search fails.
    func execute(query: String, offset: Int) async throws -> PaginationResult<PodcastEntity>
}
