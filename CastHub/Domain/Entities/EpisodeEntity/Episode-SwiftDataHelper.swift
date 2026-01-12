//
//  Episode-SwiftDataHelper.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 15/12/2025.
//

import Foundation

extension EpisodeEntity {
    var episodeID: String { id.uuidString }

    var episodeTitle: String { title ?? "" }

    var episodeContent: String { content ?? "" }

    var episodeDuration: TimeInterval { itunesDuration ?? TimeInterval() }

    var image: URL? { guard let url = URL(string: imageUrl ?? "") else { return nil }
        return url }

    var episodeAudioUrl: URL? { guard let audioPlay = URL(string: audio ?? "") else { return nil}
        return audioPlay }

    var episodeAudioLength: Int { Int(episodeDuration) }
}

extension EpisodeEntity {
    
    var duration: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad

        if let formattedString = formatter.string(from: episodeDuration) {
            return formattedString
        } else {
            return "Invalid Time"
        }
    }
}

extension EpisodeEntity {
    var episodePublicationDate: Date { return pubDate }
    var episodePublicationDateAsString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "d.M.yyyy"

        return formatter.string(from: episodePublicationDate)
    }
}
