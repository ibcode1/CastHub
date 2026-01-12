//
//  PersistenceRepositoryImpl.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 30/12/2025.
//

import SwiftData
import SwiftUI

@MainActor
/// A concrete implementation of `PersistenceRepository` for managing podcast and episode persistence.
///
/// This class uses a `ModelContext` to perform CRUD operations on podcast and episode models,
/// including toggling the saved state, deleting individual entities, and deleting all entities.
/// It ensures changes are saved efficiently and supports asynchronous error handling.
final class PersistenceRepositoryImpl: PersistenceRepository {

    /// The underlying model context used for persistence operations.
    private let modelContext: ModelContext

    /// Initializes the repository with the given model context.
    ///
    /// - Parameter modelContext: The `ModelContext` used for all persistence operations.
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    /// Saves pending changes in the model context, if any.
    ///
    /// - Throws: An error if saving fails.
    func saveChanges() async throws {
        if modelContext.hasChanges {
            try modelContext.save()
        }
    }

    /// Deletes all podcast and episode models from persistent storage.
    ///
    /// - Throws: An error if deletion or saving fails.
    func deleteAll() async throws {
        try modelContext.delete(model: PodcastPersistenceModel.self)
        try modelContext.delete(model: EpisodePersistenceModel.self)
        try modelContext.save()
    }

    /// Deletes the specified persistent model object.
    ///
    /// - Parameter object: The object to delete, conforming to `PersistentModel`.
    /// - Throws: An error if deletion or saving fails.
    func delete(_ object: any PersistentModel) async throws {
        modelContext.delete(object)
        try await saveChanges()
    }

    /// Toggles the saved state of the given podcast entity in persistent storage.
    ///
    /// If the entity already exists, its saved state is toggled. If toggled to unsaved, it is deleted.
    /// If the entity does not exist, a new saved model is created and inserted.
    ///
    /// - Parameter entity: The `PodcastEntity` to toggle.
    /// - Throws: An error if fetching, inserting, deleting, or saving fails.
    func toggleSaved(_ entity: PodcastEntity) async throws {
        let id = entity.id
        // Try to find existing model
        let descriptor = FetchDescriptor<PodcastPersistenceModel>( predicate: #Predicate { $0.id == id } )
        let results = try modelContext.fetch(descriptor)
        if let model = results.first {
            // Toggle existing
            model.saved.toggle()

            if model.saved == false {
                modelContext.delete(model)
            }

            try modelContext.save()
            return
        }
        let new = PodcastPersistenceModel(
            id: entity.id,
            title: entity.censorName,
            feedUrl: entity.podcastFeedUrl,
            artworkUrl: entity.image?.absoluteString,
            saved: entity.saved)
        new.saved = true
        modelContext.insert(new)
        try modelContext.save()
    }
}
