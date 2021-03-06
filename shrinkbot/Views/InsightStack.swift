//
//  InsightStack.swift
//  shrinkbot
//
//  Created by Ethan John on 2/6/20.
//  Copyright © 2020 Ethan John. All rights reserved.
//

import Foundation
import SwiftUI

struct InsightStack: View {
    @Binding var insights: [Insight]
    let spacing: CGFloat
    func transition(delay: Int) -> AnyTransition {
        let animation = Animation.shrinkbotSpring().delay(0.1 * Double(delay))
        let scale = AnyTransition.scale.animation(animation)
        return AnyTransition.opacity.combined(with: scale).animation(animation)
    }
    var body: some View {
        VStack(spacing: spacing) {
            ForEach(insights.indices, id: \.self) { index in
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color("Standard"))
                        .frame(height: 100)
                    VStack {
                        HStack {
                            Text(self.insights[index].title)
                                .defaultFont(16, weight: .bold)
                            Spacer()
                            Text(String(format: "%.2f", self.insights[index].score))
                                .foregroundColor(Color("Highlight").opacity(0.3))
                                .defaultFont(16, weight: .bold)
                        }
                        Divider()
                        Text(self.insights[index].description)
                            .defaultFont(15, weight: .regular)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                }
                .transition(self.transition(delay: index))
            }
        }
    }
}
