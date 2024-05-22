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

struct Placemark {
    let seconds: Double
    let icon: ImageResource
    init(seconds: Double, icon: ImageResource) {
        self.seconds = seconds
        self.icon = icon
    }
}
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

    var placemarks: [Placemark] = []
    @State var lastCoordinateValue: CGFloat = 0.0
    var sliderRange: ClosedRange<Double> = 0...1
    var thumbColor: Color = .yellow
    var minTrackColor: Color = .blue
    var maxTrackColor: Color = .gray

    let thumbWidth = 41.0

    var body: some View {
        GeometryReader { gr in

            let maxValue = (gr.size.width - thumbWidth)

            ZStack(alignment: .leading) {
                ZStack(alignment: .leading) {
                    RoundedRectangle(
                        cornerRadius:
                            25.0
                    )
                    .foregroundColor(.white.opacity(0.4))
                    RoundedRectangle(
                        cornerRadius:
                            25.0
                    )
                    .foregroundColor(.white)
                    .frame(width: videoVM.seekPos * maxValue)

                }
                .frame(width: gr.size.width, height: 8)
                .onTapGesture(count: 1) { location in

                    // Perform an action based on tap location (optional)
                    withAnimation {
                        videoVM.seekPos = location.x / gr.size.width
                    }

                    videoVM.isSeeking = true
                }

                ZStack(alignment: .leading) {
                    ForEach(placemarks, id: \.seconds) { p in
                        Image(p.icon)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .offset(
                                x: Double(p.seconds) * (gr.size.width)
                                    / (videoVM.totalDuration ?? 1),
                                y: -35
                            )
                            .onTapGesture(count: 1) { location in

                                withAnimation {
                                    videoVM.seekPos =
                                        (Double(p.seconds)
                                            / (videoVM.totalDuration ?? 1))
                                        + (5)
                                        / gr.size.width
                                }

                                videoVM.isSeeking = true

                            }
                    }

                }

                HStack(spacing: 0) {

                    RoundedRectangle(
                        cornerRadius: /*@START_MENU_TOKEN@*/
                            25.0 /*@END_MENU_TOKEN@*/
                    )

                    .foregroundColor(.white)
                    .frame(width: thumbWidth, height: 23)
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
            .padding(.top, 35)
            .padding(.all, 13)

            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.black.opacity(0.2))
            }
            .frame(height: 84)
        }
    }
}
