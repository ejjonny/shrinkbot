//
//  InsightStack.swift
//  shrinkbot
//
//  Created by Ethan John on 10/8/19.
//  Copyright © 2019 Ethan John. All rights reserved.
//

import SwiftUI

struct InsightStack: View {
    var spacing: CGFloat = 10
    @State var insights: [Insight] = [Insight]()
    @ObservedObject var cardController: CardController
    var body: some View {
        VStack(spacing: spacing) {
            ForEach(insights.indices, id: \.self) { index in
                Rectangle()
            }
        }
        .onAppear {
            self.loadInsights()
        }
    }
    func loadInsights() {
        InsightGenerator().generate { insights in
            self.insights = insights
        }
    }
}
