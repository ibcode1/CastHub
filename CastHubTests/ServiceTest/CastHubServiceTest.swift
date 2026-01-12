//
//  CastHubServiceTest.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 12/01/2026.
//

import XCTest
@testable import CastHub

class CastHubServiceTest: XCTestCase {
    let url = URL(string: "https://itunes.apple.com/search?media=podcast&term=swiftCoders")

    func testURL() async throws {
        // given
        let baseURL = URL(string: "https://apple.com")
        let url = url

        //then
        XCTAssertNotEqual(url, baseURL, "Search URL should be different from base URL")
    }

    func test_noServerResponse() async throws {
        // given
        let url = URL(string: "itunes.apple")!
        do {
            //When
            let(data, response) = try await URLSession.shared.data(from: url)
            XCTAssertNil(data)
            XCTAssertNil(response)
        } catch {
            //Then
            XCTAssertNotNil(error)
        }
    }

    func test_validRequest_returns200Success() async throws {
        // Given
        guard let validURL = url else {
            XCTFail("URL should not be nil")
            return
        }

        // When
        let dataAndResponse: (data: Data, response: URLResponse) = try await URLSession.shared.data(from: validURL)

        // Then
        let httpResponse = try XCTUnwrap(
            dataAndResponse.response as? HTTPURLResponse,
            "Expected an HTTPURLResponse."
        )

        XCTAssertEqual(
            httpResponse.statusCode,
            200,
            "Expected a 200 OK response, but got \(httpResponse.statusCode)"
        )
    }

    // MARK: - Response Data Tests

    /// Tests that a valid request returns non-empty data.
    func test_validRequest_returnsData() async throws {
        // Given
        guard let validURL = url else {
            XCTFail("URL should not be nil")
            return
        }

        // When
        let (data, _) = try await URLSession.shared.data(from: validURL)

        // Then
        XCTAssertFalse(data.isEmpty, "Response data should not be empty")
    }
}
