//
//  TogglePodcastSavedUseCase.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 01/01/2026.
//


/// A protocol that defines an asynchronous use case for toggling the saved state of a podcast entity.
///
/// Conforming types must implement logic to update the saved/unsaved state of a given `PodcastEntity` in storage.
/// The operation is asynchronous and may throw errors if the update fails.
protocol ToggleSavedUseCase {
    /// Toggles the saved state of the specified podcast entity.
    ///
    /// - Parameter entity: The `PodcastEntity` whose saved state should be toggled.
    /// - Throws: An error if the toggle operation fails.
    func execute(_ entity: PodcastEntity) async throws
}

/// A concrete implementation of `ToggleSavedUseCase` that toggles a podcast's saved state using a persistence repository.
///
/// This use case encapsulates the logic for toggling the saved/unsaved state of a podcast entity
/// and invokes the `toggleSaved(_:)` method on the provided repository.
final class ToggleSavedImpl: ToggleSavedUseCase {
    /// The repository responsible for toggling the saved state of podcast entities.
    private let repository: PersistenceRepository

    /// Initializes the use case with the given persistence repository.
    ///
    /// - Parameter repository: The repository used to toggle the saved state.
    init(repository: PersistenceRepository) {
        self.repository = repository
    }

    /// Executes the use case to toggle the saved state of the specified podcast entity.
    ///
    /// - Parameter entity: The `PodcastEntity` whose saved state should be toggled.
    /// - Throws: An error if the toggle operation fails.
    func execute(_ entity: PodcastEntity) async throws {
        try await repository.toggleSaved(entity)
    }
}
