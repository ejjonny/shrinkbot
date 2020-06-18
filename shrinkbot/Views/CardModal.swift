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
    @State var deleteAlert = false
    @State var deleting: DeleteType = .card
    @State var selectedFactorType: FactorType?
    enum DeleteType {
        case card
        case factorType
        case notDeleting
    }
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
                                HStack(alignment: .firstTextBaseline) {
                                    Text(self.cardController.cards[index].name ?? "")
                                        .defaultFont(30, weight: .bold)
                                        .opacity(self.cardController.cards[index].isActive ? 1 : 0.5)
                                    Spacer()
                                        .frame(width: 10)
                                    if !self.cardController.cards[index].isActive {
                                        Text("\(self.cardController.cards[index].entries?.array.count ?? 0) entries")
                                            .defaultFont()
                                            .opacity(self.cardController.cards[index].isActive ? 1 : 0.5)
                                            .transition(AnyTransition.move(edge: .leading).combined(with: .opacity))
                                    }
                                }
                                Spacer()
                                if self.cardController.cards[index].isActive {
                                    Button(action: {
                                        self.deleting = .card
                                        self.deleteAlert = true
                                    }) {
                                        Image(systemName: "trash")
                                    }
                                    .padding()
                                    .foregroundColor(Color("Highlight"))
                                    .background(
                                        Circle()
                                            .foregroundColor(Color("Standard"))
                                    )
                                        .padding([.top, .bottom])
                                        .transition(AnyTransition.move(edge: .trailing).combined(with: .opacity))
                                }
                                Button(action: {
                                    withAnimation(Animation.shrinkbotSpring()) {
                                        self.cardController.setActive(card: self.cardController.cards[index])
                                    }
                                }) {
                                    Image(systemName: self.cardController.cards[index].isActive ? "checkmark.circle.fill" : "checkmark.circle")
                                }
                                .padding()
                                .foregroundColor(Color("Highlight"))
                                .background(
                                    Circle()
                                        .foregroundColor(Color(self.cardController.cards[index].isActive ? "Standard" : "LowContrast"))
                                )
                                    .padding([.top, .bottom])
                            }
                        ) {
                            if self.cardController.cards[index].isActive {
                                ForEach(self.cardController.activeCardFactorTypes.indices, id: \.self) { index in
                                    HStack {
                                        Text(self.cardController.activeCardFactorTypes[index].name ?? "")
                                            .defaultFont()
                                        Spacer()
                                        Button(action: {
                                            self.deleting = .factorType
                                            self.deleteAlert = true
                                            self.selectedFactorType = self.cardController.activeCardFactorTypes[index]
                                        }) {
                                            Image(systemName: "trash")
                                        }
                                        .buttonStyle(BorderlessButtonStyle())
                                        .padding()
                                        .foregroundColor(Color("Highlight"))
                                        .background(
                                            Circle()
                                                .foregroundColor(Color("Standard"))
                                        )
                                            .padding([.top, .bottom])
                                    }
                                }
                                .transition(.opacity)
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
        .alert(isPresented: $deleteAlert) { () -> Alert in
            if deleting == .card {
                return Alert(title: Text("Are you sure you want to delete \(self.cardController.activeCard?.name ?? "this card")?"), message: Text("All of your entries will be deleted. You can't undo this."), primaryButton: .destructive(Text("Delete"), action: {
                    self.cardController.deleteActiveCard(completion: nil)
                }), secondaryButton: .cancel())
            } else {
                return Alert(title: Text("Are you sure you want to delete \(selectedFactorType?.name ?? "this factor")?"), message: Text("This factor will be removed from every recorded entry. You can't undo this."), primaryButton: .destructive(Text("Delete"), action: {
                    if let type = self.selectedFactorType {
                        self.cardController.deleteFactorType(type)
                    }
                }), secondaryButton: .cancel())
            }
        }
    }
}
