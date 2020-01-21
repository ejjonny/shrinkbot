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
        max(CGFloat(magnitude(of: range) / magnitude(of: overallRange)), 1 / 5)
    }
    var offset: CGFloat {
        CGFloat(range.lowerBound - overallRange.lowerBound) / CGFloat(magnitude(of: overallRange))
    }
    
    func magnitude(of range: Range<Double>) -> Double {
        range.upperBound - range.lowerBound
    }
    var body: some View {
        Capsule()
            .frame(height: self.height * self.heightRatio)
            .offset(y: self.height * -self.offset)
            .animation(.laggySpring(index: self.index))
    }
}

struct GraphCapsule_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
