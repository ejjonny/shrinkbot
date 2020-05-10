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
        ScrollView([.vertical], showsIndicators: false) {
            ModalHandle()
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
        .background(Color("Background"))
        .edgesIgnoringSafeArea([.bottom])
    }
}

struct CardList: View {
    @ObservedObject var cardController: CardController
    var body: some View {
        ForEach(cardController.cards) { card in
            VStack {
                CardItem(card: card, cardController: self.cardController)
                FactorList(card: card, cardController: self.cardController)
            }
        }
        .padding()
    }
}

struct CardItem: View {
    let card: Card
    @ObservedObject var cardController: CardController
    @State var showingDeleteAlert = false
    @State var editedCardName = String()
    @State var editingCardName = false
    
    var body: some View {
        ZStack {
            Button(action: {}) {
                Rectangle()
                    .foregroundColor(Color("Standard"))
                    .transition(.opacity)
                    .overlay(
                        HStack(spacing: 0) {
                            if card.isActive {
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(self.card.isActive ? Color("Highlight") : .clear)
                                        .frame(width: 60)
                                    if self.card.isActive {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 15, weight: .bold, design: .rounded))
                                            .foregroundColor(self.card.isActive ? Color("Standard") : Color("Highlight"))
                                    }
                                }
                                Rectangle()
                                    .foregroundColor(Color("Highlight").opacity(0.2))
                                    .frame(width: 1)
                            }
                            Spacer()
                            OpenTextField("Card name...", initialValue: self.card.name ?? "", fontSize: 13, weight: self.card.isActive ? .bold : .regular, text: $editedCardName, shouldBeFirstResponder: $editingCardName) {
                                self.editingCardName = false
                                guard !self.editedCardName.isEmpty else {
                                    return
                                }
                                self.cardController.renameCard(self.card, name: self.editedCardName)
                            }
                            //                            Text(self.card.name ?? "")
                            //                                .animation(nil)
                            //                                .defaultFont(17, weight: self.card.isActive ? .bold : .regular)
                            //                                .foregroundColor(Color("Highlight"))
                            Spacer()
                            if card.isActive {
                                Button(action: {
                                    self.showingDeleteAlert = true
                                }) {
                                    ZStack {
                                        Rectangle()
                                            .foregroundColor(Color.red.opacity(0.5))
                                            .frame(width: 60)
                                        Image(systemName: "trash")
                                            .font(.system(size: 15, weight: .bold, design: .rounded))
                                            .foregroundColor(Color("Highlight"))
                                    }
                                }
                                .alert(isPresented: self.$showingDeleteAlert, content: { () -> Alert in
                                    Alert(title: Text("Are you sure?"), message: Text("This will delete the card '\(self.card.name ?? "")'."), primaryButton: .cancel({
                                        self.showingDeleteAlert = false
                                    }), secondaryButton: .destructive(Text("Delete"), action: {
                                        withAnimation(.shrinkbotSpring()) {
                                            self.cardController.deleteCard(self.card)
                                        }
                                    }))
                                })
                            }
                        }
                )
                    .cornerRadius(10)
                    .onTapGesture {
                        if self.card.isActive {
                            self.editingCardName = true
                        } else {
                            withAnimation(.shrinkbotSpring()) {
                                self.cardController.setActive(card: self.card)
                            }
                        }
                }
            }
        }
        .frame(height: 60)
    }
}

struct FactorList: View {
    var card: Card
    @ObservedObject var cardController: CardController
    @State var inserting = false
    @State var newFactorName = String()
    @State var showingDeleteAlert = false
    @State var editedFactorName = String()
    @State var editingFactorName = false
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
                            Button(action: {}) {
                                Rectangle()
                                    .foregroundColor(Color("Standard"))
                                    .overlay(
                                        HStack {
                                            Rectangle()
                                                .foregroundColor(.pink)
                                                .frame(width: 60)
                                            Spacer()
                                            OpenTextField(initialValue: self.card.factors[index].name!, weight: .light, text: self.$editedFactorName, shouldBeFirstResponder: self.$editingFactorName) {
                                                self.editingFactorName = false
                                                guard !self.editedFactorName.isEmpty else { return }
                                                self.cardController.renameFactorType(self.card.factors[index], withName: self.editedFactorName)
                                            }
                                            Spacer()
                                            Button(action: {
                                                self.showingDeleteAlert = true
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
                                            .alert(isPresented: self.$showingDeleteAlert, content: { () -> Alert in
                                                Alert(title: Text("Are you sure?"), message: Text("This will delete the factor '\(self.card.factors[index].name!)'."), primaryButton: .cancel({
                                                    self.showingDeleteAlert = false
                                                }), secondaryButton: .destructive(Text("Delete"), action: {
                                                    withAnimation(.shrinkbotSpring()) {
                                                        self.cardController.deleteFactorType(self.card.factors[index])
                                                    }
                                                }))
                                            })
                                            
                                        }
                                )
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        if !self.editingFactorName {
                                            self.editingFactorName = true
                                        }
                                }
                                    .frame(height: 30)
                                    .transition(.opacity)
                                    .animation(Animation.shrinkbotSpring().delay(0.1 * Double(index)))
                            }
                            Spacer(minLength: 30)
                        }
                    }
                    if inserting {
                        HStack {
                            Spacer(minLength: 30)
                            ZStack {
                                Rectangle()
                                    .foregroundColor(Color("Standard"))
                                    .cornerRadius(10)
                                OpenTextField("Factor name...", fontSize: 13, text: $newFactorName, shouldBeFirstResponder: self.$inserting) {
                                    withAnimation(.shrinkbotSpring()) {
                                        self.inserting = false
                                        guard !self.newFactorName.isEmpty else {
                                            return
                                        }
                                        self.cardController.createFactorType(withName: self.newFactorName, onCard: self.card)
                                    }
                                }
                                .padding([.leading, .trailing])
                            }
                            .frame(height: 30)
                            .transition(.opacity)
                            .animation(.shrinkbotSpring())
                            Spacer(minLength: 30)
                        }
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
    @State var shouldEdit = true
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color("Standard"))
                .cornerRadius(10)
                .frame(height: 50)
            OpenTextField("Card name...", fontSize: 17, text: $newCardName, shouldBeFirstResponder: $shouldEdit) {
                withAnimation(.shrinkbotSpring()) {
                    self.inserting = false
                    self.shouldEdit = false
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
        .frame(height: 60)
        .padding()
        
    }
}
