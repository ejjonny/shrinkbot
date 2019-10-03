//
//  EntryModal.swift
//  shrinkbot
//
//  Created by Ethan John on 10/2/19.
//  Copyright © 2019 Ethan John. All rights reserved.
//

import SwiftUI

struct EntryModal: View {
	@Environment(\.presentationMode) var presentation
	@ObservedObject var cardController: CardController
	let selection: EntryButton.Selected?
	var body: some View {
		List {
			ForEach(cardController.activeCardFactorTypes, id: \.self) { factorType in
				Text("Yes")
			}
		}
	}
}

struct EntryModal_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
