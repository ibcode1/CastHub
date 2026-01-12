//
//  DeleteEpisodeUseCase.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 29/12/2025.
//

import Foundation
import SwiftData


/// A protocol that defines an asynchronous use case for deleting a specific persistent model.
///
/// Conforming types must implement logic to remove a given model object from persistent storage.
/// The operation is asynchronous and may throw errors if deletion fails.
protocol DeleteModelUseCase {
    /// Deletes the specified persistent model from storage.
    ///
    /// - Parameter model: The model object to delete, conforming to `PersistentModel`.
    /// - Throws: An error if deletion fails.
    func execute(_ model: any PersistentModel) async throws
}

/// A concrete implementation of `DeleteModelUseCase` that deletes a model using a persistence repository.
///
/// This use case encapsulates the logic for deleting a single persistent model
/// and invokes the `delete(_:)` method on the provided repository.
final class DeleteModelUseCaseImpl: DeleteModelUseCase {
    /// The repository responsible for deleting persistent models.
    private let repository: PersistenceRepository

    /// Initializes the use case with the given persistence repository.
    ///
    /// - Parameter repository: The repository used for deleting the model.
    init(repository: PersistenceRepository) {
        self.repository = repository
    }

    /// Executes the use case to delete the specified persistent model.
    ///
    /// - Parameter model: The model object to delete, conforming to `PersistentModel`.
    /// - Throws: An error if deletion fails.
    func execute(_ model: any PersistentModel) async throws {
        try await repository.delete(model)
    }
}
