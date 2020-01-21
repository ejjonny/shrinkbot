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
    @ObservedObject var insightGenerator: InsightGenerator = InsightGenerator()
    @EnvironmentObject var buttonState: ButtonState
    @State var insightsState: InsightsState = .hidden
    enum InsightsState {
        case hidden
        case loading
        case visible
    }
    let spacing: CGFloat = 20
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: spacing) {
                    CardInfo(pickerInt: GraphRangeOptions.allCases.firstIndex(of: .today)!, cardController: CardController.shared, spacing: spacing)
                    ZStack {
                        Button(action: {
                            self.insightsState = .loading
                            self.insightGenerator.generate { _ in
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4) {
//                                    self.insightsState = .visible
                                }
                            }
                        }) {
                            ZStack {
                                Circle()
                                    .foregroundColor(Color("LowContrast"))
                                Image(systemName: "questionmark")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding(30)
                            }
                            .frame(width: 100, height: 100)
                        }
                        .foregroundColor(Color("Highlight"))
                        .opacity(insightsState == .hidden ? 1 : 0)
                        ZStack {
                            Circle()
                                .foregroundColor(Color("LowContrast"))
                            Circle()
                                .trim(from: 0, to: insightsState == .loading ? 1 : 0)
                                .stroke(Color("Standard"), style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round, miterLimit: 1, dash: [], dashPhase: 0))
                                .animation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: true))
                            .rotationEffect(Angle(degrees: insightsState == .loading ? 360 : 0))
                                .animation(Animation.linear(duration: 0.75).repeatForever(autoreverses: false))
                            Image(systemName: "questionmark")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(30)
                                .opacity(insightsState == .loading ? 0.25 : 1)
                                .rotationEffect(Angle(degrees: insightsState == .loading ? 10 : -10))
                                .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true))
                        }
                        .frame(width: 100, height: 100)
                        .opacity(insightsState == .loading ? 1 : 0)
                        .animation(.default)
                    }
                }
                .padding()
            }
            VStack {
                Spacer()
                EntryButton()
            }
            .frame(alignment: .bottom)
        }
    }
}

class ButtonState: ObservableObject {
    @Published var open: Bool = false
    @Published var selection: Rating?
}
