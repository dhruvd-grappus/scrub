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
    static var urls = ["https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4","https://videos.pexels.com/video-files/6950555/6950555-sd_640_360_25fps.mp4","https://videos.pexels.com/video-files/19757074/19757074-sd_640_360_30fps.mp4","https://videos.pexels.com/video-files/20184664/20184664-sd_640_360_30fps.mp4","https://videos.pexels.com/video-files/9712579/9712579-sd_640_360_30fps.mp4"]
    @StateObject var videoVM = VideoPlayerVM(
      urls: urls
    )
    init() {

    }

    var body: some View {
        HStack(spacing:20) {
            VStack {
                VideoPlayer(player: videoVM.player)
                    .disabled(true)
                    .frame(width: 900, height: 500)

                Spacer().frame(height: 20)
                VideoControls(videoVM: videoVM)

            }
            VStack {
                Spacer().frame(height: 20)
                KeyMoments(videoVM: videoVM).background() {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.panelGray)
                }
                Spacer()
            }
            

            .ignoresSafeArea()
        }

    }
}

#Preview {
    ContentView()
}
