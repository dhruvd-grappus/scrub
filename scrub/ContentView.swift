//
//  ContentView.swift
//  scrub
//
//  Created by Dhruv on 08/05/24.
//

import AVKit
import Combine
import SwiftUI

class PlayerTimeObserver {
  let publisher = PassthroughSubject<TimeInterval, Never>()
  private var timeObservation: Any?

  init(player: AVPlayer) {

    timeObservation = player.addPeriodicTimeObserver(
      forInterval: CMTime(seconds: 0.5, preferredTimescale: 600), queue: nil
    ) { [weak self] time in
      guard let self = self else { return }
      // Publish the new player time
      self.publisher.send(time.seconds)
    }
  }
}
struct ContentView: View {
  let timeObserver: PlayerTimeObserver
  let player: AVPlayer

  @State var seekPos = 0.0
  @State var isPlaying = false
  @State var currentTime = 0.0
  @State var isSeeking = false
  @State private var totalDuration: Double?
  init() {
    self.player = AVPlayer(
      url: URL(
        string:
          "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4"
      )!)
    timeObserver = PlayerTimeObserver(player: self.player)
  }
    fileprivate func seekVideoForPosition(_ newValue: Double) {
        if isSeeking {
            if isPlaying {
                isPlaying = false
                player.pause()
                player.seek(
                    to: CMTimeMakeWithSeconds(
                        newValue * (player.currentItem?.duration.seconds ?? 0), preferredTimescale: 600)
                )
                isPlaying = true
                isSeeking = false
                player.play()
                
            } else {
                player.seek(
                    to: CMTimeMakeWithSeconds(
                        newValue * (player.currentItem?.duration.seconds ?? 0), preferredTimescale: 600)
                )
                isPlaying = true
                isSeeking = false
                player.play()
                if let currentItem = player.currentItem {
                    
                    if currentItem.duration.seconds > 1 && totalDuration == nil {
                        self.totalDuration = currentItem.duration.seconds
                        
                    }
                }
            }
            
        }
    }
    
    var body: some View {
    VStack {
      VideoPlayer(player: player)
        .disabled(true)
        .frame(height: 500)
        .onReceive(timeObserver.publisher) { time in
          self.currentTime = time

        }
        .onChange(of: currentTime) { oldTime, time in

          if !isSeeking {

            if totalDuration != nil {
                withAnimation {
                    self.seekPos = (time / (totalDuration!))
                }
            
              
            }

          }
        }
      Spacer().frame(height: 20)
      HStack {
        Image(systemName: isPlaying ? "pause" : "play")
              .resizable()
          .foregroundStyle(.white)
          .frame(width: 40,height: 40)
          .padding(.trailing,10)
          
          .onTapGesture {
            if player.timeControlStatus == .playing {
              isPlaying = false
              player.pause()
            } else {
              isPlaying = true
              player.play()
              if let currentItem = player.currentItem {

                if currentItem.duration.seconds > 1 && totalDuration == nil {
                  self.totalDuration = currentItem.duration.seconds

                }
              }
            }

          }
          SliderView3(value: $seekPos, isSeeking: $isSeeking, totalTime: $totalDuration, currentTime: $currentTime,placemarks: [200,531])
          .onChange(of: seekPos) { newValue in
              seekVideoForPosition(newValue)

          }
          .frame(width:600,height: 100)
          Image(systemName: "arrowshape.turn.up.backward.badge.clock.rtl")
              .resizable()
              .foregroundStyle(.white)
              .frame(width: 40,height: 40)
              .padding(.leading,10)
              .onTapGesture {
                  isSeeking = true
                  player.seek(to: CMTimeMakeWithSeconds(currentTime + 20, preferredTimescale: 100))
                 
                  if isPlaying {
                      isSeeking = false
                  }
                  isSeeking = false
              }
        Spacer().frame(height: 50)
      }
      .padding(.all, 25)

      .background {
        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/ 25.0 /*@END_MENU_TOKEN@*/)
          .foregroundColor(.gray)
      }

      .padding(.all, 25)

    }

    .ignoresSafeArea()

  }
}
extension Int {
    var secondsToTimeString : String {
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
struct SliderView3: View {
  @Binding var value: Double
  @Binding var isSeeking: Bool
    @Binding var totalTime: Double?
    @Binding var currentTime: Double
    var placemarks : [Int] = []
  @State var lastCoordinateValue: CGFloat = 0.0
  var sliderRange: ClosedRange<Double> = 0...1
  var thumbColor: Color = .yellow
  var minTrackColor: Color = .blue
  var maxTrackColor: Color = .gray

 
    let thumbWidth = 80.0
  var body: some View {
    GeometryReader { gr in

      
      let maxValue = (gr.size.width - thumbWidth)

     
      
        ZStack(alignment:.leading) {
        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/ 25.0 /*@END_MENU_TOKEN@*/)
          .foregroundColor(.white)
          .frame(width: gr.size.width, height: 10)
          .onTapGesture(count: 1) { location in

            // Perform an action based on tap location (optional)
              withAnimation {
                  self.value = location.x / gr.size.width
              }
          
            self.isSeeking = true
          }
          ZStack(alignment:.leading) {
            ForEach(placemarks,id:\.self) { p in
                Circle()
                    .foregroundColor(Color.red)
                    .frame(width: 20, height: 50)
                    .offset(x: Double(p)*(gr.size.width)/(totalTime ?? 1), y: -50)
                    .onTapGesture(count: 1) { location in
                        
                        withAnimation {
                            self.value = (Double(p) / (totalTime ?? 1)) + (5)/gr.size.width
                        }
                       
                        self.isSeeking = true
                       
                       
                    }
            }
         
          
        }

            HStack(spacing:0) {
                ZStack {
                    RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                    Text(Int(currentTime).secondsToTimeString)
                        .font(.system(size: 20))
                        .foregroundStyle(.black)
                }
                .foregroundColor(.white)
            .frame(width: thumbWidth, height: 40)
            .offset(x: value * maxValue)
            .gesture(
              DragGesture(minimumDistance: 0)
                .onChanged { v in
                  isSeeking = true
                  if abs(v.translation.width) < 0.1 {
                    self.lastCoordinateValue = value * maxValue
                  }
                  if v.translation.width > 0 {
                    let nextCoordinateValue = min(
                      maxValue, self.lastCoordinateValue + v.translation.width)
                    self.value = ((nextCoordinateValue) / maxValue)
                  } else {
                    let nextCoordinateValue = max(
                      0, self.lastCoordinateValue + v.translation.width)
                    self.value = ((nextCoordinateValue) / maxValue)
                  }
                }
                .onEnded({ _ in
                  isSeeking = false
                })
            )
          Spacer()
        }
      }
      .frame(height: 100)
    }
  }
}

#Preview {
  ContentView()
}
