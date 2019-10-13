//
//  InsightStack.swift
//  shrinkbot
//
//  Created by Ethan John on 10/8/19.
//  Copyright © 2019 Ethan John. All rights reserved.
//

import SwiftUI

struct InsightStack: View {
    var spacing: CGFloat
    @State var insights: [Insight] = [Insight]()
    @Binding var cardController: CardController
    var body: some View {
        VStack(spacing: spacing) {
            Text("sldjk")
        }
        .onAppear {
            self.loadInsights()
        }
    }
    func loadInsights() {
        
    }
}

struct InsightStack_Previews: PreviewProvider {
    static var previews: some View {
<<<<<<< HEAD
		InsightStack(spacing: 20, cardController: .constant(CardController.shared))
=======
        InsightStack(spacing: 20, cardController: .constant(CardController.shared))
>>>>>>> 4cb8df7501866d6e5a5450a1a48f65705ed59df5
    }
}
