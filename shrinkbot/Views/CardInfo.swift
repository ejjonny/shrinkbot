//
//  CardInfo.swift
//  shrinkbot
//
//  Created by Ethan John on 10/8/19.
//  Copyright © 2019 Ethan John. All rights reserved.
//

import SwiftUI

struct CardInfo: View {
    @State var graphStyle: Int
    var graphOptions = GraphRangeOptions.allCases
    var spacing: CGFloat
    var body: some View {
        VStack(spacing: spacing) {
            HStack {
                Text(CardController.shared.activeCard?.name ?? "Card Name")
                    .font(.system(size: 25, weight: Font.Weight.medium))
                Spacer()
                HStack(spacing: 15) {
                    Button(action: {
                    }) {
                        Image(systemName: "ellipsis.circle")
                            .resizable()
                            .scaledToFit()
                    }
                    .frame(width: 30)
                    .buttonStyle(BubbleButton())
                    Button(action: {
                    }) {
                        Image(systemName: "square.and.pencil")
                            .resizable()
                            .scaledToFit()
                    }
                    .frame(width: 30)
                    .buttonStyle(BubbleButton())
                    Button(action: {
                    }) {
                        Image(systemName: "list.bullet")
                            .resizable()
                            .scaledToFit()
                    }
                    .frame(width: 30)
                    .buttonStyle(BubbleButton())
                }
            }
            .padding([.top], 30)
            Picker("Dates??", selection: $graphStyle) {
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
        CardController.shared.entriesWith(graphViewStyle: graphOptions[graphStyle]).map { $0.ratingRange }
    }
}

struct CardInfo_Previews: PreviewProvider {
    static var previews: some View {
        CardInfo(graphStyle: 0, spacing: 20)
    }
}
