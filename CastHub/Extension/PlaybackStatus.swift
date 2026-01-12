//
//  PlaybackStatus.swift
//  PodcastHub
//
//  Created by Ibrahim fuseini on 21/11/2024.
//

import Foundation

extension PlaybackStatus: Equatable {
  static func == (lhs: PlaybackStatus, rhs: PlaybackStatus) -> Bool {
    switch (lhs, rhs) {
    case (.empty, .empty):
      return true
    case let (.idle(lhsEpisodes), .idle(rhsEpisodes)):
      return lhsEpisodes == rhsEpisodes
    case let (.playing(lhsEpisode, lhsProgress), .playing(rhsEpisode, rhsProgress)):
      return lhsEpisode == rhsEpisode && lhsProgress == rhsProgress
    case let (.paused(lhsEpisode, lhsProgress), .paused(rhsEpisode, rhsProgress)):
      return lhsEpisode == rhsEpisode && lhsProgress == rhsProgress
    case let (.finish(lhsEpisodes), .finish(rhsEpisodes)):
      return lhsEpisodes == rhsEpisodes
    default:
      return false
    }
  }
}
