//
//  PodcastRepository.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 30/12/2025.
//

import Foundation
import SwiftData

/// A protocol that combines saving, deleting, and bulk deletion operations for persistent storage.
///
/// Any type conforming to `PersistenceRepository` must provide implementations for:
/// - Toggling the saved state of entities (`Save`)
/// - Deleting individual entities (`Delete`)
/// - Deleting all entities (`DeleteAll`)
protocol PersistenceRepository: Save, Delete, DeleteAll {}
