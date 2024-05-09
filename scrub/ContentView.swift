//
//  ContentView.swift
//  scrub
//
//  Created by Dhruv on 08/05/24.
//

import AVKit
import Combine
import SwiftUI
import UIKit
struct ContentView: View{

    @StateObject var videoVM = VideoPlayerVM(
        player: AVPlayer(
            url: URL(
                string:
                    "https://db2.indexcom.com/bucket/ram/00/05/05.m3u8"
            )!
        )
    )
    
    init() {

    }

    var body: some View {
        VStack {
            VideoPlayer(player: videoVM.player)
                .disabled(true)
                .frame(height: 500)

            Spacer().frame(height: 20)
            VideoControls(videoVM: videoVM)

        }
        .onAppear() {
            Task {
                   videoVM.play(url: URL(string:"https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8")!)
            }
          
           
        }
        .ignoresSafeArea()

    }
}

#Preview {
    ContentView()
}
