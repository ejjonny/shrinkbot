//
//  Home.swift
//  shrinkbot
//
//  Created by Ethan John on 9/29/19.
//  Copyright © 2019 Ethan John. All rights reserved.
//

import SwiftUI

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
	var controlHeight: CGFloat = 100
	var controlWidth: CGFloat? {
		expanded ? nil : 100
	}
	var bloat: CGFloat {
		expanded ? 10 : 0
	}
	var body: some View {
		ZStack {
			Capsule()
				.stroke(Color.gray, lineWidth: expanded ? 10 : 8)
				.frame(width: self.controlWidth, height: self.controlHeight + bloat)
			Capsule()
				.foregroundColor(Color.gray.opacity(0.2))
				.frame(width: self.controlWidth, height: self.controlHeight + bloat)
			GeometryReader { proxy in
				Circle()
					.foregroundColor(Color.blue.opacity(self.expanded ? 0.8 : 0.1))
					.transition(.scale)
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
									self.xOffset = -sliderRangeMagnitude / 2
								} else if ((-eighthLength * 3)..<(-eighthLength)).contains(location) {
									self.xOffset = -sliderRangeMagnitude / 4
								} else if ((-eighthLength)..<(eighthLength)).contains(location) {
									self.xOffset = 0
								} else if ((eighthLength)..<(eighthLength * 3)).contains(location) {
									self.xOffset = sliderRangeMagnitude / 4
								} else if ((eighthLength * 3)..<(eighthLength * 4)).contains(location) {
									self.xOffset = sliderRangeMagnitude / 2
								}
						}
						.onEnded{ value in
							self.expanded = false
							self.xOffset = 0
						}
				)
			}
			.frame(height: self.controlHeight - 5, alignment: .center)
		}
		.padding()
		.animation(
			Animation.spring(dampingFraction: 0.5)
				.speed(3)
		)
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

