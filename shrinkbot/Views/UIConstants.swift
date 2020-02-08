//
//  UIConstants.swift
//  shrinkbot
//
//  Created by Ethan John on 2/8/20.
//  Copyright © 2020 Ethan John. All rights reserved.
//

import SwiftUI

struct ShrinkFont: ViewModifier {
    let size: CGFloat
    let weight: Font.Weight
    init(size: CGFloat, weight: Font.Weight) {
        self.size = size
        self.weight = weight
    }
    func body(content: Content) -> some View {
        return content
            .font(.system(size: size, weight: weight, design: .rounded))
    }
}

extension View {
    func defaultFont(_ size: CGFloat = 13, weight: Font.Weight = .medium) -> some View {
        self.modifier(ShrinkFont(size: size, weight: weight))
    }
}

extension Animation {
    static func shrinkbotSpring() -> Animation {
        Animation.spring(dampingFraction: 0.5)
            .speed(3)
    }
}
