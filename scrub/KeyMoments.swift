//
//  KeyMoments.swift
//  scrub
//
//  Created by Dhruv on 10/05/24.
//

import SwiftUI
import AVFoundation

struct KeyMoments: View {
  
    
    @ObservedObject var videoVM : VideoPlayerVM
    var body: some View {
        VStack(alignment:.leading,spacing:9) {
            Text("Key Moments")
                .inter(14)
                .fontWeight(.semibold)
                .lineSpacing(24)
                .foregroundStyle(.white)
                .frame(height: 24)
               
            Spacer().frame(height: 0)
            ForEach(0..<videoVM.urls.count,id: \.self) { index in
                ZStack {
                    Image(.thumbnail)
                        .resizable()
                    
                        .clipShape(.rect(cornerRadius: 10))
                        .overlay() {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(LinearGradient(
                                    gradient: .init(colors: [.black.opacity(0), .black.opacity(0.6)]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                ))
                                .stroke(Color.white, lineWidth: 1)
                            
                        }
                    HStack(spacing:4) {
                        Image(index == videoVM.currentURLIndex && videoVM.isPlaying ? .playing : .play)
                            .resizable()
                        
                            .frame(width: 24, height: 24)
                        
                        Text("Fall of wickets")
                            .inter(12)
                            .foregroundColor(.white)
                    }
                   
                }
                
                    
                    .frame(height: 114)
                    .onTapGesture {
                        
                        videoVM.totalDuration = nil
                        let avAsset = AVAsset(url: URL(string:videoVM.urls[index])!)
                        Task {
                            videoVM.totalDuration = (try? await avAsset.load(.duration))?.seconds
                            videoVM.currentURLIndex = index
                            let playerItem: AVPlayerItem = AVPlayerItem(asset: avAsset)
                            
                            videoVM.player.replaceCurrentItem(with: playerItem)
                            videoVM.player.play()
                            
                            videoVM.isPlaying = true
                        }
                       
                    }
                    
                
            }
           
        }
        .padding(.all,13)
        .frame(width: 196)
    }
}

#Preview {
    ZStack {
        Color.black
        KeyMoments(videoVM: VideoPlayerVM(urls: ["https://videos.pexels.com/video-files/9712579/9712579-sd_640_360_30fps.mp4"]))
    }
    
}
