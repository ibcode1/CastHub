//
//  PodcastResponse.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 12/12/2025.
//

import Foundation

// MARK: PodcastResponse
struct PodcastResponse: Decodable {
    let resultCount: Int
    let podcasts: [PodcastDTO]?

    enum CodingKeys: String, CodingKey {
        case resultCount
        case podcasts = "results"
    }
}

extension PodcastResponse {
    func toDomain() -> [PodcastEntity] {
        podcasts?.map {  $0.toDomain() } ?? []
    }
}
