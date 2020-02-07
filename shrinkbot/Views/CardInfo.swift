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
    @State var detailPopup: Int?
    @ObservedObject var cardController: CardController
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
            HStack {
                Text(cardController.activeCard?.name ?? "Card Name")
                    .font(.system(size: 25, weight: .medium, design: .rounded))
                Spacer()
                HStack(spacing: 25) {
                    Button(action: {
                    }) {
                        Image(systemName: "ellipsis")
                            .resizable()
                            .aspectRatio(140 / 31, contentMode: .fit)
                    }
                    .frame(width: 20, height: 20)
                    .buttonStyle(BubbleButton())
                    Button(action: {
                    }) {
                        Image(systemName: "square.and.pencil")
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                    }
                    .frame(width: 20, height: 20)
                    .buttonStyle(BubbleButton())
                    Button(action: {
                    }) {
                    Image(systemName: "list.bullet")
                            .resizable()
                            .aspectRatio(17 / 12, contentMode: .fit)
                    }
                    .frame(width: 20, height: 20)
                    .buttonStyle(BubbleButton())
                }
            }
            .padding(15)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color("Standard"))
            )
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
        }
    }
}
