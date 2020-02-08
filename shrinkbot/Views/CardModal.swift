//
//  CardModal.swift
//  shrinkbot
//
//  Created by Ethan John on 2/7/20.
//  Copyright © 2020 Ethan John. All rights reserved.
//

import SwiftUI

struct CardModal: View {
    @Environment(\.presentationMode) var presentation
    @ObservedObject var cardController: CardController
    var body: some View {
        NavigationView {
            ScrollView([.vertical], showsIndicators: false) {
                ForEach(cardController.cards.indices, id: \.self) { index in
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color("Standard"))
                            .cornerRadius(10)
                        Text(self.cardController.cards.first!.name!)
                            .foregroundColor(Color("Highlight"))
                    }
                    .frame(height: 50)
                }
                .padding()
            }
            .navigationBarTitle("My cards")
        }
    }
}
