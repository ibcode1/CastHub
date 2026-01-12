//
//  SaveEpisodeUseCase.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 29/12/2025.
//

import Foundation
import SwiftData

/// A protocol that defines an asynchronous use case for deleting all persistent items.
///
/// Conforming types must implement logic to remove all relevant objects from persistent storage.
/// The operation is asynchronous and may throw errors if deletion fails.
protocol DeleteAllUseCase {
    /// Deletes all items from persistent storage.
    ///
    /// - Throws: An error if deletion fails.
    func execute() async throws
}

/// A concrete implementation of `DeleteAllUseCase` that deletes all items using a persistence repository.
///
/// This use case encapsulates the logic for bulk deleting persistent items
/// and invokes the `deleteAll()` method on the provided repository.
final class DeleteAllUseCaseImpl: DeleteAllUseCase {
    /// The repository responsible for deleting persistent items.
    private let repository: PersistenceRepository

    /// Initializes the use case with the given persistence repository.
    ///
    /// - Parameter repository: The repository used for deleting all persistent items.
    init(repository: PersistenceRepository) {
        self.repository = repository
    }

    /// Executes the use case to delete all persistent items.
    ///
    /// - Throws: An error if deletion fails.
    func execute() async throws {
        try await repository.deleteAll()
    }
}
