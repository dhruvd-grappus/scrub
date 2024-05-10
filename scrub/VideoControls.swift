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

    func playORPause() {
        if videoVM.isPlaying {
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
    var body: some View {
        VStack(spacing: 0) {

            Spacer().frame(height: 15)
            VideoTimelineView(
                videoVM: videoVM,
                placemarks: [
                    Placemark(seconds: 500, icon: .moments),
                    Placemark(seconds: 560, icon: .moments),
                    Placemark(seconds: 300, icon: .wicketMoment),
                    Placemark(seconds: 800, icon: .wicketMoment),
                ]
            )
            .onChange(of: videoVM.seekPos) { newValue in
                seekVideoForPosition(newValue)

            }
            .padding(.trailing, 24)

            .frame(width: 888, height: 100)
            Spacer()
            ZStack {
                HStack(spacing: 0) {
                    HStack(spacing: 8) {
                        Text(Int(videoVM.currentTime).secondsToTimeString)
                            .inter(19)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                        Text(
                            "-\(Int((videoVM.totalDuration ?? 0) - videoVM.currentTime).secondsToTimeString)"
                        )
                        .inter(14)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .opacity(0.6)

                    }
                    .frame(width: 200, alignment: .leading)
                    Spacer()

                    HStack(spacing: 28) {
                        Image(.list)
                            .resizable()
                            .frame(width: 24, height: 24)
                        Image(.volumeUp)
                            .resizable()
                            .frame(width: 24, height: 24)
                    }

                }
                HStack(spacing: 28) {
                    Image(.fastForward)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .rotationEffect(.degrees(180))

                    ZStack {
                        if videoVM.isPlaying {
                            Image(.pause)
                                .resizable()
                        } else {
                            Image(systemName: "play")
                                .resizable()

                        }

                    }
                    .foregroundColor(.white)
                    .frame(width: 24, height: 24)
                    .onTapGesture {
                        playORPause()
                    }
                    Image(.fastForward)
                        .resizable()
                        .frame(width: 24, height: 24)
                }

            }

            .padding(.trailing, 15)
            .padding(.leading, 11)

        }
        .frame(width: 900, height: 170)
        .padding(.all, 15)

        .background {
            RoundedRectangle(
                cornerRadius: 20
            )
            .foregroundColor(.panelGray)
        }
        .onReceive(videoVM.timeObserver.publisher) { time in
            videoVM.currentTime = time

        }

        .onChange(of: videoVM.currentTime) { oldTime, time in

            if !videoVM.isSeeking {

                if videoVM.totalDuration != nil {
                    withAnimation {
                        videoVM.seekPos = (time / (videoVM.totalDuration!))
                    }

                }

            }
        }
        .padding(.all, 25)

    }
}

#Preview {
    VideoControls(videoVM: VideoPlayerVM(player: AVPlayer()))
}
