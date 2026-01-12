//
//  Save.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 31/12/2025.
//

import Foundation


/// A protocol that defines an asynchronous method for toggling the saved state of a podcast entity.
///
/// Conforming types must implement logic to add or remove a `PodcastEntity` from a saved state in persistent storage.
/// The operation is asynchronous and may throw errors if the process fails.
protocol Save {
    /// Toggles the saved state of the given podcast entity.
    ///
    /// - Parameter entity: The `PodcastEntity` whose saved state should be toggled.
    /// - Throws: An error if the toggle operation fails or cannot be completed.
    func toggleSaved(_ entity: PodcastEntity) async throws
}
