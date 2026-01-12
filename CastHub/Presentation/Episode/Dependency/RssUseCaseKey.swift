//
//  AppDependencies.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 24/12/2025.
//

import Foundation
import Observation
import SwiftUI

// EnvironmentKeys.swift or any file
private struct RssUseCaseKey: EnvironmentKey {
    static let defaultValue: (any RssFeedUseCase)? = nil  // Optional, no fatalError
}

extension EnvironmentValues {
    var rssUseCase: any RssFeedUseCase {
        get { self[RssUseCaseKey.self] ?? DummyRssUseCase() }  // Fallback to dummy
        set { self[RssUseCaseKey.self] = newValue }
    }
}

// Minimal dummy that prevents crashes in previews/uninjected cases
private class DummyRssUseCase: RssFeedUseCase {
    func execute(feedURL: String) async throws -> [EpisodeEntity] {
        // Return empty result — safe for previews
        return []
    }
}
