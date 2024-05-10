//
//  TextStyles.swift
//  scrub
//
//  Created by Dhruv on 10/05/24.
//

import SwiftUI

enum FontStyles: String {
    case inter = "Inter"
}

extension View {

    func inter(_ size: Double) -> some View {
        return font(.custom(FontStyles.inter.rawValue, size: size))
    }
}
