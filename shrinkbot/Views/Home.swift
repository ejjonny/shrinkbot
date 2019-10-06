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
    var body: some View {
		ZStack {
			VStack {
				Spacer()
				EntryButton()
			}
			.frame(alignment: .bottom)
			GraphView(data: currentCardData())
				.frame(width: 10, height: 100)
		}
    }
	
	func currentCardData() -> [Range<Double>] {
		CardController.shared.entriesWith(graphViewStyle: .today).map { $0.averageRating - 1..<$0.averageRating + 1}
	}
}

class ButtonState: ObservableObject {
	@Published var open: Bool = false
	@Published var selection: EntryButton.Selected?
}
