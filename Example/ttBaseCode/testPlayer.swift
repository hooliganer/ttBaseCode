//
//  testPlayer.swift
//  ttBaseCode_Example
//
//  Created by 谭滔 on 2024-06-12.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import SwiftUI
import AVKit

@available(iOS 13.0, *)
#Preview {
    TTTPlayerView()
}

@available(iOS 13.0, *)
struct TTTPlayerView: View {
    @ObservedObject var playerManager = TTTPlayerManager.shared

    var body: some View {
        VStack {
            Image(systemName: "music.note")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 150)
                .padding()

            Text(playerManager.currentTrack)
                .font(.headline)
                .padding()

            Slider(value: $playerManager.currentTime, in: 0...playerManager.duration) { _ in
                playerManager.seek(to: playerManager.currentTime)
            }
            .padding()

            HStack {
                Button(action: previousTrack) {
                    Image(systemName: "backward.fill")
                        .font(.largeTitle)
                }
                .padding()

                Button(action: togglePlayPause) {
                    Image(systemName: playerManager.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.largeTitle)
                }
                .padding()

                Button(action: nextTrack) {
                    Image(systemName: "forward.fill")
                        .font(.largeTitle)
                }
                .padding()
            }
        }
    }

    private func previousTrack() {
        // Handle previous track logic
    }

    private func nextTrack() {
        // Handle next track logic
    }

    private func togglePlayPause() {
        if playerManager.isPlaying {
            playerManager.pause()
        } else {
            playerManager.resume()
        }
    }
}



@available(iOS 13.0, *)
class TTTPlayerManager: ObservableObject {
    static let shared = TTTPlayerManager()

    @Published var isPlaying: Bool = false
    @Published var currentTrack: String = ""
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0

    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var timeObserverToken: Any?

    private init() {}

    func play(track: String) {
        guard let url = URL(string: track) else { return }
        currentTrack = track
        playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        
        addPeriodicTimeObserver()
        
        player?.play()
        isPlaying = true
        if let duration = playerItem?.asset.duration {
            self.duration = CMTimeGetSeconds(duration)
        }
    }

    func pause() {
        player?.pause()
        isPlaying = false
    }

    func resume() {
        player?.play()
        isPlaying = true
    }

    func stop() {
        player?.pause()
        player = nil
        playerItem = nil
        isPlaying = false
        currentTime = 0
        duration = 0
    }

    func seek(to time: TimeInterval) {
        let cmTime = CMTime(seconds: time, preferredTimescale: 1)
        player?.seek(to: cmTime)
        currentTime = time
    }

    private func addPeriodicTimeObserver() {
        guard let player = player else { return }

        let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.currentTime = CMTimeGetSeconds(time)
        }
    }

    deinit {
        if let timeObserverToken = timeObserverToken {
            player?.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
}
