//
//  HorizontalLines.swift
//  shrinkbot
//
//  Created by Ethan John on 2/6/20.
//  Copyright © 2020 Ethan John. All rights reserved.
//

import Foundation
import SwiftUI

struct HorizontalLines: View {
    let graphPadding: CGFloat
    let yOffset: (CGFloat, Double) -> CGFloat
    let range: Int
    var body: some View {
        GeometryReader { proxy in
            ForEach(0..<self.range, id: \.self) { index in
                ZStack {
                    Rectangle()
                        .foregroundColor(Color("Standard").opacity(0.6))
                        .frame(width: proxy.size.width - self.graphPadding, height: 1)
                        .position(
                            x: (self.graphPadding / 2) + ((proxy.size.width - self.graphPadding) / 2),
                            y: self.yOffset(proxy.size.height, Double(index))
                    )
                }
            }
        }
    }
}
