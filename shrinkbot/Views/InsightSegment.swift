//
//  InsightSegment.swift
//  shrinkbot
//
//  Created by Ethan John on 2/2/20.
//  Copyright © 2020 Ethan John. All rights reserved.
//

import Foundation
import SwiftUI

struct InsightSegment<Source>: View where Source: InsightSource {
    @State var buttonState: ButtonState = .waitingForPress {
        didSet {
            if buttonState == .done {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.07) {
                    UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    self.buttonState = .waitingForRefresh
                }
            }
            if buttonState == .waitingForRefresh,
                insights.isEmpty {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 7) {
                    self.buttonState = .waitingForPress
                }
            }
        }
    }
    @State var animate = false
    @State var insights: [Insight] = []
    @State var insightsTapped = false
    var insightGenerator: Source
    var displayString: String {
        switch buttonState {
        case .waitingForPress:
            return "Insights"
        case .loading:
            return ""
        case .done:
            return "Done!"
        case .waitingForRefresh:
            return ""
        }
    }
    var buttonWidth: CGFloat {
        switch buttonState {
        case .waitingForPress, .done:
            return 100
        case .loading, .waitingForRefresh:
            return 40
        }
    }
    let spacing: CGFloat
    enum ButtonState {
        case waitingForPress
        case loading
        case done
        case waitingForRefresh
    }
    var body: some View {
        VStack {
            InsightStack(insights: $insights, spacing: spacing)
            if !insights.isEmpty {
                Spacer(minLength: spacing)
            }
            if insightsTapped && insights.isEmpty && buttonState == .waitingForRefresh {
                Text("No insights for this journal yet.. keep recording data or try again")
                    .defaultFont(12)
                    .foregroundColor(Color("Highlight"))
                Spacer(minLength: spacing)
            }
            Button(action: {
                if self.buttonState == .waitingForPress || self.buttonState == .waitingForRefresh {
                    self.buttonState = .loading
                    self.insights = []
                    self.insightGenerator.generate { insights in
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
                            self.insights = insights
                            self.buttonState = .done
                            self.insightsTapped = true
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
                                self.insightsTapped = false
                            }
                        }
                    }
                }
            }) {
                ZStack {
                    Capsule(style: .circular)
                        .foregroundColor(Color("LowContrast"))
                    HStack {
                        if buttonState == .loading {
                            Circle()
                                .trim(from: 0, to: animate ? 0.95 : 0)
                                .stroke(Color("Standard"), style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round, miterLimit: 1, dash: [], dashPhase: 0))
                                .animation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: true))
                                .rotationEffect(Angle(degrees: animate ? 360 : 0))
                                .animation(Animation.linear(duration: 0.4).repeatForever(autoreverses: false))
                                .frame(width: 20, height: 20)
                                .onAppear {
                                    self.animate = true
                            }
                            .onDisappear {
                                self.animate = false
                            }
                            .transition(.scale)
                            .padding()
                        }
                        if buttonState == .waitingForPress || buttonState == .done {
                            Text(displayString)
                                .foregroundColor(Color("Highlight"))
                                .defaultFont(14, weight: .bold)
                                .transition(.opacity)
                                .padding()
                        }
                        if buttonState == .waitingForRefresh {
                            Image(systemName: "arrow.clockwise")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(Color("Highlight"))
                                .defaultFont(14, weight: .bold)
                                .frame(width: 20, height: 20)
                                .padding()
                        }
                    }
                }
                .frame(width: buttonWidth, height: 40)
            }
            .animation(.default)
        }
    }
}
