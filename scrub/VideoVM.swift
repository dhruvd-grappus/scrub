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
    let timeObserver: PlayerTimeObserver
    init(urls: [String] = []) {
        self.urls = urls
        if urls.isEmpty {
            self.player = AVPlayer()
        } else {

            self.player = AVPlayer(url: URL(string: urls.first!)!)

        }
        self.timeObserver = PlayerTimeObserver(player: self.player)
    }
    @Published var currentURLIndex = 0
    @Published var urls: [String] = []
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
