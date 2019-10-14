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
    let spacing: CGFloat = 20
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: spacing) {
                    CardInfo(graphStyle: 4, spacing: spacing)
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
    @Published var selection: EntryButton.Selected?
}
