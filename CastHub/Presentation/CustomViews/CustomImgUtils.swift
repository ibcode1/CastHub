//
//  CustomImgUtils.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 06/01/2026.
//

import SwiftUI

struct CustomImgUtils: View {
  var body: some View {
    Image("events_placeholder")
      .renderingMode(.original)
      .resizable()
      .aspectRatio(contentMode: .fill)
      .frame(width: 70, height: 70)
      .clipped()
  }
}
