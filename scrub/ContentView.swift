//
//  ContentView.swift
//  scrub
//
//  Created by Dhruv on 08/05/24.
//

import SwiftUI
import AVKit
import Combine

class PlayerTimeObserver {
    let publisher = PassthroughSubject<TimeInterval, Never>()
    private var timeObservation: Any?
    
    init(player: AVPlayer) {
        // Periodically observe the player's current time, whilst playing
        timeObservation = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 600), queue: nil) { [weak self] time in
            guard let self = self else { return }
            // Publish the new player time
            self.publisher.send(time.seconds)
        }
    }
}
struct ContentView: View {
    let timeObserver: PlayerTimeObserver
 let player : AVPlayer
    
    @State var seekPos = 0.0
    @State var isPlaying = false
    @State var currentTime = 0.0
    @State var isSeeking = false
    @State private var totalDuration: Double?
    init() {
        self.player = AVPlayer(url:  URL(string:"https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4")!)
        timeObserver = PlayerTimeObserver(player: self.player)
    }
    var body: some View {
        VStack {
            VideoPlayer(player: player )
                .disabled(true)
                
                .onReceive(timeObserver.publisher) { time in
                    self.currentTime = time
                    
                    
                   
                }
                .onChange(of: currentTime) { oldTime,time in
                   
                    if !isSeeking {
                       
                            if totalDuration != nil {
                                self.seekPos = (time / (totalDuration!))
                                print(seekPos)
                            }
                            
                            
                        
                    }
                }
            Spacer().frame(height: 20)
            HStack {
                Image(systemName:isPlaying ? "pause" : "play")
                    .foregroundStyle(.white)
                    .onTapGesture {
                        if player.timeControlStatus == .playing {
                            isPlaying = false
                            player.pause()
                        }
                        else  {
                            isPlaying = true
                            player.play()
                            if let currentItem = player.currentItem {
                                
                                if currentItem.duration.seconds > 1 && totalDuration == nil{
                                    self.totalDuration = currentItem.duration.seconds
                                    
                                   
                                }
                            }
                        }
                      
                    }
                SliderView3( value: $seekPos, isSeeking: $isSeeking)
                       .onChange(of: seekPos) { newValue in
                           if isSeeking {
                               if isPlaying {
                                   isPlaying = false
                                   player.pause()
                                   player.seek(to: CMTimeMakeWithSeconds(newValue * (player.currentItem?.duration.seconds ?? 0), preferredTimescale: 600))
                                   isPlaying = true
                                   player.play()
                                   
                               }
                               else {
                                   isPlaying = true
                                   player.play()
                                   if let currentItem = player.currentItem {
                                       
                                       if currentItem.duration.seconds > 1 && totalDuration == nil{
                                           self.totalDuration = currentItem.duration.seconds
                                           
                                           
                                       }
                                   }
                               }
                                   
                           }
                        
                          
                          
                       }
                       .frame(width: 700)
                       
            
                
                Spacer().frame(height: 50)
            }
            .padding(.all,25)
            .frame(height: 100)
            .background() {
                RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
            }
            
            .padding(.all,25)
            Spacer().frame(height: 300)
            
        }
        
       
    }
}

struct SliderView3: View {
    @Binding var value: Double
    @Binding var isSeeking : Bool
    @State var lastCoordinateValue: CGFloat = 0.0
    var sliderRange: ClosedRange<Double> = 0...1
    var thumbColor: Color = .yellow
    var minTrackColor: Color = .blue
    var maxTrackColor: Color = .gray
    
    var body: some View {
        GeometryReader { gr in
            let thumbHeight = gr.size.height * 1.1
            let thumbWidth = gr.size.width * 0.03
            let radius = gr.size.height * 0.5
            let minValue = gr.size.width * 0.015
            let maxValue = (gr.size.width * 0.98) - thumbWidth
            
            let scaleFactor = (maxValue - minValue) / (sliderRange.upperBound - sliderRange.lowerBound)
            let lower = sliderRange.lowerBound
            let sliderVal = (self.value - lower) * scaleFactor + minValue
            
            ZStack {
                RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.white)
                    .frame(width: gr.size.width, height: 10)
                   
                
                HStack {
                    Circle()
                        .foregroundColor(thumbColor)
                        .frame(width: 30, height: 50)
                        .offset(x: sliderVal - 10)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { v in
                                    isSeeking = true
                                    if (abs(v.translation.width) < 0.1) {
                                        self.lastCoordinateValue = sliderVal
                                    }
                                    if v.translation.width > 0 {
                                        let nextCoordinateValue = min(maxValue, self.lastCoordinateValue + v.translation.width)
                                        self.value = ((nextCoordinateValue - minValue) / scaleFactor)  + lower
                                    } else {
                                        let nextCoordinateValue = max(minValue, self.lastCoordinateValue + v.translation.width)
                                        self.value = ((nextCoordinateValue - minValue) / scaleFactor) + lower
                                    }
                                }
                                .onEnded({ _ in
                                    isSeeking = false
                                })
                        )
                    Spacer()
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
