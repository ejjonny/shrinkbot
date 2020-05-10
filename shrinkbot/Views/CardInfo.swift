//
//  CardInfo.swift
//  shrinkbot
//
//  Created by Ethan John on 10/8/19.
//  Copyright © 2019 Ethan John. All rights reserved.
//

import SwiftUI

struct CardInfo: View {
    @State var pickerInt: Int
    @Binding var detailPopup: Int?
    @ObservedObject var cardController: CardController
    @State var modalPresenting = false
    @State var modal: Modal = .card
    enum Modal {
        case card
        case notification
    }
    var graphOptionSelection: GraphRangeOptions {
        GraphRangeOptions.allCases[pickerInt]
    }
    var graphOptions = GraphRangeOptions.allCases
    var spacing: CGFloat
    
    var body: some View {
        let binding = Binding(get: {
            self.pickerInt
        }) { newValue in
            self.pickerInt = newValue
            self.detailPopup = nil // Clear the detail popup on the graph
        }
        return VStack(spacing: spacing) {
            HStack(spacing: 0) {
                Button(action: {
                    self.modal = .card
                    self.modalPresenting = true
                }) {
                    Text(cardController.activeCard?.name ?? "Card Name")
                        .defaultFont(25)
                        .foregroundColor(Color("Highlight"))
                        .padding()
                        .background(
                            Capsule()
                                .foregroundColor(Color("Standard"))
                    )
                }
                .frame(height: 62)
                Spacer()
                Button(action: {
                    self.modal = .notification
                    self.modalPresenting = true
                }) {
                        Image(systemName: "bell")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding()
                            .background(
                                Circle()
                                    .foregroundColor(Color("Standard"))
                    )
                }
                .frame(height: 62)
                .buttonStyle(BubbleButton())
            }
            Picker("Dates??", selection: binding) {
                ForEach(0..<graphOptions.count, id: \.self) { index in
                    Text(self.graphOptions[index].rawValue).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .zIndex(1)
            GraphView(stats: cardController.entriesWith(graphViewStyle: graphOptionSelection), detailPopup: $detailPopup)
                .frame(height: 250)
                .animation(.shrinkbotSpring())
                .drawingGroup()
        }
        .sheet(isPresented: $modalPresenting) {
            if self.modal == .card {
                CardModal(cardController: self.cardController)
            } else {
                NotificationModal()
            }
        }
    }
}
