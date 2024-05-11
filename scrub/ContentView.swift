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

struct ContentView: View {

    @StateObject var videoVM = VideoPlayerVM(
        player: AVPlayer(
            url: URL(
                string:
                    "https://apple-hls-demo.s3.ap-south-1.amazonaws.com/v1/moon/output/moon_1920_1080test-name.m3u8"
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
        .onAppear {
            Task {
                videoVM.play(
                    url: URL(
                        string:
                            "https://apple-hls-demo.s3.ap-south-1.amazonaws.com/v1/fifa/output/sample_1080test-name.m3u8"
                    )!
                )
            }

        }
        .ignoresSafeArea()

    }
}

#Preview {
    ContentView()
}
