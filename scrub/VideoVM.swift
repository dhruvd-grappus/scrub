//
//  VideoVM.swift
//  scrub
//
//  Created by Dhruv on 08/05/24.
//
import AVKit
import Combine
import Foundation
import SwiftUI

class VideoPlayerVM: ObservableObject {
    let player: AVPlayer
    let items: [AVPlayerItem]
    let timeObserver: PlayerTimeObserver
    init(player: AVPlayer,items : [AVPlayerItem]) {
        self.player = AVPlayer(playerItem: items.first)
        self.timeObserver = PlayerTimeObserver(player: self.player)
        self.items = items
    }
    @Published var currentItemIndex = 0
    @Published var seekPos = 0.0
    @Published var isPlaying = false
    @Published var currentTime = 0.0
    @Published var isSeeking = false
    @Published var totalDuration: Double?

}
class PlayerTimeObserver {
    let publisher = PassthroughSubject<TimeInterval, Never>()
    private var timeObservation: Any?

    init(player: AVPlayer) {

        timeObservation = player.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 0.5, preferredTimescale: 600),
            queue: nil
        ) { [weak self] time in
            guard let self = self else { return }
            // Publish the new player time
            self.publisher.send(time.seconds)
        }
    }
}
