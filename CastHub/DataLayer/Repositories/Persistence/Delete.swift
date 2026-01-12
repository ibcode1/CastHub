//
//  Delete.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 31/12/2025.
//

import SwiftData

/// A protocol that defines an asynchronous method for deleting persistent model objects.
///
/// Conforming types must implement logic to remove any object conforming
/// to `PersistentModel` from persistent storage. The operation is asynchronous
/// and may throw errors related to the deletion process.
protocol Delete {
    /// Deletes the given object from persistent storage.
    ///
    /// - Parameter object: The model object to be deleted, conforming to `PersistentModel`.
    /// - Throws: An error if the deletion fails.
    func delete(_ object: any PersistentModel) async throws
}
