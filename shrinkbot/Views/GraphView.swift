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
		guard !data.isEmpty else { return 0..<0 }
		let low = data.lazy.map { $0.lowerBound }.min()!
		let high = data.lazy.map { $0.upperBound }.max()!
		return low..<high
	}
	
	var body: some View {
		let overallRange = rangeOfData
		return GeometryReader { geometry in
			ZStack {
				Grid(yCount: Int(overallRange.upperBound.rounded()) - 1, xCount: self.data.indices.count - 1, height: geometry.size.height, width: geometry.size.width)
				HStack(alignment: .bottom, spacing: geometry.size.width / 100) {
					ForEach(self.data.indices, id: \.self) { index in
						GraphCapsule(index: index, height: geometry.size.height, range: self.data[index], overallRange: overallRange)
					}
					.frame(height: geometry.size.height, alignment: .bottom)
				}
			}
		}
	}
}

let testData: [Range<Double>] = [0.0..<1.0, 1.0..<2.0, 2.0..<3.0, 3.0..<4.0, 4.0..<5.0, 2.0..<4.0, 1.0..<5.0, 0.0..<2.8, 4.8..<5.0, 2.0..<2.5, 2.0..<3.5, 4.2..<5.0, 1.0..<5.0]
let newTestData: [Range<Double>] = [0.0..<2.8, 4.8..<5.0, 2.0..<2.5, 2.0..<3.5, 4.2..<5.0, 1.0..<5.0]
