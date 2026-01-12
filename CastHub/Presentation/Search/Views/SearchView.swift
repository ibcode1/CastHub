//
//  SearchView.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 21/12/2025.
//


import SwiftUI
import IbToolKit

struct SearchView: View {
    @State private var viewModel: SearchViewModel
    @Environment(\.rssUseCase) private var rssUseCase
    @Environment(\.modelContext) private var context
    init(viewModel: SearchViewModel) { self.viewModel = viewModel }

    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.podcasts) {
                        podcast in
                        NavigationLink {
                            PodcastDetailsView(podcast: podcast, rssUseCase: rssUseCase, context: context)
                        } label: {
                            SearchRowView(podcast: podcast)
                                .task {
                                    await viewModel.loadMoreIfNeeded(currentPodcast: podcast)}
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .navigationTitle("Search")
            .searchable(text: $viewModel.term, placement: .navigationBarDrawer(displayMode: .always))
            .ibFont(.h5Light)
            .overlay { emptyStateOverlayView }
            .overlay(loadingOverlayView)
        }
    }
}

private extension SearchView {
    @ViewBuilder
    var emptyStateOverlayView: some View {
        if viewModel.term.isEmpty && viewModel.podcasts.isEmpty {
            EmptyStateView(
                title: "Search for podcast",
                description: "Search for Podcast here",
                icon: "music.mic.circle",
                yOffset: -88)
        } else if viewModel.podcasts.isEmpty && viewModel.isLoading == false {
            EmptyStateView(
                title: "Podcast not found",
                description: "No result found",
                icon: "questionmark.diamond",
                yOffset: -88)
        }
    }
    @ViewBuilder
    var loadingOverlayView: some View {
        if viewModel.term.isEmpty && viewModel.isLoading { ProgressView() }
    }
}
