//
//  PlayerViewModel.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 28/12/2025.
//

import Foundation
import AVKit

@MainActor
@Observable
// PlayerViewModel manages audio playback using AVPlayer.
// Responsibilities:
// - Manage selected episode and AVPlayer item
// - Control play/pause/seek, skip forward/back
// - Track current time and formatted time string
// - Observe player time to keep UI in sync
// - Maintain per-episode resume positions
// - Navigate between episodes (next/previous)
final class PlayerViewModel {

    // High-level playback status driving UI state.
    var playbackStatus: PlaybackStatus = .empty

    // The currently selected episode.
    // When changed, this triggers a check to update/replace the AVPlayerItem
    // and attempts to resume from any saved position.
    var selectedEpisode: EpisodeEntity? {
        didSet { changeEpisodeIfNecessary() }
    }

    // Current playback time in seconds and its formatted display string.
    // These are updated by periodic time observation and seek completions.
    var currentTime: Double = 0.0
    var currentTimeString: String = "--:--:--"

    // All episodes used for next/previous navigation.
    var allEpisodes: [EpisodeEntity] = []

    // Potentially intended for UI display (e.g., "x of y"); currently unused.
    private var episdodeCount: String?

    // When true, time updates are suppressed to avoid UI jitter during scrubbing.
    var isUserScrubbing: Bool = false

    // Per-episode saved positions keyed by episodeID to resume playback.
    var resumePosition: [String: CMTime] = [:]

    // Token for AVPlayer periodic time observer; used to remove observer on cleanup.
    private var timeObserverToken: Any?

    // Underlying AVPlayer instance for audio playback.
    var player: AVPlayer = {
        let player = AVPlayer()
        return player
    }()

    // Remove any installed time observer to prevent leaks or callbacks after deinit.
    func cleanup() {
        if let token = timeObserverToken {
            player.removeTimeObserver(token)
            timeObserverToken = nil
        }
    }

    // A formatted duration string for the current item.
    // Returns placeholder when duration is not available/invalid.
    var totalDurationString: String {
        guard let duration = player.currentItem?.duration.seconds, !duration.isNaN, !duration.isInfinite else {
            return "--:--:--"
        }
        return CMTime(seconds: duration, preferredTimescale: CMTimeScale(NSEC_PER_SEC)).toDisplayString
    }

    // Play or resume the selected episode.
    // - Replaces the current AVPlayerItem if missing or referring to a different asset.
    // - If a saved resume position exists for this episode, seeks to it before playing.
    // - Otherwise, starts playback from the beginning/current position.
    func playEpisode() {
        guard let selectedEpisode,
              let episodeAudioURL = selectedEpisode.episodeAudioUrl
        else { return }

        let newItem = AVPlayerItem(url: episodeAudioURL)

        // If there is no item or it's a different asset, replace it
        if let currentItem = player.currentItem {
            if currentItem.asset.isEqual(newItem.asset) == false {
                replaceCurrentItem(with: newItem)
            }
        } else {
            replaceCurrentItem(with: newItem)
        }

        // Attempt to resume from saved position (if valid and >= 0).
        if let saved = resumePosition[selectedEpisode.episodeID], saved.isValid && saved >= .zero {
            player.seek(to: saved, toleranceBefore: .zero, toleranceAfter: .zero) { [weak self] _ in
                Task { @MainActor in
                    self?.startPlayerAndUpdateState()
                }
            }
        } else {
            startPlayerAndUpdateState()
        }
    }

    // Pause playback and store the current position for the selected episode.
    // Also updates the current time properties and sets the status to paused.
    func pauseEpisode() {
        guard let selectedEpisode else { return }

        let t = player.currentTime()
        if t.isValid && t >= .zero {
            resumePosition[selectedEpisode.episodeID] = t
        }

        player.pause()
        updateCurrentTime() // Sync currentTime/currentTimeString with the latest paused time.
        playbackStatus = .paused(episode: selectedEpisode, progress: Float(currentTime))
    }

