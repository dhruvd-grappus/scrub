//
//  Player.swift
//  scrub
//
//  Created by Dhruv on 09/05/24.
//

import Foundation
import UIKit
import AVFoundation
import SwiftUI
struct MyView: UIViewControllerRepresentable {
    typealias UIViewControllerType = PlayerController
    
    func makeUIViewController(context: Context) -> PlayerController {
        let vc = PlayerController()
        // Do some configurations here if needed.
        return vc
    }
    
    func updateUIViewController(_ uiViewController: PlayerController, context: Context) {
        // Updates the state of the specified view controller with new information from SwiftUI.
    }
}
class PlayerController: UIViewController, AVPlayerItemMetadataOutputPushDelegate {
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPlayerLayer()
        
        let stream = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8")!
        //play(url: stream)
    }
    
    // MARK: - AVPlayerItemMetadataOutputPushDelegate
    
 
    
    // MARK: - Private
    
    private var playerLayer: AVPlayerLayer!
    private var player: AVPlayer!
    private var playerItem: AVPlayerItem!
    
 
    private func setUpPlayerLayer() {
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.bounds
        view.layer.addSublayer(playerLayer)
    }
}
