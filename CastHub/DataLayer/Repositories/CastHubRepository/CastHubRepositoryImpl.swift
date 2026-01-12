//
//  CastHubServiceImpl.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 16/12/2025.
//

import Foundation
import IbFoundation

final class CastHubRepositoryImpl: CastHubRepository {

    private let service: CastHubService

    init(service: CastHubService) {
        self.service = service
    }

    func searchPodcasts(for query: String, offset: Int) async throws -> PodcastResponse {
        return try await service.searchPodcasts(for: query, offset: offset)

    }

    func fetchRssFeed(from feedURL: String) async throws -> RssFeedResponse {
        return try await service.fetchRssFeed(from: feedURL)
    }
}


