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
    @State var inserting = false
    @State var newCardName = String()
    var body: some View {
        NavigationView {
            ScrollView([.vertical], showsIndicators: false) {
                VStack(spacing: 0) {
                    CardList(cardController: cardController)
                    if inserting {
                        InsertItem(cardController: cardController, newCardName: $newCardName, inserting: $inserting)
                    }
                    if !inserting {
                        Button(action: {
                            withAnimation(.default) {
                                self.inserting = true
                            }
                        }) {
                            Image(systemName: "plus.circle")
                                .resizable()
                                .defaultFont()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color("Standard"))
                        }
                        .transition(.opacity)
                    }
                }
            }
            .navigationBarTitle("My cards")
        }
    }
}

struct CardList: View {
    @ObservedObject var cardController: CardController
    var body: some View {
        ForEach(cardController.cards.indices, id: \.self) { index in
            VStack {
                ZStack {
                    Button(action: {
                        withAnimation(.shrinkbotSpring()) {
                            self.cardController.setActive(card: self.cardController.cards[index])
                        }
                    }) {
                        Rectangle()
                            .foregroundColor(Color("Standard"))
                            .transition(.opacity)
                            .overlay(
                                HStack(spacing: 0) {
                                    ZStack {
                                        Rectangle()
                                            .foregroundColor(self.cardController.cards[index].isActive ? Color("Highlight") : .clear)
                                            .frame(width: 60)
                                        if self.cardController.cards[index].isActive {
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                                .foregroundColor(self.cardController.cards[index].isActive ? Color("Standard") : Color("Highlight"))
                                        }
                                    }
                                    Rectangle()
                                        .foregroundColor(Color("Highlight").opacity(0.2))
                                        .frame(width: 1)
                                    Spacer()
                                    Text(self.cardController.cards[index].name!)
                                        .animation(nil)
                                        .defaultFont(17, weight: self.cardController.cards[index].isActive ? .bold : .regular)
                                        .foregroundColor(Color("Highlight"))
                                    Spacer()
                                    Button(action: {
                                        withAnimation(.shrinkbotSpring()) {
                                            self.cardController.deleteCard(self.cardController.cards[index])
                                        }
                                    }) {
                                        ZStack {
                                            Rectangle()
                                                .foregroundColor(Color.red.opacity(0.5))
                                                .frame(width: 60)
                                            VStack(spacing: 8) {
                                                Image(systemName: "trash")
                                                    .font(.system(size: 15, weight: .bold, design: .rounded))
                                                    .foregroundColor(Color("Highlight"))
                                                Text("Delete")
                                                    .foregroundColor(Color("Highlight"))
                                                    .defaultFont()
                                            }
                                        }
                                    }
                            })
                            .cornerRadius(10)
                    }
                }
                .frame(height: 60)
                FactorList(card: self.$cardController.cards[index], cardController: self.cardController)
                
            }
        }
        .padding()
    }
}

struct FactorList: View {
    @Binding var card: Card
    @ObservedObject var cardController: CardController
    @State var inserting = false
    @State var newFactorName = String()
    var body: some View {
        if card.isActive {
            return AnyView(
                VStack {
                    Text("Factors")
                        .defaultFont(15, weight: .regular)
                        .foregroundColor(Color("Highlight"))
                    ForEach(card.factors.indices, id: \.self) { index in
                        HStack {
                            Spacer(minLength: 30)
                            Rectangle()
                                .foregroundColor(Color("Standard"))
                                .overlay(
                                    HStack {
                                        Spacer()
                                        Text(self.card.factors[index].name!)
                                            .defaultFont(weight: Font.Weight.light)
                                        Spacer()
                                        Button(action: {
                                            withAnimation(.shrinkbotSpring()) {
                                                self.cardController.deleteFactorType(self.card.factors[index])
                                            }
                                        }) {
                                            ZStack {
                                                Rectangle()
                                                    .foregroundColor(Color.red.opacity(0.5))
                                                    .frame(width: 60)
                                                VStack(spacing: 8) {
                                                    Image(systemName: "trash")
                                                        .font(.system(size: 15, weight: .bold, design: .rounded))
                                                        .foregroundColor(Color("Highlight"))
                                                }
                                            }
                                        }
                                    }
                            )
                                .cornerRadius(10)
                                .frame(height: 30)
                                .transition(.opacity)
                                .animation(Animation.shrinkbotSpring().delay(0.1 * Double(index)))
                            Spacer(minLength: 30)
                        }
                    }
                    if inserting {
                        ZStack {
                            Rectangle()
                                .foregroundColor(Color("Standard"))
                                .cornerRadius(10)
                            OpenTextField("Factor name...", text: $newFactorName) {
                                withAnimation(.shrinkbotSpring()) {
                                    self.inserting = false
                                    guard !self.newFactorName.isEmpty else {
                                        return
                                    }
                                    self.cardController.createFactorType(withName: self.newFactorName, onCard: self.card)
                                }
                            }
                            .padding()
                        }
                        .frame(height: 30)
                        .transition(.opacity)
                        .animation(.shrinkbotSpring())
                    }
                    if !inserting {
                        Button(action: {
                            print("yote")
                        }, label: {
                            Button(action: {
                                self.inserting = true
                            }) {
                                Image(systemName: "plus.circle")
                                    .resizable()
                                    .defaultFont()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color("Standard"))
                            }
                        })
                    }
                }
            )
        } else {
            return AnyView(EmptyView())
        }
    }
}

struct InsertItem: View {
    @ObservedObject var cardController: CardController
    @Binding var newCardName: String
    @Binding var inserting: Bool
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color("Standard"))
                .cornerRadius(10)
                .frame(height: 50)
            OpenTextField("Card name...", text: $newCardName) {
                withAnimation(.shrinkbotSpring()) {
                    self.inserting = false
                    guard !self.newCardName.isEmpty else { return }
                    self.cardController.createCard(named: self.newCardName)
                }
            }
            .padding()
            .onAppear {
                self.newCardName = ""
            }
        }
        .transition(.opacity)
        .frame(height: 50)
        .padding()
        
    }
}
