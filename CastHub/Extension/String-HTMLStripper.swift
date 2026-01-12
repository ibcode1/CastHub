//
//  String-HTMLStripper.swift
//  PodcastHub
//
//  Created by Ibrahim fuseini on 17/10/2024.
//

import Foundation
import UIKit

extension String {

  func htmlStripped() async -> String {

    await MainActor.run {

      guard let data = self.data(using: .utf8) else { return self }

      let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
        .documentType: NSAttributedString.DocumentType.html,
        .characterEncoding: String.Encoding.utf8.rawValue
      ]
      let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil)

      return attributedString?.string ?? self
    }
  }
}
