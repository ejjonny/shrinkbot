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
				VStack(spacing: 20) {
					HStack {
						Text(CardController.shared.activeCard?.name ?? "Card Name")
							.font(.system(size: 25, weight: Font.Weight.medium))
						Spacer()
						HStack(spacing: 15) {
							Button(action: {
							}) {
								Image(systemName: "ellipsis.circle")
									.resizable()
									.scaledToFit()
							}
							.frame(width: 30)
							.buttonStyle(BubbleButton())
							Button(action: {
							}) {
								Image(systemName: "square.and.pencil")
									.resizable()
									.scaledToFit()
							}
							.frame(width: 30)
							.buttonStyle(BubbleButton())
							Button(action: {
							}) {
								Image(systemName: "list.bullet")
									.resizable()
									.scaledToFit()
							}
							.frame(width: 30)
							.buttonStyle(BubbleButton())
						}
					}
					.padding([.top], 30)
					Picker("Dates??", selection: $graphStyle) {
						ForEach(0..<graphOptions.count, id: \.self) { index in
							Text(self.graphOptions[index].rawValue).tag(index)
						}
					}
					.pickerStyle(SegmentedPickerStyle())
					.zIndex(1)
					GraphView(data: currentCardData())
						.frame(height: 250)
				}
				Spacer()
			}
			.padding()
			VStack {
				Spacer()
				EntryButton()
			}
			.frame(alignment: .bottom)
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
