//
//  Utils.swift
//  scrub
//
//  Created by Dhruv on 08/05/24.
//

import Foundation
import SwiftUI

extension Color {

    public static func random(randomOpacity: Bool = false) -> Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            opacity: randomOpacity ? .random(in: 0...1) : 1
        )
    }
}
