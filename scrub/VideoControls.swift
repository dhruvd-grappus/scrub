//
//  VideoControls.swift
//  scrub
//
//  Created by Dhruv on 08/05/24.
//

import AVKit
import Combine
import SwiftUI

struct VideoControls: View {
    @ObservedObject var videoVM: VideoPlayerVM
    fileprivate func seekVideoForPosition(_ newValue: Double) {
        if videoVM.isSeeking {
            if videoVM.isPlaying {
                videoVM.isPlaying = false
                videoVM.player.pause()
                videoVM.player.seek(
                    to: CMTimeMakeWithSeconds(
                        newValue
                            * (videoVM.player.currentItem?.duration.seconds ?? 0),
                        preferredTimescale: 600
                    )
                )
                videoVM.isPlaying = true
                videoVM.isSeeking = false
                videoVM.player.play()

            } else {
                videoVM.player.seek(
                    to: CMTimeMakeWithSeconds(
                        newValue
                            * (videoVM.player.currentItem?.duration.seconds ?? 0),
                        preferredTimescale: 600
                    )
                )
                videoVM.isPlaying = true
                videoVM.isSeeking = false
                videoVM.player.play()
                if let currentItem = videoVM.player.currentItem {

                    if currentItem.duration.seconds > 1
                        && videoVM.totalDuration == nil
                    {
                        videoVM.totalDuration = currentItem.duration.seconds

                    }
                }
            }

        }
    }
    var body: some View {
        HStack {
            Image(systemName: videoVM.isPlaying ? "pause" : "play")
                .resizable()
                .foregroundStyle(.white)
                .frame(width: 40, height: 40)
                .padding(.trailing, 10)

                .onTapGesture {
                    if videoVM.player.timeControlStatus == .playing {
                        videoVM.isPlaying = false
                        videoVM.player.pause()
                    } else {
                        videoVM.isPlaying = true
                        videoVM.player.play()
                        if let currentItem = videoVM.player.currentItem {

                            if currentItem.duration.seconds > 1
                                && videoVM.totalDuration == nil
                            {
                                videoVM.totalDuration =
                                    currentItem.duration.seconds

                            }
                        }
                    }

                }
            VideoTimelineView(
                videoVM: videoVM,
                placemarks: [200, 531]
            )
            .onChange(of: videoVM.seekPos) { newValue in
                seekVideoForPosition(newValue)

            }
            .frame(width: 600, height: 100)
            Image(systemName: "arrowshape.turn.up.backward.badge.clock.rtl")
                .resizable()
                .foregroundStyle(.white)
                .frame(width: 40, height: 40)
                .padding(.leading, 10)
                .onTapGesture {
                    videoVM.isSeeking = true
                    videoVM.player.seek(
                        to: CMTimeMakeWithSeconds(
                            videoVM.currentTime + 20,
                            preferredTimescale: 100
                        )
                    )

                    if videoVM.isPlaying {
                        videoVM.isSeeking = false
                    }
                    videoVM.isSeeking = false
                }
            Spacer().frame(height: 50)
        }
        .padding(.all, 25)

        .background {
            RoundedRectangle(
                cornerRadius: /*@START_MENU_TOKEN@*/ 25.0 /*@END_MENU_TOKEN@*/
            )
            .foregroundColor(.gray)
        }
        .onReceive(videoVM.timeObserver.publisher) { time in
            videoVM.currentTime = time

        }
        .onChange(of: videoVM.currentTime) { oldTime, time in

            if !videoVM.isSeeking {

                if videoVM.totalDuration != nil {
                    print(videoVM.totalDuration)
                    withAnimation {
                        videoVM.seekPos = (time / (videoVM.totalDuration!))
                    }

                }

            }
        }
        .padding(.all, 25)
    }
}

//#Preview {
//    VideoControls()
//}
