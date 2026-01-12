//
//  PodcastRow.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 01/01/2026.
//

import SwiftUI
import IbToolKit

struct PodcastRow: View {
    let podcast: PodcastPersistenceModel
    var date: Date = Date()
    let onDelete: () -> Void

    var body: some View {
        StandardCellView(title: podcast.title, imageURL: podcast.image)
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .destructive) {
                    onDelete()
                } label: {
                    Label("Delete", systemImage: "trash")}}
    }
}
