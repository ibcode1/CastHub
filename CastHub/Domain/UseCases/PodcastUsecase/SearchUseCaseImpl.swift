//
//  PodcastUseCaseImpl.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 17/12/2025.
//

import Foundation
import IbFoundation

/// A concrete implementation of `SearchUseCase` for searching podcasts with pagination.
///
/// This use case interacts with a repository to perform a podcast search, translates the results into domain entities,
/// and returns paginated results.
class SearchUseCaseImpl: SearchUseCase {
    /// The repository used for searching podcasts.
    private let repository: CastHubRepository
    /// The batch size used for pagination.
    private let offset = Config.batchSize

    /// Initializes the use case with the specified repository.
    ///
    /// - Parameter repository: The repository responsible for podcast search operations.
    init(repository: CastHubRepository) {
        self.repository = repository
    }

    /// Executes a search for podcasts matching the query, returning paginated results.
    ///
    /// - Parameters:
    ///   - query: The search string to match against.
    ///   - offset: The number of items to skip (for pagination).
    /// - Returns: A `PaginationResult<PodcastEntity>` containing the podcasts and next offset if more results exist.
    /// - Throws: An error if the search fails.
    func execute(query: String, offset: Int) async throws -> PaginationResult<PodcastEntity> {
        let response = try await repository.searchPodcasts(for: query, offset: offset)
        let dtos = response.podcasts ?? []
        let domainPodcasts = dtos.map { $0.toDomain() }
        let nextOffset: Int? = domainPodcasts.count == offset ? offset + offset : nil
        return PaginationResult(
            items: domainPodcasts,
            nextOffset: nextOffset
        )
    }
}
