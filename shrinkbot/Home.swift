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
	@State var selected: EntryButton.Selected?
    var body: some View {
		VStack {
			Spacer()
			EntryButton(selected: $selected, presentModal: $showModal)
		}
		.sheet(isPresented: $showModal, onDismiss: {
			self.showModal = false
		}) {
			Modal(selection: self.selected)
		}
		.frame(alignment: .bottom)
    }
}

struct Modal: View {
	@Environment(\.presentationMode) var presentation
	let selection: EntryButton.Selected?
	var body: some View {
		EmptyView()
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

