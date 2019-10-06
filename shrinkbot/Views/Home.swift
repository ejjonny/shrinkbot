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
		VStack {
			Spacer()
			EntryButton()
		}
		.frame(alignment: .bottom)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}

class ButtonState: ObservableObject {
	@Published var open: Bool = false
	@Published var selection: EntryButton.Selected?
}
