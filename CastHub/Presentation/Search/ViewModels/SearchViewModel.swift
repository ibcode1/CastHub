//
//  SearchViewModel.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 21/12/2025.
//

import Foundation
import Observation
import SwiftData

@MainActor
@Observable
final class SearchViewModel {

    // Step 1: Search text is bound to this variable
     var term = "" {
        didSet {
            // Step 2: Now that the search text has been set with a new value
            // (didSet) we want to fire off our search.
            debounceSearch()
        }
    }

    var podcasts: [PodcastEntity] = []
    var hasMorePodcasts = false
    var isLoading = false
    private(set) var currentOffset = 0
    private let pageSize = Config.batchSize
    var errorMessage: String?
    private let useCase: SearchUseCase

    private var trimmedQuery = ""
    private var searchTask: Task<Void, Never>?
    init(useCase: SearchUseCase) {
        self.useCase = useCase
    }

    func searchPodcast() async {
        // Step 7: Quick sanity check (more for subsequent searches) load more if needed (local)
      guard isLoading == false, hasMorePodcasts || currentOffset == 0 else { return }

        isLoading = true
        do {
            let results = try await useCase.execute(query: term, offset: currentOffset)
            podcasts += results.items
            currentOffset = results.nextOffset ?? (currentOffset + results.items.count)
            hasMorePodcasts = results.items.isEmpty == false
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func loadMoreIfNeeded(currentPodcast: PodcastEntity) async {
        guard let lastPodcast = podcasts.last,
              currentPodcast.id == lastPodcast.id,
              hasMorePodcasts,
              isLoading == false
        else { return }
        
        await searchPodcast()
    }

    func debounceSearch() {

        // Step 3: We want to ensure that the text entered is indeed a valid
        // search. We do not want to search under false pretences.
      trimmedQuery = term.trimmingCharacters(in: .whitespaces)
      guard trimmedQuery.isEmpty == false else { return }

        // Step 4: Cancel any previous searches
      cancelOngoingSearch()

        // Step 4.5: Clean up and remove any search results from prior searches
      resetPagination()

        // Step 5: We schedule our search
      scheduleSearch()
    }

    func cancelOngoingSearch() { searchTask?.cancel() }

    func scheduleSearch() {
        // Step 6: Define our task, add a slight delay and fetch
      searchTask = Task { @MainActor in
        try? await Task.sleep(for: .seconds(0.35)) // Temp pausing the search
        guard Task.isCancelled == false else { return }
        await searchPodcast()
      }
    }

    func resetPagination() {
      podcasts.removeAll()
      currentOffset = 0
      hasMorePodcasts = true
    }
}
