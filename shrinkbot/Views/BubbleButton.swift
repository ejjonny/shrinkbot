//
//  BubbleButton.swift
//  shrinkbot
//
//  Created by Ethan John on 10/6/19.
//  Copyright © 2019 Ethan John. All rights reserved.
//

import SwiftUI

struct BubbleButton: ButtonStyle {
	func makeBody(configuration: Self.Configuration) -> some View {
		configuration.label
			.padding(configuration.isPressed ? 10 : 0)
			.animation(.shrinkbotSpring())
	}
}
