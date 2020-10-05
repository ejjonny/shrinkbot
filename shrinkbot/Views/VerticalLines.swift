//
//  VerticalLines.swift
//  shrinkbot
//
//  Created by Ethan John on 2/6/20.
//  Copyright © 2020 Ethan John. All rights reserved.
//

import Foundation
import SwiftUI

struct VerticalLines: View {
    let graphPadding: CGFloat
    let xOffset: (Int, CGFloat) -> CGFloat
    let indices: Range<Int>
    var body: some View {
        GeometryReader { proxy in
            ForEach(self.indices, id: \.self) { index in
                ZStack {
                    Rectangle()
                        .foregroundColor(Color("Standard").opacity(0.6))
                        .frame(width: 1, height: proxy.size.height - self.graphPadding)
                        .position(
                            x: self.xOffset(index, proxy.size.width),
                            y: (self.graphPadding / 2) + ((proxy.size.height - self.graphPadding) / 2)
                    )
                }
            }
        }
    }
}
