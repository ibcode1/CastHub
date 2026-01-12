//
//  ContentCellView.swift
//  PodcastHub
//
//  Created by Ibrahim fuseini on 30/12/2024.
//

import SwiftUI
import IbToolKit

struct ContentCellView: View {
  let subtitle: String

  var body: some View {
    ScrollView {
      Text(subtitle)
        .ibFont(.captionBold)
        .multilineTextAlignment(.center)
    }
    .padding(.vertical, 44.0)
  }
}

