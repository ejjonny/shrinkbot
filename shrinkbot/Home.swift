//
//  Home.swift
//  shrinkbot
//
//  Created by Ethan John on 9/29/19.
//  Copyright © 2019 Ethan John. All rights reserved.
//

import SwiftUI
import CoreHaptics

struct Home: View {
    var body: some View {
		VStack {
			Spacer()
			EntryButton()
		}
		.frame(alignment: .bottom)
    }
}

struct EntryButton: View {
	@State var expanded: Bool = false
	@State var xOffset: CGFloat = 0
	@State var selected: Selected?
	@State var hovering: Bool = false {
		didSet {
			if hovering != oldValue {
				generateHapticFeedback()
			}
		}
	}
	var controlHeight: CGFloat = 100
	var controlWidth: CGFloat? {
		expanded ? nil : 100
	}
	enum Selected: String {
		case realBad = "SBA"
		case bad = "BA"
		case meh = "NA"
		case good = "GA"
		case realGood = "SGA"
	}
	var bloat: CGFloat {
		expanded ? 10 : 0
	}
	var body: some View {
		ZStack {
			Capsule()
				.stroke(Color.black.opacity(expanded ? 0.4 : selected == nil ? 1 : 0), lineWidth: expanded ? 10 : 8)
				.frame(width: self.controlWidth, height: self.controlHeight + bloat - (expanded ? 40 : 0))
			GeometryReader { proxy in
					Image(self.selected?.rawValue ?? "GI")
						.resizable()
						.aspectRatio(contentMode: .fit)
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
										self.selected = .realBad
										self.xOffset = -sliderRangeMagnitude / 2
									} else if ((-eighthLength * 3)..<(-eighthLength)).contains(location) {
										self.selected = .bad
										self.xOffset = -sliderRangeMagnitude / 4
									} else if ((-eighthLength)..<(eighthLength)).contains(location) {
										self.selected = .meh
										self.xOffset = 0
									} else if ((eighthLength)..<(eighthLength * 3)).contains(location) {
										self.selected = .good
										self.xOffset = sliderRangeMagnitude / 4
									} else if ((eighthLength * 3)..<(eighthLength * 4)).contains(location) {
										self.selected = .realGood
										self.xOffset = sliderRangeMagnitude / 2
									}
									if value.location.y < -30 {
										self.hovering = true
									} else {
										self.hovering = false
									}
							}
							.onEnded{ value in
								if value.location.y > -30 {
									self.selected = nil
								}
								self.expanded = false
								self.xOffset = 0
							}
					)
			}
			.frame(height: self.controlHeight + (self.expanded ? 10 : -5) + (self.hovering ? 10 : 0), alignment: .center)
		}
		.padding()
		.animation(
			Animation.spring(dampingFraction: 0.5)
				.speed(3)
		)
	}
	
	func generateHapticFeedback() {
		var engine: CHHapticEngine?
		do {
			engine = try CHHapticEngine()
		} catch {
			print(error.localizedDescription)
			print(error)
		}
		try? engine?.start()

		let hapticEvent = CHHapticEvent(eventType: .hapticTransient, parameters: [
			CHHapticEventParameter(parameterID: .hapticSharpness, value: 1), CHHapticEventParameter(parameterID: .hapticIntensity, value: 1),
		], relativeTime: 0)
		let audioEvent = CHHapticEvent(eventType: .audioContinuous, parameters: [
			CHHapticEventParameter(parameterID: .audioVolume, value: 1),
			CHHapticEventParameter(parameterID: .decayTime, value: 1),
			CHHapticEventParameter(parameterID: .sustained, value: 0),
		], relativeTime: 0)

		let pattern = try? CHHapticPattern(events: [hapticEvent, audioEvent], parameters: [])
		let hapticPlayer = try? engine?.makePlayer(with: pattern!)
		try? hapticPlayer?.start(atTime: CHHapticTimeImmediate)
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

