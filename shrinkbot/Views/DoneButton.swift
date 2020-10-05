//
//  DoneButton.swift
//  shrinkbot
//
//  Created by Ethan John on 5/9/20.
//  Copyright © 2020 Ethan John. All rights reserved.
//

import SwiftUI

struct DoneButton: View {
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .foregroundColor(Color("LowContrast"))
                Circle()
                    .stroke(Color("Standard"), lineWidth: 8)
                Image(systemName: "checkmark")
                    .resizable()
                    .scaledToFit()
                    .accentColor(Color("Standard"))
                    .defaultFont(10, weight: .heavy)
                    .padding(35)
            }
        }
        .buttonStyle(BubbleButton())
    }
}