    // Install a periodic time observer to keep current time properties in sync with the player.
    // Removes any existing observer before adding a new one.
    func observePlayerCurrentTime() {
        // Remove any existing observer before adding a new one
        if let token = timeObserverToken {
            player.removeTimeObserver(token)
            timeObserverToken = nil
        }

        // Update every 1 second on the main queue to ensure UI consistency.
        let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] _ in
            Task { @MainActor in
                self?.updateCurrentTime()
            }
        }
    }

    // Fast-forward by 15 seconds, clamped so as not to exceed total episode duration.
    // Uses episode metadata length rather than AVPlayerItem duration.
    func fastForwardFifteenSeconds() {
        guard let selectedEpisode else { return }

        let fifteenSeconds = CMTime(seconds: 15, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let currentTime = player.currentTime()

        let episodeTotalTimeInt = selectedEpisode.episodeAudioLength
        let episodeTotalTime: Double = Double(episodeTotalTimeInt)

        let seekTime = CMTimeAdd(currentTime, fifteenSeconds)

        // Only seek forward if there’s enough time left in the episode
        guard episodeTotalTime > seekTime.seconds else { return }

        player.seek(to: seekTime, toleranceBefore: .zero, toleranceAfter: .zero) { [weak self] _ in
            Task { @MainActor in
            self?.updateCurrentTime()
        }
    }
}

    // Rewind by 15 seconds, clamping to zero to avoid negative times.
    func rewindFifteenSeconds() {
        guard selectedEpisode != nil else { return }

        let fifteenSeconds = CMTime(seconds: -15, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let currentTime = player.currentTime()
        var seekTime = CMTimeAdd(currentTime, fifteenSeconds)

        // Clamp to zero
        if seekTime < .zero {
            seekTime = .zero
        }

        player.seek(to: seekTime, toleranceBefore: .zero, toleranceAfter: .zero) { [weak self] _ in
            Task { @MainActor in
                self?.updateCurrentTime()
            }
        }
    }

    // Update currentTime and currentTimeString from the player's current time,
    // unless the user is actively scrubbing.
    func updateCurrentTime() {
        if isUserScrubbing { return }

        let playerCurrentTime = player.currentTime()
        currentTime = playerCurrentTime.seconds
        currentTimeString = playerCurrentTime.toDisplayString
    }

    // Seek to a target time in seconds, clamped to the valid duration range.
    // If duration is not available/invalid, seeks to zero instead.
    func seek(to seconds: Double) {
        let durationSeconds = player.currentItem?.duration.seconds ?? .zero
        guard durationSeconds.isFinite, durationSeconds > 0 else {
            // No Valid duration; set to zero
            player.seek(to: .zero, toleranceBefore: .zero, toleranceAfter: .zero) { [weak self] _ in
                Task { @MainActor in
                    self?.updateCurrentTime()
                }
            }
            return
        }
        let clamped = max(0, min(seconds, durationSeconds))
        let target = CMTime(seconds: clamped, preferredTimescale: CMTimeScale(NSEC_PER_SEC))

        player.seek(to: target, toleranceBefore: .zero, toleranceAfter: .zero) { [weak self] _ in
            // Once seek finishes, update the model time.
            Task { @MainActor in
                self?.updateCurrentTime()
            }
        }
    }

    // Ensure the player's current item matches the newly selected episode.
    // If needed, replace the item, reset current time display, and attempt to resume from saved position.
    // Otherwise, start playback from the beginning.
    func changeEpisodeIfNecessary() {
        guard let selectedEpisode,
              let url = selectedEpisode.episodeAudioUrl else {
            playbackStatus = .empty
            player.pause()
            player.replaceCurrentItem(with: nil)
            return
        }

        let newItem = AVPlayerItem(url: url)

        // Determine whether we need to replace the current item based on underlying asset equality.
        let shouldReplace = player.currentItem?.asset.isEqual(newItem.asset) != true

        if shouldReplace {
            replaceCurrentItem(with: newItem)
            currentTime = 0.0
            updateCurrentTime()
        }

        // Always try to restore saved position for this episode (by ID).
        if let saved = resumePosition[selectedEpisode.episodeID],
           saved.isValid && saved >= .zero {
            player.seek(to: saved) { [weak self] _ in
                Task { @MainActor in
                    self?.player.play()
                    self?.playbackStatus = .playing(episode: selectedEpisode, progress: Float(saved.seconds))
                }
            }
        } else {
            player.play()
            playbackStatus = .playing(episode: selectedEpisode, progress: 0)
        }
    }

    // Advance to the next episode in allEpisodes, wrapping around at the end.
    // Updates selectedEpisode, which triggers changeEpisodeIfNecessary().
    func playNextEpisode() {
            guard !allEpisodes.isEmpty, let currentEpisode = selectedEpisode else {
                print("⚠️ No episodes or no selected episode to move from")
                return
            }

            // Find the current index
            if let currentIndex = allEpisodes.firstIndex(where: { $0.episodeID == currentEpisode.episodeID }) {
                let nextIndex = (currentIndex + 1) % allEpisodes.count  // Loops back to 0 after last
                let nextEpisode = allEpisodes[nextIndex]

                // Update selectedEpisode to trigger changeEpisodeIfNecessary
                selectedEpisode = nextEpisode
                print("▶️ Switched to next episode: \(nextEpisode.episodeTitle)")
            } else {
                print("⚠️ Current episode not found in allEpisodes")
            }
        }

        // Move to the previous episode in allEpisodes, wrapping to the last when at index 0.
        // Note: Using (currentIndex - 1) % count can yield a negative index in Swift.
        // Consider (currentIndex - 1 + count) % count if you later decide to adjust behavior.
        func playPreviousEpisode() {
            guard !allEpisodes.isEmpty, let currentEpisode = selectedEpisode else {
                print("⚠️ No episodes or no selected episode to move from")
                return
            }

            // Find the current index
            if let currentIndex = allEpisodes.firstIndex(where: { $0.episodeID == currentEpisode.episodeID }) {
                let previousIndex = (currentIndex - 1) % allEpisodes.count  // Loops to last when at 0 (beware negative modulo)
                let previousEpisode = allEpisodes[previousIndex]

                // Update selectedEpisode to trigger changeEpisodeIfNecessary
                selectedEpisode = previousEpisode
                print("▶️ Switched to next episode: \(previousEpisode.episodeTitle)")
            } else {
                print("⚠️ Current episode not found in allEpisodes")
            }
        }

    // MARK: - Helpers

    // Replace the player's current item safely and reinstall the periodic time observer.
    private func replaceCurrentItem(with item: AVPlayerItem?) {
        player.pause()
        player.replaceCurrentItem(with: item)
        observePlayerCurrentTime()
    }

    // Start playback and update playbackStatus based on whether a selected episode exists.
    private func startPlayerAndUpdateState() {
        player.play()
        if let ep = selectedEpisode {
            playbackStatus = .playing(episode: ep, progress: Float(currentTime))
        } else {
            playbackStatus = .empty
        }
    }

    // Ensure cleanup occurs on deallocation (removes time observer).
    // `isolated` implies concurrency isolation for safe deinitialization.
    isolated deinit {
        cleanup()
    }
}

// High-level playback states used to drive UI and logic.
enum PlaybackStatus {
    case empty
    case idle(episodes: [EpisodeEntity])
    case playing(episode: EpisodeEntity, progress: Float)
    case paused(episode: EpisodeEntity, progress: Float)
    case finish(episode: [EpisodeEntity])
}
