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
        if magnitude(of: overallRange) > 0 {
            if range.isEmpty {
                return 1
            } else {
                return CGFloat(magnitude(of: range) / magnitude(of: overallRange))
            }
        } else {
            return 1
        }
    }
    var offset: CGFloat {
        if magnitude(of: overallRange) > 0 {
            let offset = CGFloat(range.lowerBound - overallRange.lowerBound) / CGFloat(magnitude(of: overallRange))
            if range.isEmpty, offset > 0 {
                return offset - 1
            } else {
                return offset
            }
        } else {
            return 1
        }
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
