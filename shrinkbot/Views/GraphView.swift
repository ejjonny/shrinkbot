//
//  GraphView.swift
//  graphView
//
//  Created by Ethan John on 9/21/19.
//

import SwiftUI

struct GraphView: View {
    var stats: [EntryStats]
    var factorTypes: [FactorType]
    var data: [Double] {
        stats.map { $0.averageRating }
    }
    let range = 5
    let colors = FactorTypeColors().colors.shuffled()
    @Binding var detailPopup: Int?
    @State var factorSelected: Int?
    
    init(stats: [EntryStats], detailPopup: Binding<Int?>) {
        self.stats = stats
        self.factorTypes = stats.lazy
            .flatMap(\.factorTypes)
            .reduce(into: Set<FactorType>()) { current, next in
                current.insert(next)
            }
            .map { $0 }
        self._detailPopup = detailPopup
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color("LowContrast"))
            // Horizontal graph lines
            HorizontalLines(graphPadding: self.graphPadding, yOffset: self.yOffset, range: self.range)
            // Vertical graph lines
            VerticalLines(graphPadding: self.graphPadding, xOffset: self.xOffset, indices: self.data.indices)
            dataPoints
            VStack {
                if detailPopup != nil {
                    HStack {
                        Text("\(stats[detailPopup!].name)")
                            .defaultFont(10)
                        Text(String(format: "Avg: %.2f", stats[detailPopup!].averageRating))
                            .defaultFont(10)
                        Text("\(stats[detailPopup!].ratingCount) \(stats[detailPopup!].ratingCount == 1 ? "entry" : "entries")")
                            .defaultFont(10)
                    }
                    .animation(nil)
                    .frame(height: 20)
                }
                Spacer()
                HStack {
                    ForEach(self.factorTypes.indices, id: \.self) { factorIndex in
                        Button(action: {
                            if self.factorSelected == factorIndex {
                                self.factorSelected = nil
                            } else {
                                self.factorSelected = factorIndex
                            }
                        }) {
                            Text(self.factorTypes[factorIndex].name ?? "")
                                .defaultFont(10)
                                .padding(self.factorSelected == factorIndex ? 8 : 4)
                                .background(
                                    Capsule()
                                        .foregroundColor(self.colors[factorIndex])
                            )
                        }
                        .foregroundColor(Color("Highlight"))
                    }
                }
                .padding()
            }
        }
    }
    var dataPoints: some View {
        func zIndex(_ index: Int) -> Double {
            return index == self.detailPopup ? 500 : 10
        }
        // Data points
        return GeometryReader { proxy in
            ForEach(self.data.indices, id: \.self) { index in
                Button(action: {
                    if self.detailPopup == index {
                        self.detailPopup = nil
                    } else {
                        self.detailPopup = index
                    }
                }) {
                    ZStack {
                        Circle()
                            .foregroundColor(Color("Standard"))
                            .frame(width: index == self.detailPopup ? 30 : 20, height: index == self.detailPopup ? 30 : 20)
                        ForEach(self.stats[index].factorTypes.indices, id: \.self) { factorIndex in
                            self.factorTypeColor(index, factorIndex)
                        }
                        Circle()
                            .foregroundColor(Color("LowContrast"))
                            .frame(width: index == self.detailPopup ? 25 : 15, height: index == self.detailPopup ?  25 : 15)
                        Circle()
                            .foregroundColor(Color("Highlight"))
                            .frame(width: 10, height: 10)
                    }
                }
                .position(
                    x: self.xOffset(index: index, width: proxy.size.width),
                    y: self.yOffset(height: proxy.size.height, value: self.data[index])
                )
                .zIndex(zIndex(index))
            }
        }
    }
    
    func factorTypeColor(_ statIndex: Int, _ factorIndex: Int!) -> some View {
        let size = CGFloat(1) / CGFloat(self.stats[statIndex].factorTypes.count)
        let offset = CGFloat(factorIndex) * size
        let indexOfFactorInAllFactors = factorTypes.firstIndex(of: stats[statIndex].factorTypes[factorIndex]) ?? 0
        let from: CGFloat
        let to: CGFloat
        if factorSelected != nil && factorSelected == indexOfFactorInAllFactors {
            from = 0
            to = 1
        } else if factorSelected != nil {
            from = 0
            to = 0
        } else {
            from = offset
            to = offset + size
        }
        return Circle()
            .trim(from: from, to: to)
            .stroke(colors[indexOfFactorInAllFactors], style: StrokeStyle(lineWidth: statIndex == detailPopup ? 30 : 10, lineCap: .round))
            .frame(width: statIndex == detailPopup ? 100 : 15, height: statIndex == detailPopup ?  100 : 15)
    }
    
    let graphPadding: CGFloat = 100.0
    
    func xOffset(index: Int, width: CGFloat) -> CGFloat {
        (((width - graphPadding) / CGFloat(data.count + 1)) * CGFloat(index + 1)) + (graphPadding / 2)
    }
    func yOffset(height: CGFloat, value: Double) -> CGFloat {
        height - (graphPadding / 2) - (((height - graphPadding) / CGFloat(range - 1)) * CGFloat(value))
    }
}
