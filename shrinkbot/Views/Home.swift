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
    @EnvironmentObject var buttonState: ButtonState
    @State var insightsState: InsightsState = .hidden
    enum InsightsState {
        case hidden
        case loading
        case visible
    }
    let spacing: CGFloat = 20
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: spacing) {
                    CardInfo(pickerInt: GraphRangeOptions.allCases.firstIndex(of: .today)!, cardController: CardController.shared, spacing: spacing)
                    InsightSegment(insightGenerator: MockInsightGenerator(), spacing: spacing)
                }
                .padding()
            }
            EntryButton()
        }
    }
}

class ButtonState: ObservableObject {
    @Published var open: Bool = false
    @Published var selection: Rating?
}
