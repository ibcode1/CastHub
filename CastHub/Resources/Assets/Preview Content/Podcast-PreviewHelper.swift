//
//  Podcast-PreviewHelper.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 20/12/2025.
//

import Foundation
import SwiftData

// MARK: Podcast Preview Data

extension PodcastEntity {
    @MainActor
    static var example: PodcastEntity {
        let context = DataController.preview.container.mainContext

            let podcast = PodcastEntity(
                feedUrl: "https://anchor.fm/s/19c10930/podcast/rss",
                collectionCensoredName: "Swiftly Speaking",
                artworkUrl100: "https://is1-ssl.mzstatic.com/image/thumb/Podcasts113/v4/e9/85/cf/e985cf4a-5803-0f1a-9125-3afa2e0fda2a/mza_6952985839859415655.jpg/100x100bb.jpg",
                releasedDate: Date(), saved: false)

            return podcast
    }
}
