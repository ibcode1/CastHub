//
//  CastHubApp.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 09/12/2025.
//

import SwiftUI
import IbFoundation
import Observation
import SwiftData

@main
struct CastHubApp: App {

    @State private var vm = SubscribedViewModel()
    @State private var dataController: DataController
    @State private var playerViewModel = PlayerViewModel()
    private(set) var castHubService: CastHubRepository
    private(set)var persistenceRepository: PersistenceRepository

    let searchUseCase: SearchUseCase
    let rssUseCase: RssFeedUseCase
    let deleteUseCase: DeleteModelUseCase
    let deleteAllUseCase: DeleteAllUseCase
    let toggleSavedUseCase: ToggleSavedUseCase

    init() {
        let dataController = DataController()
        self.dataController = dataController

        let decoder =
        JSONDecoder.jsonDecoder(modelContainer: dataController.container)
        let apiService = ApiServices(decoder: decoder)

        self.persistenceRepository = PersistenceRepositoryImpl(modelContext: dataController.container.mainContext) // or injected factory


        self.castHubService = CastHubService(apiService: apiService)
        self.searchUseCase = SearchUseCaseImpl(repository: castHubService)
        self.rssUseCase = RssFeedUseCaseImpl(repository: castHubService)
        self.deleteUseCase = DeleteModelUseCaseImpl(repository: persistenceRepository)
        self.deleteAllUseCase = DeleteAllUseCaseImpl(repository: persistenceRepository)
        self.toggleSavedUseCase = ToggleSavedImpl(repository: persistenceRepository)
    }

    var body: some Scene {
        WindowGroup {
            AppRootView(
                repository: castHubService,
                searchUseCase: searchUseCase,
                rssUseCase: rssUseCase,
                deleteUseCase: deleteUseCase,
                deleteAllUseCase: deleteAllUseCase,
                toggleSavedUseCase: toggleSavedUseCase
            )
        }
        .environment(dataController)
        .environment(vm)
        .modelContainer(dataController.container)
        .environment(playerViewModel)
        .environment(\.rssUseCase, rssUseCase)

    }
}
