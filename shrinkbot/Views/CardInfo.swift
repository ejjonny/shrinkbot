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
    @ObservedObject var cardController: CardController
    var graphOptionSelection: GraphRangeOptions {
        GraphRangeOptions.allCases[pickerInt]
    }
    var graphOptions = GraphRangeOptions.allCases
    var spacing: CGFloat
    
    var body: some View {
        VStack(spacing: spacing) {
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
            Picker("Dates??", selection: $pickerInt) {
                ForEach(0..<graphOptions.count, id: \.self) { index in
                    Text(self.graphOptions[index].rawValue).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .zIndex(1)
            GraphView(data: currentCardData())
                .frame(height: 250)
        }
    }
    
    func currentCardData() -> [Range<Double>] {
        cardController.entriesWith(graphViewStyle: graphOptionSelection).map { $0.ratingRange }
    }
}
