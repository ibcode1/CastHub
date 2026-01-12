//
//  PodcastViewModel.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 31/12/2025.
//


import Foundation
import Observation

@MainActor
@Observable
final class SubscribedViewModel {

    private let deleteModelUseCase: DeleteModelUseCase
    private let deleteAllUseCase: DeleteAllUseCase
    private let toggleUseCase: ToggleSavedUseCase

    init(
        deleteModelUseCase: DeleteModelUseCase = DeleteModelUseCaseImpl(repository: DataController.shared.persistenceRepository),
        deleteAllUseCase: DeleteAllUseCase = DeleteAllUseCaseImpl(repository: DataController.shared.persistenceRepository),
        toggleUseCase: ToggleSavedUseCase = ToggleSavedImpl(repository: DataController.shared.persistenceRepository),
    ) {
        self.deleteModelUseCase = deleteModelUseCase
        self.deleteAllUseCase = deleteAllUseCase
        self.toggleUseCase = toggleUseCase
    }

    func deletePodcast(_ podcast: PodcastPersistenceModel) async {
        do {
            try await deleteModelUseCase.execute(podcast)
        } catch {
            print("Delete failed: \(error)")
        }
    }

    func wipeDatabase() async {
        do {
            try await deleteAllUseCase.execute()
        } catch {
            print("Delete all failed: \(error)")
        }
    }


    func toggleSaved(_ entity: PodcastEntity) async {
        do {
            try await toggleUseCase.execute(entity)
        } catch {
            print("❌ Toggle saved failed:", error)
        }
    }
}
