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
    @State var createState: CreateState = .notEditing
    @State var editedText = ""
    enum CreateState {
        case newCard
        case newFactorType
        case notEditing
    }
    var body: some View {
        ZStack {
            VStack {
                ModalHandle()
                HStack {
                    Button(action: {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                        self.editedText = ""
                        withAnimation(.default) {
                            self.createState = .newCard
                        }
                    }) {
                        HStack(alignment: .center) {
                            Text("Create a Card")
                                .defaultFont()
                            Image(systemName: "square.and.pencil")
                        }
                        .foregroundColor(Color("Highlight"))
                        .padding()
                        .background(
                            Capsule()
                                .foregroundColor(Color("LowContrast"))
                        )
                    }
                    Button(action: {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                        self.editedText = ""
                        withAnimation(.default) {
                            self.createState = .newFactorType
                        }
                    }) {
                        HStack(alignment: .center) {
                            Text("Add a Factor")
                                .defaultFont()
                            Image(systemName: "mappin.circle")
                        }
                        .foregroundColor(Color("Highlight"))
                        .padding()
                        .background(
                            Capsule()
                                .foregroundColor(Color("LowContrast"))
                        )
                    }
                }
                List {
                    ForEach(cardController.cards.indices, id: \.self) { index in
                        Section(header:
                            HStack {
                                Text(self.cardController.cards[index].name ?? "")
                                Spacer()
                                Button(action: {
                                    print("del")
                                }) {
                                    Image(systemName: "trash")
                                }
                                .foregroundColor(Color("Highlight"))
                            }
                        ) {
                            if self.cardController.cards[index].isActive {
                                ForEach(self.cardController.activeCardFactorTypes.indices, id: \.self) { index in
                                    Text(self.cardController.activeCardFactorTypes[index].name ?? "")
                                        .defaultFont()
                                }
                            }
                        }
                    }
                }
            }
            .blur(radius: createState == .newCard || createState == .newFactorType ? 20 : 0)
            .disabled(createState == .newCard || createState == .newFactorType)
            if self.createState == .newCard || self.createState == .newFactorType {
                VStack {
                    Spacer()
                    VStack {
                        Text(self.createState == .newCard ? "New Card" : "New Factor")
                            .defaultFont(20, weight: .semibold)
                        TextField("Enter a name...", text: $editedText)
                            .frame(width: 125)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        HStack {
                            Button(action: {
                                if !self.editedText.isEmpty {
                                    switch self.createState {
                                    case .newCard:
                                        self.cardController.createCard(named: self.editedText)
                                    case .newFactorType:
                                        self.cardController.createFactorType(withName: self.editedText)
                                    case .notEditing:
                                        break
                                    }
                                }
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                                withAnimation(.default) {
                                    self.createState = .notEditing
                                }
                            }) {
                                Text("Done")
                                    .defaultFont()
                                    .foregroundColor(Color("Highlight"))
                                    .padding()
                                    .background(
                                        Capsule()
                                            .foregroundColor(Color("Standard"))
                                )
                            }
                        }
                    }
                    .frame(width: 150, height: 125)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(Color("LowContrast"))
                    )
                    Spacer()
                    Spacer()
                }
                .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
                .zIndex(10)
            }
        }
    }
}
