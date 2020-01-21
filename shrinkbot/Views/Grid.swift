//
//  Grid.swift
//  graphView
//
//  Created by Ethan John on 9/29/19.
//

import SwiftUI

struct Grid: View {
    var yCount: Int
    var xCount: Int
    var height: CGFloat
    var width: CGFloat
    var body: some View {
        ZStack {
            VStack {
                ForEach(0..<yCount, id: \.self) { _ in
                    VStack {
                        Spacer(minLength: 0)
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color.gray.opacity(0.3))
                        Spacer(minLength: 0)
                    }
                }
            }
            HStack {
                ForEach(0..<xCount, id: \.self) { index in
                    HStack {
                        Spacer(minLength: 0)
                        Rectangle()
                            .frame(width: 1)
                            .foregroundColor(Color.gray.opacity(0.3))
                        Spacer(minLength: 0)
                    }
                }
            }
        }
    }
}

struct Grid_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Grid(yCount: 4, xCount: 4, height: 200, width: 200)
            Grid(yCount: 1, xCount: 1, height: 200, width: 200)
        }
    }
}
