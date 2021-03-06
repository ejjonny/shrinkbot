//
//  EntryButton.swift
//  shrinkbot
//
//  Created by Ethan John on 10/2/19.
//  Copyright © 2019 Ethan John. All rights reserved.
//

import SwiftUI

struct EntryButton: View {
    @Binding var expanded: Bool
    @State var xOffset: CGFloat = 0
    @State var animating = false
    @State var selection: Rating? {
        didSet {
            if selection != oldValue {
                bump(.light)
            }
        }
    }
    @State var hovering: Bool = false {
        didSet {
            if hovering {
                bump(.heavy)
            } else {
                bump(.rigid)
            }
        }
    }
    @State var modalPresenting: Bool = false
    
    var controlHeight: CGFloat = 100
    var controlWidth: CGFloat? {
        expanded ? nil : 100
    }
    var bloat: CGFloat {
        expanded ? 10 : 0
    }
    
    var lineWidth: CGFloat {
        switch (expanded, hovering) {
        case (true, false):
            return 10
        case (true, true):
            return 13
        default:
            return 8
        }
    }
    var strokeOpacity: Double {
        switch (expanded, selection) {
        case (true, _):
            return 0.4
        case (false, nil):
            return 1
        default:
            return 0
        }
    }
    var body: some View {
        return ZStack {
            ZStack {
                Capsule()
                    .foregroundColor(Color("Background"))
                Capsule()
                    .stroke(Color("Standard"), lineWidth: lineWidth)
            }
            .frame(width: self.controlWidth, height: self.controlHeight + bloat - (expanded ? 40 : 0))
            GeometryReader { proxy in
                VStack {
                    ZStack {
                        if self.expanded &&
                            Defaults.timesUsedEntryButton < 3 {
                            Text(self.hovering ? "let go" : "drag up")
                                .defaultFont(14, weight: .medium)
                                .animation(nil)
                                .opacity(self.animating ? 0.7 : 0.1)
                                .animation(Animation.default.speed(0.25).repeatForever(autoreverses: true))
                            .offset(y: -80)
                                .onAppear {
                                    self.animating.toggle()
                            }
                        }
                        Circle()
                            .foregroundColor(Color("Background"))
                            .opacity(self.expanded ? 1 : 0)
                        Image(self.selection?.imageString() ?? "GI")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                }
                .offset(x: self.xOffset, y: self.expanded ? -self.controlHeight - self.bloat - 10 : 0)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged{ value in
                            // Splits control into 5 segments that the slider will snap to
                            self.expanded = true
                            let location = value.location.x - value.startLocation.x
                            let sliderRangeMagnitude = proxy.size.width - self.controlHeight - self.bloat
                            let eighthLength = sliderRangeMagnitude / 8
                            if ((-eighthLength * 4)..<(-eighthLength * 3)).contains(location) {
                                self.selection = .realBad
                                self.xOffset = -sliderRangeMagnitude / 2
                            } else if ((-eighthLength * 3)..<(-eighthLength)).contains(location) {
                                self.selection = .bad
                                self.xOffset = -sliderRangeMagnitude / 4
                            } else if ((-eighthLength)..<(eighthLength)).contains(location) {
                                self.selection = .meh
                                self.xOffset = 0
                            } else if ((eighthLength)..<(eighthLength * 3)).contains(location) {
                                self.selection = .good
                                self.xOffset = sliderRangeMagnitude / 4
                            } else if ((eighthLength * 3)..<(eighthLength * 4)).contains(location) {
                                self.selection = .realGood
                                self.xOffset = sliderRangeMagnitude / 2
                            }
                            if value.location.y < -30, !self.hovering {
                                self.hovering = true
                            } else if value.location.y > -30, self.hovering {
                                self.hovering = false
                            }
                    }
                    .onEnded{ value in
                        if !self.hovering {
                            self.close()
                        } else if self.selection != nil {
                            self.bump(.rigid)
                            self.modalPresenting = true
                            if Defaults.timesUsedEntryButton < 3 {
                                Defaults.timesUsedEntryButton += 1
                            }
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                                self.bump(.medium)
                            }
                        }
                    }
                )
            }
            .frame(height: self.controlHeight + (self.expanded ? 10 : -5) + (self.hovering ? 10 : 0), alignment: .center)
            
            if expanded {
                HStack {
                    ForEach(1...5, id: \.self) { _ in
                        Circle()
                            .foregroundColor(Color("LowContrast"))
                    }
                }
                .transition(.scale)
                .frame(height: self.controlHeight - (self.hovering ? 60 : 70))
            }
        }
        .padding()
        .animation(
            .shrinkbotSpring()
        )
            .sheet(isPresented: $modalPresenting, onDismiss: {
                self.close()
            }) {
                EntryModal(selection: self.$selection, expanded: self.$expanded, xOffset: self.$xOffset, factorTypes: CardController.shared.activeCardFactorTypes)
        }
        
    }
    
    func open() {
        expanded = true
    }
    
    func close() {
        selection = nil
        expanded = false
        xOffset = 0
    }
    
    func bump(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
}
