//
//  PodcastEpisodeCellView.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 24/12/2025.
//

import SwiftUI
import IbToolKit
import SwiftData

struct PodcastEpisodeCellView: View {
    @Environment(SubscribedViewModel.self) private var viewModel
    let podcast: PodcastEntity

    var horizontalPadding: CGFloat = 16.0
    @State private var podcastContent: String?
    @State private var isSaved: Bool = false
    


    var body: some View {
        VStack {
            AsyncImage(url: podcast.image) { image in
                image
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 390, height: 320)
                    .clipped()
            } placeholder: {
                //Color(.systemGroupedBackground)
                //ProgressView()
                CustomImgUtils()
            }

            VStack(alignment: .center, spacing: 4.0) {
                Text(podcast.censorName)
                    .ibFont(.h5Bold)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .minimumScaleFactor(0.6)

                Divider()

                Button {
                    Task {
                        await viewModel.toggleSaved(podcast)
                        isSaved.toggle()
                    }
                } label: {
                    Image(systemName: isSaved ? "xmark" : "bookmark")
                }

            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, horizontalPadding)
    }
}

