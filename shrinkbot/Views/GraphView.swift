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
					.foregroundColor(EntryButton.Selected.good.color())
				Grid(yCount: Int(overallRange.upperBound.rounded()), xCount: self.data.indices, height: geometry.size.height, width: geometry.size.width)
					.padding(8)
				HStack {
					ForEach(self.data.indices, id: \.self) { index in
						HStack {
							Spacer(minLength: 0)
							GraphCapsule(index: index, height: geometry.size.height, range: self.rangeAt(index), overallRange: overallRange)
							Spacer(minLength: 0)
						}
						.frame(height: geometry.size.height, alignment: .bottom)
					}
				}
				.padding(8)
			}
		}
	}
	func rangeAt(_ index: Int) -> Range<Double> {
		let range = data[index]
		guard !range.isEmpty else {
			return range.lowerBound * 0.8..<range.lowerBound * 0.8 + 0.8
		}
		return range
	}
}

let testData: [Range<Double>] = [0.0..<1.0, 1.0..<2.0]
//, 2.0..<3.0, 3.0..<4.0, 4.0..<5.0, 2.0..<4.0, 1.0..<5.0, 0.0..<2.8, 4.8..<5.0, 2.0..<2.5, 2.0..<3.5, 4.2..<5.0, 1.0..<5.0]
let newTestData: [Range<Double>] = [0.0..<2.8, 4.8..<5.0, 2.0..<2.5, 2.0..<3.5, 4.2..<5.0, 1.0..<5.0]

struct GraphView_Previews: PreviewProvider {
	static var previews: some View {
		GraphView(data: testData)
	}
}
