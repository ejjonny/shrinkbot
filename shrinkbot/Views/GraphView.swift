//
//  GraphView.swift
//  graphView
//
//  Created by Ethan John on 9/21/19.
//

import SwiftUI

struct GraphView: View {
    var data: [Range<Double>]
    var rangeOfData: Range<Double> {
        guard !data.isEmpty else { return 0..<1 }
        let low = data.lazy.map { $0.lowerBound }.min()!
        let high = data.lazy.map { $0.upperBound }.max()!
        return low..<high
    }
    
    var body: some View {
        let overallRange = rangeOfData
        return GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Rating.good.color().opacity(0.5))
                Grid(yCount: Int(overallRange.upperBound.rounded() + 1), xCount: self.data.indices.count, height: geometry.size.height, width: geometry.size.width)
                    .padding(8)
//                HStack(spacing: CGFloat(10 / max(CGFloat(self.data.count), 0.1))) {
//                    ForEach(self.data.indices, id: \.self) { index in
//                        HStack {
//                            Spacer(minLength: 0)
//                            GraphCapsule(index: index, height: geometry.size.height, range: self.rangeAt(index), overallRange: overallRange)
//                            Spacer(minLength: 0)
//                        }
//                        .frame(height: geometry.size.height, alignment: .bottom)
//                    }
//                }
//                .padding(8)
            }
        }
    }
    func rangeAt(_ index: Int) -> Range<Double> {
        let range = data[index]
        return range
    }
}

let testData: [Range<Double>] = [0.0..<0.0, 1.0..<1.0]
//, 2.0..<3.0, 3.0..<4.0, 4.0..<5.0, 2.0..<4.0, 1.0..<5.0, 0.0..<2.8, 4.8..<5.0, 2.0..<2.5, 2.0..<3.5, 4.2..<5.0, 1.0..<5.0]
let newTestData: [Range<Double>] = [0.0..<2.8, 3.99..<4.0, 2.0..<2.5, 2.0..<3.5, 4.0..<4.0, 1.0..<4.0]

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GraphView(data: testData)
            GraphView(data: newTestData)
        }
    }
}
