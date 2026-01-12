//
//  Podcast-SwiftDataHelper.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 14/12/2025.
//

import Foundation
import UIKit

extension PodcastEntity {
    
    var podcastFeedUrl: String { feedUrl ?? "" }
    var censorName: String { collectionCensoredName ?? "" }

    var image: URL? {
        guard let artworkUrl100 else { return nil }
        return URL(string: artworkUrl100)
    }
    var podcastDate: Date { releasedDate ?? Date() }
}
