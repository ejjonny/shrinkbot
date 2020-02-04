//
//  GraphView.swift
//  graphView
//
//  Created by Ethan John on 9/21/19.
//

import SwiftUI

struct GraphView: View {
    var data: [Double]
    let range = 5
    
    var body: some View {
        return GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color("LowContrast"))
//                Grid(yCount: self.range, xCount: self.data.indices.count, height: geometry.size.height, width: geometry.size.width)
//                    .padding(8)
                ForEach(self.data.indices, id: \.self) { index in
                        ZStack {
                            GeometryReader { proxy in
                            Circle()
                                .frame(width: 20, height: 20)
                                .position(
                                    x: self.xOffset(index: index, width: proxy.size.width),
                                    y: self.yOffset(index: index, height: proxy.size.height)
                            )
                        }
                    }
                        .padding(8)
                }
            }
        }
    }
    
    func xOffset(index: Int, width: CGFloat) -> CGFloat {
        (((width - 16) / CGFloat(data.count + 1)) * CGFloat(index + 1)) + 8
    }
    func yOffset(index: Int, height: CGFloat) -> CGFloat {
        height - 8 - (((height - 16) / CGFloat(range)) * CGFloat(self.data[index]))
    }
}

let testData: [Double] = [0.0, 1.0]
let newTestData: [Double] = [2.8, 4.0, 2.5, 3.5, 4.0, 4.0]

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GraphView(data: testData)
            GraphView(data: newTestData)
        }
    }
}
