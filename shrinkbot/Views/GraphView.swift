//
//  GraphView.swift
//  graphView
//
//  Created by Ethan John on 9/21/19.
//

import SwiftUI

class GraphState: ObservableObject {
    @Published var detailPopup: Int?
    @Published var factorSelected: Int?
    let colors = FactorTypeColors().colors.shuffled()
}

struct GraphView: View {
    @ObservedObject var graphState: GraphState
    var stats: [EntryStats]
    var data: [Double] {
        stats.map { $0.averageRating }
    }
    let range = 5
    var factorTypes: [FactorType] {
        var typeSet = Set<FactorType>()
        return stats.lazy
            .flatMap(\.factorTypes)
            .reduce(into: [FactorType]()) { current, next in
                if typeSet.insert(next).inserted {
                    current.append(next)
                }
        }
        .map { $0 }
        .sorted { $0.name! < $1.name! }
    }
    let graphOption: GraphRangeOptions
    
    init(graphOption: GraphRangeOptions, graphState: GraphState, stats: [EntryStats]) {
        self.graphOption = graphOption
        self.graphState = graphState
        self.stats = stats
    }
    
    var body: some View {
        VStack {
            if graphState.detailPopup != nil {
                HStack {
                    Text("\(stats[graphState.detailPopup!].name)")
                        .defaultFont(10)
                    Text(String(format: "Avg: %.2f", stats[graphState.detailPopup!].averageRating))
                        .defaultFont(10)
                    Text("\(stats[graphState.detailPopup!].ratingCount) \(stats[graphState.detailPopup!].ratingCount == 1 ? "entry" : "entries")")
                        .defaultFont(10)
                    if graphState.factorSelected != nil {
                        Text("\(factorTypes[graphState.factorSelected!].name ?? "") recorded \(stats[graphState.detailPopup!].factorTypeCounts[factorTypes[graphState.factorSelected!]] ?? 0) times")
                            .defaultFont(10)
                    }
                }
                .animation(nil)
                .frame(height: 20)
                .zIndex(501)
                Spacer()
                    .frame(height: 20)
            }
            ZStack {
                // Horizontal graph lines
                HorizontalLines(graphPadding: self.graphHorizontalPadding, yOffset: self.yOffset, range: self.range)
                // Vertical graph lines
                VerticalLines(graphPadding: self.graphVerticalPadding, xOffset: self.xOffset, indices: self.data.indices)
                dataPoints
            }
            Spacer()
                .frame(height: 20)
            ScrollView([.horizontal], showsIndicators: true) {
                HStack {
                    ForEach(self.factorTypes.indices, id: \.self) { factorIndex in
                        Button(action: {
                            if self.graphState.factorSelected == factorIndex {
                                self.graphState.factorSelected = nil
                            } else {
                                self.graphState.factorSelected = factorIndex
                            }
                        }) {
                            Text(self.factorTypes[factorIndex].name ?? "")
                                .fixedSize(horizontal: true, vertical: false)
                                .defaultFont(10)
                                .padding(self.graphState.factorSelected == factorIndex ? 12 : 7)
                                .background(
                                    ZStack {
                                        Capsule()
                                            .foregroundColor(self.graphState.colors[factorIndex])
                                            .opacity(0.5)
                                        Capsule()
                                            .stroke(self.graphState.colors[factorIndex], style: StrokeStyle(lineWidth: 5))
                                    }
                            )
                        }
                        .foregroundColor(Color("Highlight"))
                    }
                }
                .padding()
                .frame(height: 50)
            }
            .frame(height: 50)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color("LowContrast"))
        )
    }
    var dataPoints: some View {
        func zIndex(_ index: Int) -> Double {
            return index == self.graphState.detailPopup ? 500 : 10
        }
        // Data points
        return GeometryReader { proxy in
            ForEach(self.data.indices, id: \.self) { index in
                Button(action: {
                    if self.graphState.detailPopup == index {
                        self.graphState.detailPopup = nil
                    } else {
                        self.graphState.detailPopup = index
                    }
                }) {
                    ZStack {
                        Circle()
                            .foregroundColor(Color("Standard"))
                            .frame(width: index == self.graphState.detailPopup ? 30 : 20, height: index == self.graphState.detailPopup ? 30 : 20)
                        ForEach(self.stats[index].factorTypes.indices, id: \.self) { factorIndex in
                            self.factorTypeColor(index, factorIndex)
                        }
                        Circle()
                            .foregroundColor(Color("LowContrast"))
                            .frame(width: index == self.graphState.detailPopup ? 25 : 15, height: index == self.graphState.detailPopup ?  25 : 15)
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
        if graphState.factorSelected != nil && graphState.factorSelected == indexOfFactorInAllFactors {
            from = 0
            to = 1
        } else if graphState.factorSelected != nil {
            from = -1
            to = -0.5
        } else {
            from = offset
            to = offset + size
        }
        return Circle()
            .trim(from: from, to: to)
            .stroke(graphState.colors[indexOfFactorInAllFactors], style: StrokeStyle(lineWidth: statIndex == graphState.detailPopup ? 30 : 10, lineCap: .round))
            .frame(width: statIndex == graphState.detailPopup ? 100 : 15, height: statIndex == graphState.detailPopup ?  100 : 15)
    }
    
    let graphVerticalPadding: CGFloat = 1
    let graphHorizontalPadding: CGFloat = 1
    
    func xOffset(index: Int, width: CGFloat) -> CGFloat {
        (((width - graphHorizontalPadding) / CGFloat(data.count + 1)) * CGFloat(index + 1)) + (graphHorizontalPadding / 2)
    }
    func yOffset(height: CGFloat, value: Double) -> CGFloat {
        height - (graphVerticalPadding / 2) - (((height - graphVerticalPadding) / CGFloat(range - 1)) * CGFloat(value))
    }
}
