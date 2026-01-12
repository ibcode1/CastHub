//
//  CustomProgressSlider.swift
//  PodcastHub
//
//  Created by Ibrahim fuseini on 08/11/2025.
//

import SwiftUI

struct CustomProgressSlider: View {
    // Current time in seconds (two-way bound)
    @Binding var progress: Double
    // Total duration in seconds
    let total: Double

    @Environment(PlayerViewModel.self) private var playerViewModel

    // Internal drag state for smooth UI while dragging
    @State private var isDragging = false
    @State private var dragProgress: Double = 0 // seconds

    // 0...1 value for layout
    private var normalizedProgress: Double {
        guard total > 0 else { return 0 }
        let value = isDragging ? dragProgress : progress
        return min(max(value / total, 0), 1)
    }

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width

            ZStack(alignment: .leading) {
                // Track
                Capsule()
                    .fill(Color.secondary.opacity(0.3))
                    .frame(height: 6)

                // Fill
                Capsule()
                    .fill(Color.white)
                    .frame(width: width * normalizedProgress, height: 6)

                // Thumb
                Circle()
                    .fill(Color.white)
                    .shadow(radius: 2)
                    .frame(width: 14, height: 14)
                    .offset(x: (width * normalizedProgress) - 7)
            }
            .contentShape(Rectangle()) // Make entire area interactive
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let clampedX = value.location.x.clamped(to: 0...width)
                        let newNormalized = (clampedX / max(width, 1)).clamped(to: 0...1)
                        let newSeconds = newNormalized * max(total, 0)

                        if isDragging == false {
                            isDragging = true
                            dragProgress = progress
                            // Tell the model to ignore periodic updates while scrubbing
                            playerViewModel.isUserScrubbing = true
                        }

                        dragProgress = newSeconds
                        // Live-update outward binding so any labels update as you drag
                        progress = newSeconds
                    }
                    .onEnded { value in
                        let clampedX = value.location.x.clamped(to: 0...width)
                        let newNormalized = (clampedX / max(width, 1)).clamped(to: 0...1)
                        let newSeconds = newNormalized * max(total, 0)

                        progress = newSeconds
                        dragProgress = newSeconds
                        isDragging = false

                        // Seek the AVPlayer and resume periodic updates
                        playerViewModel.seek(to: newSeconds)
                        playerViewModel.isUserScrubbing = false
                    }
            )
        }
        .frame(height: 28) // Ensure a comfortable touch area
    }
}

// Helper to clamp values
extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        min(max(self, limits.lowerBound), limits.upperBound)
    }
}
