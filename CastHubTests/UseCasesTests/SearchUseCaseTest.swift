//
//  SearchUseCases.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 09/01/2026.
//

import XCTest
import FeedKit
@testable import CastHub
internal import XMLKit

@MainActor
final class SearchUseCaseTest: XCTestCase {

    //Dto Testing
    func test_search_podcast() async throws {
        let mockRespository = MockCastHubRepository()

        //Given
        let mockpodcast = PodcastDTO(
            feedUrl: "https://anchor.fm/s/19c10930/podcast/rss",
            collectionCensoredName: "Swift",
            artworkUrl100: "",
            releasedDate: Date())
        mockRespository.expectedResults = PodcastResponse(
            resultCount: 1,
            podcasts: [mockpodcast]
        )

        //when
        let searchUseCase = SearchUseCaseImpl(repository: mockRespository)
            let result = try await searchUseCase.execute(query: "Swift", offset: 1)

        //then
        XCTAssertEqual(result.items.count, 1)
        XCTAssertEqual(result.items.first?.censorName, "Swift")
    }

    // Test Mapping from Dto to Entity
    func test_podcastDto_toDomain() async throws {
        let mockRespository = MockCastHubRepository()

        //Given
        let mockpodcast = PodcastDTO(
            feedUrl: "https://anchor.fm/s/19c10930/podcast/rss",
            collectionCensoredName: "SwiftCoders",
            artworkUrl100: "https://is1-ssl.mzstatic.com/image/thumb/Podcasts122/v4/1e/49/9f/1e499f3b-1c92-929d-62fc-882b3197a2e6/mza_4339264950966719339.png/100x100bb.jpg",
            releasedDate: Date())
        mockRespository.expectedResults = PodcastResponse(
            resultCount: 1,
            podcasts: [mockpodcast])

        //when
        let entity = mockpodcast.toDomain()

        //then
        XCTAssertEqual(entity.censorName, "SwiftCoders")
        XCTAssertNotNil(entity.image?.absoluteString)
    }

    func test_local_xml_file() async throws {

        //Give
        //Load XML from test bundle
#if SWIFT_PACKAGE
        let resourceBundle = Bundle.module
#else
        let resourceBundle = Bundle(for: type(of: self))
#endif
        guard let url = resourceBundle.url(forResource: "FeedResponses", withExtension: "xml")
        else {
            print("❌ Could not find FeedResponse.xml")

            XCTFail("Could not find FeedResponses.xml in test bundle")
                    throw NSError(domain: "TestError", code: 404, userInfo: [NSLocalizedDescriptionKey: "XML file not found"])
        }
        XCTAssertNotNil(url)
        let xmlData = try Data(contentsOf: url)

        //Parse using FeedKit Async API
        let rssFeed = try RSSFeed(data: xmlData)

        //Now test your mapping logic
        guard let feedChannel = rssFeed.channel else {
            XCTFail("Channel should not nil")
            return
        }
        let channel = Channel(
            title: feedChannel.title ?? "",
            content: feedChannel.description,
            lastbuildDate: feedChannel.lastBuildDate,
            itunesimage: feedChannel.image?.url,
            episodes: feedChannel.items?.map { item in
                EpisodeDTO(
                    title: item.title,
                    pubDate: nil,
                    link: item.link,
                    content: item.description,
                    itunesDuration: item.iTunes?.duration ?? TimeInterval(),
                    itunesImage: item.iTunes?.image?.attributes?.href.map { EpisodeDTO.ITunesImage(href: $0) } ?? EpisodeDTO.ITunesImage(href: ""),
                    url: item.enclosure?.attributes?.url ?? "",
                    type: item.enclosure?.attributes?.type ?? ""
                )
            }
        )
        let response = RssFeedResponse(channel: channel)
        let mockRepo = MockCastHubRepository()
        mockRepo.expectedRssResponse = response

        // WHEN
        let result = try await mockRepo.fetchRssFeed(from: "ignored-url")

        //THEN
        XCTAssertNotNil(result.channel)
        XCTAssertEqual(result.channel?.title, channel.title)
        XCTAssertEqual(result.channel?.episodes?.count, channel.episodes?.count)
    }

}

// MARK: Helpers
final class MockCastHubRepository: CastHubRepository {
    var expectedRssResponse: RssFeedResponse?
    var expectedResults: PodcastResponse?
    var expectedError: TestSearchError?

    func fetchRssFeed(from feedURL: String) async throws -> RssFeedResponse {
        if let error = expectedError { throw error }
        return expectedRssResponse ?? RssFeedResponse(
            channel: nil // We are not using the network response in this test
        ) }

    func searchPodcasts(for query: String, offset: Int) async throws -> PodcastResponse {
        if let error = expectedError {
            throw error
        }
        return expectedResults ?? PodcastResponse(resultCount: 0, podcasts: [])
    }
}

enum TestSearchError: Error {
    case fileNotFound(String)
}
