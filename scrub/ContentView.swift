//
//  ContentView.swift
//  scrub
//
//  Created by Dhruv on 08/05/24.
//

import AVKit
import Combine
import SwiftUI
let vid2 = "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4"

let vid1 = "https://cdn.pixabay.com/video/2024/03/01/202587-918431513_large.mp4"

struct ContentView: View {

    @StateObject var videoVM = VideoPlayerVM(
        player: AVPlayer(
            url: URL(
                string:
                    "c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4"
            )!
        ), items: [AVPlayerItem(url: URL(string:vid1)!),AVPlayerItem(url: URL(string:vid2)!)]
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
            
           
        }

        .ignoresSafeArea()

    }
}

#Preview {
    ContentView()
}
