//
//  Home.swift
//  shrinkbot
//
//  Created by Ethan John on 9/29/19.
//  Copyright © 2019 Ethan John. All rights reserved.
//

import SwiftUI
import CoreHaptics
import Combine

struct Home: View {
    @State var showModal = false
    @ObservedObject var cardController: CardController
    @State var insightsState: InsightsState = .hidden
    @State var buttonExpanded: Bool = false
    @ObservedObject var graphState = GraphState()
    enum InsightsState {
        case hidden
        case loading
        case visible
    }
    let spacing: CGFloat = 20
    var body: some View {
        let binding = Binding(get: {
            self.buttonExpanded
        }) { newValue in
            self.buttonExpanded = newValue
            self.graphState.detailPopup = nil
        }
        return VStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: spacing) {
                    CardInfo(pickerInt: GraphRangeOptions.allCases.firstIndex(of: .today)!, cardController: CardController.shared, graphState: graphState, spacing: spacing)
                    InsightSegment(insightGenerator: InsightGenerator(), spacing: spacing)
                }
                .padding()
            }
            EntryButton(expanded: binding)
        }
    }
}
