//
//  AppTabView.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 21/12/2025.
//

import SwiftUI

struct AppTabView: View {

    @Environment(PlayerViewModel.self) private var playerViewModel
    @State private var showMiniPlayer = false
    @State private var hideMiniPlayer = false

    @AppStorage("tabSelection") var tabSelection: Int?
    private let repository: CastHubRepository
    let searchUseCase: SearchUseCase
    let rssUseCase: RssFeedUseCase
    let deleteUseCase: DeleteModelUseCase
    let deleteAllUseCase: DeleteAllUseCase
    let toggleSavedUseCase: ToggleSavedUseCase

    init(
        repository: CastHubRepository,
        searchUseCase: SearchUseCase,
        rssUseCase: RssFeedUseCase,
        deleteUseCase: DeleteModelUseCase,
        deleteAllUseCase: DeleteAllUseCase,
        toggleSavedUseCase: ToggleSavedUseCase
    ) {
        self.repository = repository
        self.searchUseCase = searchUseCase
        self.rssUseCase = rssUseCase
        self.deleteUseCase = deleteUseCase
        self.deleteAllUseCase = deleteAllUseCase
        self.toggleSavedUseCase = toggleSavedUseCase
    }

    var body: some View {
        TabView(selection: $tabSelection) {
            ForEach(CHTab.allCases) {
                tab in NavigationStack {
                    setView(for: tab)
                }
                .tabItem {
                    Label(tab.title, systemImage: tab.icon)
                        .tag(tab.tag)
                }
            }
        }
        .universalOverlay(show: $showMiniPlayer) {
            if playerViewModel.selectedEpisode != nil {
                ExpandablePodcastPlayer(show: $showMiniPlayer, hideMiniPlayer: $hideMiniPlayer)
                    .environment(playerViewModel)
            }
        }
        .onChange(of: playerViewModel.selectedEpisode) {
            if (playerViewModel.selectedEpisode == nil) {
                showMiniPlayer = false
            } else {
                showMiniPlayer = true
            }
        }
    }

    @ViewBuilder
    func setView(for tab: CHTab) -> some View {
        switch tab {
        case .search: SearchView(viewModel: SearchViewModel(useCase: searchUseCase))

        case .save: SubcribedListView(
            viewModel: SubscribedViewModel(
                deleteModelUseCase: deleteUseCase,
                deleteAllUseCase: deleteAllUseCase,
                toggleUseCase: toggleSavedUseCase))
        }
    }
}
