//
//  GraphCapsule.swift
//  graphView
//
//  Created by Ethan John on 9/29/19.
//

import SwiftUI

struct GraphCapsule: View {
	var index: Int
	var height: CGFloat
	var range: Range<Double>
	var overallRange: Range<Double>
	
	var heightRatio: CGFloat {
        CGFloat(magnitude(of: range) / magnitude(of: overallRange))
	}
	var offset: CGFloat {
		CGFloat(range.lowerBound - overallRange.lowerBound) / CGFloat(magnitude(of: overallRange))
	}
	
	func magnitude(of range: Range<Double>) -> Double {
		range.upperBound - range.lowerBound
	}
	var body: some View {
		Capsule()
			.frame(height: height * heightRatio)
			.offset(x: 0, y: height * -offset)
			.animation(.laggySpring(index: index))
	}
}

struct GraphCapsule_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
