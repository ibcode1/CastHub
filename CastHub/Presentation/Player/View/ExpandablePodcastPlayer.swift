//
//  ExpandablePodcastPlayer.swift
//  PodcastHub
//
//  Created by Ibrahim fuseini on 30/01/2025.
//

import SwiftUI
import AVKit
import Observation
import IbToolKit

struct ExpandablePodcastPlayer: View {
    @Binding var show: Bool
    @Binding var hideMiniPlayer: Bool
    /// View Properties
    @State private var expandPlayer: Bool = false
    @State private var offsetY: CGFloat = 0
    @State private var mainWindow: UIWindow?
    @State private var windowProgress: CGFloat = 0
    @State private var episodeContent: String?

    @Namespace private var animation

    @Environment(PlayerViewModel.self) private var playerViewModel: PlayerViewModel

    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            let cornerRadius: CGFloat = safeArea.bottom == 0 ? 0 : 45

            ZStack(alignment: .top) {
                /// Background
                Color.black.opacity(expandPlayer ? 0.8 : 0.1)
                    .ignoresSafeArea()
                    .allowsHitTesting(expandPlayer)
                ZStack {
                    Rectangle()
                        .fill(.gray)

                    Rectangle()
                        .fill(.linearGradient(colors: [.blue, .mint, .green], startPoint: .top, endPoint: .bottom))
                        .opacity(expandPlayer ? 1 : 0)
                }
                .clipShape(.rect(cornerRadius: expandPlayer ? cornerRadius : 15))
                .frame(height: expandPlayer ? nil : 55)
                /// Shadows
                .shadow(color: .primary.opacity(0.06), radius: 5, x: 5, y: 5)
                .shadow(color: .primary.opacity(0.05), radius: 5, x: -5, y: -5)

                MiniPlayer()
                    .opacity(expandPlayer ? 0 : 1)

                ExpandedPlayer(size, safeArea)
                    .opacity(expandPlayer ? 1 : 0)
            }
            .frame(height: expandPlayer ? nil : 55, alignment: .top)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, expandPlayer ? 0 : safeArea.bottom + 55)
            .padding(.horizontal, expandPlayer ? 0 : 15)
            .offset(y: offsetY)
            .gesture(
                PanGesture { value in
                    guard expandPlayer else { return }

                    let translation = max(value.translation.height, 0)
                    offsetY = translation
                    windowProgress = max(min(translation / size.height, 1), 0) * 0.1

                    resizeWindow(0.1 - windowProgress)
                } onEnd: { value in
                    guard expandPlayer else { return }

                    let translation = max(value.translation.height, 0)
                    let velocity = value.velocity.height / 5

                    withAnimation(.smooth(duration: 0.3, extraBounce: 0)) {
                        if (translation + velocity) > (size.height * 0.5) {
                            /// Closing View
                            expandPlayer = false
                            windowProgress = 0
                            /// Resetting Window To Identity With Animation
                            resetWindowWithAnimation()
                        } else {
                            /// Reset Window To 0.1 With Animation
                            UIView.animate(withDuration: 0.3) {
                                resizeWindow(0.1)
                            }
                        }

                        offsetY = 0
                    }
                }
            )
            .offset(y: hideMiniPlayer && !expandPlayer ? safeArea.bottom + 200 : 0)
            .ignoresSafeArea()
        }
        .onAppear {
            if let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow, mainWindow == nil {
                mainWindow = window
            }
        }
        .onAppear(perform: playerViewModel.playEpisode)

        .task(id: playerViewModel.selectedEpisode?.episodeID) {
            await loadEpisodeContent()
        }
    }

    func loadEpisodeContent() async {
        episodeContent = await playerViewModel.selectedEpisode?.episodeContent.htmlStripped()
    }

    /// Mini Player
    @ViewBuilder
    func MiniPlayer() -> some View {
        HStack(spacing: 12) {
            ZStack {
                if !expandPlayer {
                    AsyncImage(url: playerViewModel.selectedEpisode?.image) { image in
                        image.resizable()
                    } placeholder: {
                        ZStack {
                            //Color(.secondarySystemBackground)
                            //ProgressView()
                            CustomImgUtils()
                        }
                        
                    }
                    .clipShape(.rect(cornerRadius: 8.0))
                    .matchedGeometryEffect(id: playerViewModel.selectedEpisode?.imageUrl, in: animation)
                }
            }
            .frame(width: 45, height: 45)

            if let episodeTitle = playerViewModel.selectedEpisode?.episodeTitle {
                Text(episodeTitle)
            }

            Spacer(minLength: 0)

            Group {
                Button {
                    switch playerViewModel.player.timeControlStatus {

                    case .paused: playerViewModel.playEpisode()

                    case .playing: playerViewModel.pauseEpisode()

                    case .waitingToPlayAtSpecifiedRate: break
                    @unknown default: break
                    }
                } label: {
                    switch playerViewModel.playbackStatus {
                    case .empty: Image(systemName: "pause.fill")
                    case .idle: EmptyView()
                    case .playing: Image(systemName: "pause.fill")
                    case .paused: Image(systemName: "play.fill")
                    case .finish: EmptyView()
                    }
                }

                Button { playerViewModel.fastForwardFifteenSeconds() } label: { // fastforward 15 seconds
                    Image(systemName: "forward.fill")
                }
            }
            .font(.title3)
            .foregroundStyle(Color.primary)
        }
        .padding(.horizontal, 10)
        .frame(height: 55)
        .contentShape(.rect)
        .onTapGesture {
            withAnimation(.smooth(duration: 0.3, extraBounce: 0)) {
                expandPlayer = true
            }

            /// Reszing Window When Opening Player
            UIView.animate(withDuration: 0.3) {
                resizeWindow(0.1)
            }
        }
    }

    /// Expanded Player
    @ViewBuilder
    func ExpandedPlayer(_ size: CGSize, _ safeArea: EdgeInsets) -> some View {
        VStack(spacing: .zero) {
            Capsule()
                .fill(.white.secondary)
                .frame(width: 35, height: 5)
                .offset(y: -10)
                .padding(15)
                .padding(.top, safeArea.top)

            VStack(spacing: 128.0) {
                /// Episode image
                ZStack {
                    if expandPlayer {
                        AsyncImage(url: playerViewModel.selectedEpisode?.image) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(minWidth: .zero, maxWidth: .infinity, minHeight: .zero, maxHeight: 256)
                        } placeholder: {
                            ZStack {
                                //Color(.secondarySystemBackground)
                                //ProgressView()
                                CustomImgUtils()
                            }
                        }
                        .matchedGeometryEffect(id: playerViewModel.selectedEpisode?.episodeID, in: animation)
                        .transition(.offset(y: 1))
                    }
                }
                .frame(minWidth: .zero, maxWidth: .infinity, minHeight: .zero, maxHeight: 256)
                .clipShape(.rect(cornerRadius: 8.0))

                /// Episode Details
                VStack(spacing: 24.0) {
                    // Title and description
                    VStack(spacing: 2) {
                        if let episodeTitle = playerViewModel.selectedEpisode?.episodeTitle {
                            Text(episodeTitle)
                                .ibFont(.captionBold)
                                .foregroundStyle(.white)
                        }

                        if let episodeContent = episodeContent {
                            Text(episodeContent)
                                .ibFont(.bodyLight)
                                .foregroundStyle(.white)
                                .lineLimit(4)
                        }
                    }

                    // Action buttons
                    HStack(spacing: 12.0) {
                        Button { playerViewModel.playPreviousEpisode() } label: {
                            Image(systemName: "backward.end.fill") }
                        .foregroundStyle(.white)

                        Button { playerViewModel.rewindFifteenSeconds() } label: {
                            Image(systemName: "backward.fill")}
                        .foregroundStyle(.white)

                        Button {
                            switch playerViewModel.player.timeControlStatus {
                            case .paused: playerViewModel.playEpisode()
                            case .playing: playerViewModel.pauseEpisode()
                            case .waitingToPlayAtSpecifiedRate: break
                            @unknown default: break
                            }
                        } label: {
                            switch playerViewModel.playbackStatus {
                            case .empty: Image(systemName: "pause.fill")
                            case .idle: EmptyView()
                            case .playing: Image(systemName: "pause.fill")
                            case .paused: Image(systemName: "play.fill")
                            case .finish: EmptyView()
                            }
                        }
                        .foregroundStyle(.white)

                        Button { playerViewModel.fastForwardFifteenSeconds() } label: {Image(systemName: "forward.fill")}
                            .foregroundStyle(.white)

                        Button { playerViewModel.playNextEpisode() } label: { Image(systemName: "forward.end.fill") }
                            .foregroundStyle(.white)
                    }

                    HStack {
                        Text(playerViewModel.currentTimeString)
                            .ibFont(.captionBold)

                        Spacer()

                        Text(playerViewModel.totalDurationString)
                            .ibFont(.captionBold)
                    }
                    .foregroundStyle(.white)

                    CustomProgressSlider(
                        progress: Binding(
                            get: { playerViewModel.currentTime },
                            set: { playerViewModel.currentTime = $0 }),
                        total: Double(playerViewModel.selectedEpisode?.episodeAudioLength ?? .zero ))

                    Spacer()
                }
                .padding(.horizontal, 15)
            }
            .frame(maxHeight: .infinity)
        }
        .background {
            
            // Background image with blur effect
            AsyncImage(url: playerViewModel.selectedEpisode?.image) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .blur(radius: 50)
                    .overlay(Color.black.opacity(0.4)) // Add darkness for better text readability
            } placeholder: {
                Color.clear
            }
            .ignoresSafeArea()
        }
    }

    func resizeWindow(_ progress: CGFloat) {
        if let mainWindow = mainWindow?.subviews.first {
            let offsetY = (mainWindow.frame.height * progress) / 2

            /// Your Custom Corner Radius
            mainWindow.layer.cornerRadius = (progress / 0.1) * 30
            mainWindow.layer.masksToBounds = true

            mainWindow.transform = .identity.scaledBy(x: 1 - progress, y: 1 - progress).translatedBy(x: 0, y: offsetY)
        }
    }

    func resetWindowWithAnimation() {
        if let mainWindow = mainWindow?.subviews.first {
            UIView.animate(withDuration: 0.3) {
                mainWindow.layer.cornerRadius = 0
                mainWindow.transform = .identity
            }
        }
    }
}



#Preview {
    RootView {
        ExpandablePodcastPlayer(show: .constant(true), hideMiniPlayer: .constant(false))
            .environment(PlayerViewModel())
            .environment(UniversalOverlayProperties())
    }
}
