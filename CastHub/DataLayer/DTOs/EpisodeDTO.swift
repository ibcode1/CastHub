//
//  EpisodeDTO.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 18/12/2025.
//

import Foundation


final class EpisodeDTO: Decodable {
    //var id: String?
    var title: String?
    var pubDate: String?
    var link: String?
    var content: String?
    var itunesDuration: TimeInterval?
    var itunesImage: ITunesImage
    var url: String?
    var type: String?


    enum CodingKeys: String, CodingKey {
        //case id = "guid"
        case title
        case pubDate
        case link
        case content = "description"
        case itunesDuration = "itunes:duration"
        case itunesImage = "itunes:image"

    }

    init(
        //id: String? = nil,
        title: String? = nil,
        pubDate: String? = nil,
        link: String? = nil,
        content: String? = nil,
        itunesDuration: TimeInterval,
        itunesImage: ITunesImage,
        url: String? = nil,
        type: String? = nil) {
        //self.id = id
        self.title = title
        self.pubDate = pubDate
        self.link = link
        self.content = content
        self.itunesDuration = itunesDuration
        self.itunesImage = itunesImage
        self.url = url
        self.type = type
    }
}

extension EpisodeDTO {
    func toDomain() -> EpisodeEntity {
        EpisodeEntity(
            //id: id ?? "",
            title: title ?? "",
            pubDate: parsedPubDate ?? Date(),
            content: content ?? "",
            imageUrl: itunesImage.href,
            itunesDuration: itunesDuration ?? TimeInterval(),
            url: url ?? "",
            type: type ?? ""
        )

    }
}

extension EpisodeDTO {
    private var parsedPubDate: Date? {
        guard let pubDate = pubDate else { return nil }

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"

        return dateFormatter.date(from: pubDate)
    }
}

extension EpisodeDTO {
    final class ITunesImage: Decodable {
        let href: String?

        enum CodingKeys: String, CodingKey {
            case href
        }
        init(href: String) {
            self.href = href
        }
    }
}

