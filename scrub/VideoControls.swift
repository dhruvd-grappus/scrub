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
    var body: some View {
        VStack(spacing:0) {
       
         
            Spacer().frame(height: 30)
            VideoTimelineView(
                videoVM: videoVM,
                placemarks: [10, 20]
            )
            .onChange(of: videoVM.seekPos) { newValue in
                seekVideoForPosition(newValue)

            }
            .padding(.trailing,24)
          
            .frame(width:888, height: 100)
           Spacer()
           
        }
        .frame(width: 900,height: 170)
        .padding(.all,12)

        .background {
            RoundedRectangle(
                cornerRadius: /*@START_MENU_TOKEN@*/ 25.0 /*@END_MENU_TOKEN@*/
            )
            .foregroundColor(.panelGray)
        }
        .onReceive(videoVM.timeObserver.publisher) { time in
            videoVM.currentTime = time

        }
        .onAppear() {
            videoVM.totalDuration = 60
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

