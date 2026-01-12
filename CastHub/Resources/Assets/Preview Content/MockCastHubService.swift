//
//  MockCastHubService.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 20/12/2025.
//

import Foundation
import IbFoundation
import SwiftData

final class MockCastHubService: CastHubRepository {
    
    let dataController = DataController.preview
    private let resourceBundle: Bundle

    init(resourceBundle: Bundle = .main) {
        self.resourceBundle = resourceBundle
    }
}

// MARK: - CastHubSearchable

extension MockCastHubService: CastHubSearchable {
    func searchPodcasts(for query: String, offset: Int) async throws -> PodcastResponse {

        let decoder = JSONDecoder.jsonDecoder(modelContainer: dataController.container)
        let podcastResponse: PodcastResponse = resourceBundle.decode(from: "MockPodcastResponse.json", jsonDecoder: decoder)
        return podcastResponse
    }
}

// MARK: - RssFeed

extension MockCastHubService: CastHubRssFeed {
    func fetchRssFeed(from feedURL: String) async throws -> RssFeedResponse {
        let rssFeedResponse: RssFeedResponse = Bundle.main.decode(RssFeedResponse.self,from: "MockRssFeedResponse.xml")

        return rssFeedResponse
    }

}
