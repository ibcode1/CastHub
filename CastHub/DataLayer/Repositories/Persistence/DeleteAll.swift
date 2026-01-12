//
//  DeleteAll.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 31/12/2025.
//


/// A protocol that defines an asynchronous method for deleting all items from persistent storage.
///
/// Conforming types must implement logic to remove all relevant model objects from storage.
/// The operation is asynchronous and may throw errors if the deletion fails.
protocol DeleteAll {
    /// Deletes all items from persistent storage.
    ///
    /// - Throws: An error if any item cannot be deleted or if the deletion process fails.
    func deleteAll() async throws
}
