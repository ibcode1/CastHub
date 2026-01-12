//
//  AppRootView.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 20/12/2025.
//

import SwiftUI

struct AppRootView: View {
    private var repository: CastHubRepository
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
        RootView {
            AppTabView(
                repository: repository,
                searchUseCase: searchUseCase,
                rssUseCase: rssUseCase,
                deleteUseCase: deleteUseCase,
                deleteAllUseCase: deleteAllUseCase,
                toggleSavedUseCase: toggleSavedUseCase
            )
        }
    }
}
