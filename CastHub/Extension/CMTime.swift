//
//  Int-SecToMinHelpers.swift
//  PodcastHub
//
//  Created by Ibrahim fuseini on 18/09/2024.
//

import Foundation
import AVKit

extension CMTime {
  var toDisplayString: String {
    
    /// Convert CMTime to seconds as a Double
    let totalSeconds = CMTimeGetSeconds(self)
    
    /// Check if the totalSeconds value is valid
    guard totalSeconds.isFinite else {
      return "--:--:--" // Return a placeholder string for invalid values
    }
    
    /// Convert to integer seconds
    let totalSecondsInt = Int(totalSeconds)
    
    /// Calculate minutes and hours
    let seconds = totalSecondsInt % 60
    let minutes = (totalSecondsInt / 60) % 60
    let hours   = totalSecondsInt / 3600
    
    /// Return formatted string
    return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
  }
}

