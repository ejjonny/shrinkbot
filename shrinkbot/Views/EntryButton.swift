//
//  EntryButton.swift
//  shrinkbot
//
//  Created by Ethan John on 10/2/19.
//  Copyright © 2019 Ethan John. All rights reserved.
//

import SwiftUI

struct EntryButton: View {
	@State var expanded: Bool = false
	@State var xOffset: CGFloat = 0
	@Binding var selected: Selected? {
		didSet {
			if selected != oldValue {
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
	@Binding var presentModal: Bool {
		didSet {
			selected = nil
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
		switch (expanded, selected) {
		case (true, _):
			return 0.4
		case (false, nil):
			return 1
		default:
			return 0
		}
	}
	var body: some View {
		ZStack {
			Capsule()
				.stroke(Color.black.opacity(strokeOpacity), lineWidth: lineWidth)
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
									if value.location.y < -30, !self.hovering {
										self.hovering = true
									} else if value.location.y > -30, self.hovering {
										self.hovering = false
									}
							}
							.onEnded{ value in
								if value.location.y > -30 {
									self.selected = nil
								}
								self.expanded = false
								self.xOffset = 0
								if self.selected != nil {
									self.bump(.rigid)
									self.presentModal = true
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
							.foregroundColor(Color.black.opacity(0.05))
					}
				}
				.transition(.scale)
				.frame(height: self.controlHeight - (self.hovering ? 60 : 70))
			}
		}
		.padding()
		.animation(
			Animation.spring(dampingFraction: 0.5)
				.speed(3)
		)
	}
	
	func bump(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
		UIImpactFeedbackGenerator(style: style).impactOccurred()
	}
}


struct EntryButton_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
