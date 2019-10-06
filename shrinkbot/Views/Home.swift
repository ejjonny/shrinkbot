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
	@State var graphStyle: Int
	var graphOptions = GraphRangeOptions.allCases
	var body: some View {
		ZStack {
			VStack {
				Spacer()
				EntryButton()
			}
			.frame(alignment: .bottom)
			VStack {
				Picker("Dates??", selection: $graphStyle) {
					ForEach(0..<graphOptions.count, id: \.self) { index in
						Text(self.graphOptions[index].rawValue).tag(index)
					}
				}
				.pickerStyle(SegmentedPickerStyle())
				.padding()
				GraphView(data: currentCardData())
					.frame(height: 100)
					.padding()
			}
		}
    }
	
	func currentCardData() -> [Range<Double>] {
		CardController.shared.entriesWith(graphViewStyle: graphOptions[graphStyle]).map { $0.ratingRange }
	}
}

class ButtonState: ObservableObject {
	@Published var open: Bool = false
	@Published var selection: EntryButton.Selected?
}
