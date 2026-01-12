//
//  EpisodePersistenceModel.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 29/12/2025.
//


// Data/Local/Models/EpisodePersistenceModel.swift

import Foundation
import SwiftData

@Model
final class EpisodePersistenceModel {
    @Attribute(.unique)
    //var id: String
    var title: String?
    var pubDate: Date?
    var content: String?
    var imageUrl: String?
    var itunesDuration: TimeInterval?
    var audioUrl: String?
    var type: String?

    // a relationship to podcast
    @Relationship(deleteRule: .cascade, inverse: \PodcastPersistenceModel.episodes)
    var podcast: PodcastPersistenceModel?
    
    init(
       // id: String,
        title: String,
        pubDate: Date,
        content: String,
        imageUrl: String?,
        itunesDuration: TimeInterval,
        audioUrl: String,
        type: String) {
       // self.id = id
        self.title = title
        self.pubDate = pubDate
        self.content = content
        self.imageUrl = imageUrl
        self.itunesDuration = itunesDuration
        self.audioUrl = audioUrl
        self.type = type
    }
}


extension EpisodePersistenceModel {
    @MainActor
    func toDomain() -> EpisodeEntity {
         EpisodeEntity(
            title :title ?? "",
            pubDate :pubDate ?? Date(),
            content :content ?? "",
            imageUrl :imageUrl,
            itunesDuration :itunesDuration,
            url :audioUrl ?? "",
            type :type ?? ""
        )
    }
}
