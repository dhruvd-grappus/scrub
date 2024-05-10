//
//  VideoTimelineView.swift
//  scrub
//
//  Created by Dhruv on 08/05/24.
//

import AVKit
import Combine
import Foundation
import SwiftUI

extension Int {
    var secondsToTimeString: String {
        var seconds = self
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        seconds = (seconds % 3600) % 60

        var timeComponents = [String]()
        if hours > 0 {
            timeComponents.append(String(hours))
        }
        if minutes > 0 || !timeComponents.isEmpty {
            timeComponents.append(String(minutes))  // Pad minutes with leading zero only if needed
        }
        timeComponents.append(String(seconds))

        return timeComponents.joined(separator: ":")
    }
}
struct VideoTimelineView: View {
    @ObservedObject var videoVM: VideoPlayerVM

    var placemarks: [Int] = []
    @State var lastCoordinateValue: CGFloat = 0.0
    var sliderRange: ClosedRange<Double> = 0...1
    var thumbColor: Color = .yellow
    var minTrackColor: Color = .blue
    var maxTrackColor: Color = .gray

    let thumbWidth = 80.0

    var body: some View {
        GeometryReader { gr in

            let maxValue = (gr.size.width - thumbWidth)

            ZStack(alignment: .leading) {
                RoundedRectangle(
                    cornerRadius: /*@START_MENU_TOKEN@*/
                        25.0 /*@END_MENU_TOKEN@*/
                )
                .foregroundColor(.white)
                .frame(width: gr.size.width, height: 10)
                .onTapGesture(count: 1) { location in

                    // Perform an action based on tap location (optional)
                    withAnimation {
                        videoVM.seekPos = location.x / gr.size.width
                    }

                    videoVM.isSeeking = true
                }
                ZStack(alignment: .leading) {
                    ForEach(placemarks, id: \.self) { p in
                        Image(.moments)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .offset(
                                x: Double(p) * (gr.size.width)
                                    / (videoVM.totalDuration ?? 1),
                                y: -50
                            )
                            .onTapGesture(count: 1) { location in

                                withAnimation {
                                    videoVM.seekPos =
                                        (Double(p)
                                            / (videoVM.totalDuration ?? 1))
                                        + (5)
                                        / gr.size.width
                                }

                                videoVM.isSeeking = true

                            }
                    }

                }

                HStack(spacing: 0) {
                    ZStack {
                        RoundedRectangle(
                            cornerRadius: /*@START_MENU_TOKEN@*/
                                25.0 /*@END_MENU_TOKEN@*/
                        )
                        Text(Int(videoVM.currentTime).secondsToTimeString)
                            .font(.system(size: 20))
                            .foregroundStyle(.black)
                    }
                    .foregroundColor(.white)
                    .frame(width: thumbWidth, height: 40)
                    .offset(x: videoVM.seekPos * maxValue)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { v in
                                videoVM.isSeeking = true
                                if abs(v.translation.width) < 0.1 {
                                    self.lastCoordinateValue =
                                        videoVM.seekPos * maxValue
                                }
                                if v.translation.width > 0 {
                                    let nextCoordinateValue = min(
                                        maxValue,
                                        self.lastCoordinateValue
                                            + v.translation.width
                                    )
                                    videoVM.seekPos =
                                        ((nextCoordinateValue) / maxValue)
                                } else {
                                    let nextCoordinateValue = max(
                                        0,
                                        self.lastCoordinateValue
                                            + v.translation.width
                                    )
                                    videoVM.seekPos =
                                        ((nextCoordinateValue) / maxValue)
                                }
                            }
                            .onEnded({ _ in
                                videoVM.isSeeking = false
                            })
                    )
                    
                }
            }
            .padding(.top,48)
            .padding(.all,11)
            
            .fixedSize()
            .background() {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.black.opacity(0.2))
            }
            .frame(height: 84)
        }
    }
}
