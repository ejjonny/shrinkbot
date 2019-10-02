//
//  Extensions.swift
//  graphView
//
//  Created by Ethan John on 9/29/19.
//

import SwiftUI

typealias Point = CGPoint
extension Point {
	init(_ x: Int, _ y: Int) {
		self.init(x: x, y: y)
	}
	init(_ x: Double, _ y: Double) {
		self.init(x: CGFloat(x), y: CGFloat(y))
	}
	init(_ x: CGFloat, _ y: CGFloat) {
		self.init(x: x, y: y)
	}
}

extension GeometryProxy {
	func bottomLeft() -> Point {
		return Point(frame(in: .local).minX, frame(in: .local).maxY)
	}
	func bottomRight() -> Point {
		return Point(frame(in: .local).maxX, frame(in: .local).maxY)
	}
	func topLeft() -> Point {
		return frame(in: .local).origin
	}
	func topRight() -> Point {
		return Point(frame(in: .local).maxX, frame(in: .local).minY)
	}
}

extension Animation {
	public static func laggySpring(index: Int) -> Animation {
		Animation.spring(dampingFraction: 0.5)
			.speed(2)
			.delay(0.03 * Double(index))
	}
}
