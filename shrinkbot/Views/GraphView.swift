//
//  GraphView.swift
//  graphView
//
//  Created by Ethan John on 9/21/19.
//

import SwiftUI

struct GraphView: View {
    var stats: [EntryStats]
    var data: [Double] {
        stats.map { $0.averageRating }
    }
    let range = 5
    @Binding var detailPopup: Int?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color("LowContrast"))
            // Horizontal graph lines
            HorizontalLines(graphPadding: self.graphPadding, yOffset: self.yOffset, range: self.range)
            // Vertical graph lines
            VerticalLines(graphPadding: self.graphPadding, xOffset: self.xOffset, indices: self.data.indices)
            // Data points
            GeometryReader { proxy in
                ForEach(self.data.indices, id: \.self) { index in
                    Button(action: {
                        self.detailPopup = index
                    }) {
                        ZStack {
                            Circle()
                                .foregroundColor(Color("Standard"))
                                .frame(width: index == self.detailPopup ? 30 : 20, height: index == self.detailPopup ? 30 : 20)
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
                }
            }
            if detailPopup != nil {
                VStack {
                    HStack {
                        Text("\(stats[detailPopup!].name)")
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                        Text(String(format: "Avg: %.2f", stats[detailPopup!].averageRating))
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                        Text("\(stats[detailPopup!].ratingCount) \(stats[detailPopup!].ratingCount == 1 ? "entry" : "entries")")
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                    }
                    .animation(nil)
                    .frame(height: 20)
                    Spacer()
                }
            }
        }
    }
    
    let graphPadding: CGFloat = 60.0
    
    func xOffset(index: Int, width: CGFloat) -> CGFloat {
        (((width - graphPadding) / CGFloat(data.count + 1)) * CGFloat(index + 1)) + (graphPadding / 2)
    }
    func yOffset(height: CGFloat, value: Double) -> CGFloat {
        height - (graphPadding / 2) - (((height - graphPadding) / CGFloat(range - 1)) * CGFloat(value))
    }
}
