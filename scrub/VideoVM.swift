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

class VideoPlayerVM: NSObject, ObservableObject, AVPlayerItemMetadataOutputPushDelegate {
    let player: AVPlayer
    let timeObserver: PlayerTimeObserver
    init(player: AVPlayer) {
        self.player = player
        self.timeObserver = PlayerTimeObserver(player: self.player)
    }
    @Published var seekPos = 0.0
    @Published var isPlaying = false
    @Published var currentTime = 0.0
    @Published var isSeeking = false
    @Published var totalDuration: Double?
    
    var metadataCollector: AVPlayerItemMetadataCollector!
    
    
     func play(url: URL?) {
         let url = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8")!
        
        let asset = AVAsset(url: url)
        
        var playerItem = AVPlayerItem(asset: asset)
        
         player.replaceCurrentItem(with: playerItem)
        let metadataOutput = AVPlayerItemMetadataOutput(identifiers: nil)
        metadataOutput.setDelegate(self, queue: DispatchQueue.main)
        playerItem.add(metadataOutput)
        
      
        player.play()
    }
    
    
    func metadataOutput(_ output: AVPlayerItemMetadataOutput, didOutputTimedMetadataGroups groups: [AVTimedMetadataGroup], from track: AVPlayerItemTrack?) {
        
        if let item = groups.first?.items.first
        {
            item.value(forKeyPath: #keyPath(AVMetadataItem.value))
            let metadataValue = (item.value(forKeyPath: #keyPath(AVMetadataItem.value))!)
           print(metadataValue)
        } else {
            print("MetaData Error")
        }
    }

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


