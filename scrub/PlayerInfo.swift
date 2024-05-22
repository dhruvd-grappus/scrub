//
//  PlayerInfo.swift
//  scrub
//
//  Created by Dhruv on 11/05/24.
//

import SwiftUI

struct PlayerInfo: View {

    func metric(title: String, value: String) -> some View {
        return VStack(spacing: 5) {
            Text(title.uppercased())
                .font(
                    Font.custom("Inter", size: 12)
                        .weight(.medium)
                )
                .kerning(0.48)
                .foregroundColor(.white)
                .opacity(0.4)
                .fixedSize()

            Text(value)
                .font(
                    Font.custom("Inter", size: 14)
                        .weight(.medium)
                )
                .kerning(0.56)
                .foregroundColor(.white)
        }
        .frame(width: 80, height: 35)
    }
    var body: some View {
        VStack(spacing: 0) {
            Image(.player)
                .resizable()
                .frame(height: 332)

            HStack {
                Text("Virat Kohli")
                    .inter(19)
                    .fontWeight(.bold)
                Spacer()
                Text("18")
                    .inter(19)
                    .fontWeight(.medium)
                    .opacity(0.6)
            }
            .padding(.top, 13)
            HStack {

                Text("Right Hand Bat | IND")
                    .font(
                        Font.custom("Inter", size: 19)
                            .weight(.medium)
                    )
                    .foregroundColor(.white)
                    .opacity(0.7)
                Spacer()
            }
            .padding(.top, 8)

            VStack(spacing: 24) {
                HStack(spacing: 24) {
                    metric(title: "innings", value: "178")
                    metric(title: "Runs", value: "18")
                    metric(title: "Average", value: "178")
                }
                HStack(spacing: 24) {
                    metric(title: "Strike rate", value: "17.8")
                    metric(title: "50s", value: "1000")
                    metric(title: "Best", value: "500")
                }
            }
            .padding(.horizontal, 7)
            .padding(.vertical, 10)
            .background(.black.opacity(0.2))
            .cornerRadius(12)
            .padding(.top, 17)
        }
        .foregroundColor(.white)
        .frame(width: 302)

    }
}

#Preview {
    ZStack {
        Color.black
        PlayerInfo()
    }

}
