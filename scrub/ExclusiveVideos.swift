import SwiftUI

//
//  ExclusiveVideos.swift
//  scrub
//
//  Created by Dhruv on 22/05/24.
//
// D9D9D9D9
// TODO: Change to Hex
let gray = Color(red: 0.85, green: 0.85, blue: 0.85)

struct ExclusiveVideos: View {

    var body: some View {
        VStack(spacing: 20) {
            VideoTypeSelector()
            ZStack(alignment: .bottom) {
                ScrollView(showsIndicators: false) {
                    LazyVGrid(
                        columns: [
                            GridItem(
                                .flexible(),
                                spacing: 6
                            ),
                            GridItem(
                                .flexible(),
                                spacing: 6
                            ),
                        ],
                        spacing: 21
                    ) {
                        ForEach(0..<10) { _ in
                            ExclusiveVideo()
                        }
                    }

                }
                LinearGradient(
                    stops: [

                        Gradient.Stop(color: gray, location: 0.00),

                        Gradient.Stop(color: gray.opacity(0.5), location: 0.00),

                        Gradient.Stop(color: gray.opacity(0.3), location: 0.00),

                    ],
                    startPoint: UnitPoint(x: 0, y: 1),
                    endPoint: UnitPoint(x: 0, y: 0)
                )
                .frame(height: 50, alignment: .bottom)
                .offset(y: 10)
                .blur(radius: 14)

            }
            .padding(.horizontal, 15)

        }
        .frame(width: 466, height: 760)

    }
}
private struct VideoTypeSelector: View {
    @State var type = "BTS Videos"
    var types = ["BTS Videos", "Interview Bytes"]
    var body: some View {

        HStack(spacing: 0) {
            ForEach(types, id: \.self) { type in
                // TODO: CHange font
                HStack {
                    Spacer()
                    Text(type)
                        .font(
                            Font.custom("SF Pro", size: 15)
                                .weight(.semibold)
                        )
                        .multilineTextAlignment(.center)

                        .foregroundColor(.white.opacity(0.96))
                        .padding(.vertical, 8)

                    Spacer()
                }
                .background {
                    RoundedRectangle(cornerRadius: 14)

                        .foregroundStyle(
                            self.type == type
                                ? (Color(red: 0.37, green: 0.37, blue: 0.37)
                                    .opacity(0.18)) : .clear
                        )

                }
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)

                .onTapGesture {
                    withAnimation {
                        self.type = type
                    }

                }

            }

        }
        .padding(.all, 4)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(.black.opacity(0.1))

                RoundedRectangle(cornerRadius: 15)

                    .stroke(Color.white.opacity(0.1))
                    .shadow(
                        color: Color.white.opacity(0.1),
                        radius: 3,
                        x: 1,
                        y: 1.5
                    )
            }

        )

        .frame(width: 418, height: 44)
        .padding(.horizontal, 9)

    }
}
struct ExclusiveVideo: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                Image(.thumbnail)
                    .resizable()

                    .clipShape(.rect(cornerRadius: 12.9))

                HStack(spacing: 4) {
                    // TODO: Change Icon
                    Image(.play)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.white)

                    Text("Now Playing")
                        .font(
                            Font.custom("SF Pro", size: 13.07143)
                                .weight(.bold)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white.opacity(0.96))
                }
                VStack {
                    HStack {
                        Spacer()
                        // TODO: Change font here
                        Text("03:21")
                            .font(
                                Font.custom("SF Pro", size: 10.45714)
                                    .weight(.medium)
                            )
                            .multilineTextAlignment(.trailing)
                            .padding(.vertical, 2.61)
                            .padding(.horizontal, 3.49)
                            .foregroundColor(.white.opacity(0.96))
                            .background(.black.opacity(0.6))
                            .cornerRadius(2.61429)
                            .padding(.top, 6.1)
                            .padding(.trailing, 7.84)
                    }
                    Spacer()
                }

            }
            .frame(width: 212, height: 127)
            .padding(.bottom, 12)

            // TODO: Change fonts to custom
            Text("The Oz Mindset")
                .font(
                    Font.custom("SF Pro", size: 18)
                        .weight(.bold)
                )
                .foregroundColor(.white.opacity(0.8))
                .padding(.bottom, 6.58)
            Text("The Goliaths of tou...")
                .font(
                    Font.custom("SF Pro", size: 15)
                        .weight(.semibold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(.white.opacity(0.96))
                .opacity(0.6)
        }
    }
}

#Preview {
    ZStack {
        Color.gray
        ExclusiveVideos()
    }

}
