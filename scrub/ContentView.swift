//
//  ContentView.swift
//  scrub
//
//  Created by Dhruv on 08/05/24.
//

import AVKit
import Combine
import SwiftUI

struct ContentView: View {

    @StateObject var videoVM = VideoPlayerVM(
        player: AVPlayer(
            url: URL(
                string:
                    "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4"
            )!
        )
    )
    init() {

    }

    var body: some View {
        VStack {
            VideoPlayer(player: videoVM.player)
                .disabled(true)
                .frame(width: 900, height: 500)

            Spacer().frame(height: 20)
            VideoControls(videoVM: videoVM)

        }

        .ignoresSafeArea()

    }
}

#Preview {
    ContentView()
}
