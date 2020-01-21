//
//  EntryModal.swift
//  shrinkbot
//
//  Created by Ethan John on 10/2/19.
//  Copyright © 2019 Ethan John. All rights reserved.
//

import SwiftUI

struct EntryModal: View {
    @Environment(\.presentationMode) var presentation
    @State var selectedIndexes = [Int]()
    @Binding var selection: Rating?
    @Binding var expanded: Bool
    @Binding var xOffset: CGFloat
    var factorTypes = [FactorType]()
//    var selectionColor: Color {
//        switch selection {
//        case .realBad:
//            return Color(red: 141 / 255, green: 170 / 255, blue: 204 / 255)
//        case .bad:
//            return Color(red: 172 / 255, green: 200 / 255, blue: 233 / 255)
//        case .meh:
//            return Color(red: 232 / 255, green: 232 / 255, blue: 232 / 255)
//        case .good:
//            return Color(red: 206 / 255, green: 228 / 255, blue: 253 / 255)
//        case .realGood:
//            return Color(red: 229 / 255, green: 241 / 255, blue: 254 / 255)
//        case .none:
//            return Color.clear
//        }
//    }
    var body: some View {
        VStack {
            Rectangle()
                .foregroundColor(Color("Standard"))
                .frame(height: 20)
            Text("Add factors to your journal entry")
                .font(.system(size: 25, weight: Font.Weight.medium))
                .frame(height: 70, alignment: .center)
            ZStack {
                ScrollView([.vertical], showsIndicators: false) {
                    ForEach(factorTypes.indices, id: \.self) { index in
                        Button(action: {
                            if self.selectedIndexes.contains(index) {
                                let removalIndex = self.selectedIndexes.firstIndex(of: index)!
                                self.selectedIndexes.remove(at: removalIndex)
                            } else {
                                self.selectedIndexes.append(index)
                            }
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color("Standard"))
                                    .shadow(color: Color.black.opacity(0.2), radius: 10, y: 10)
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(lineWidth: self.selectedIndexes.contains(index) ? 8 : 0)
                                Text(self.factorTypes[index].name!)
                                    .font(.system(size: 20))
                            }
                            .frame(height: 100)
                            .padding()
                        }
                        .buttonStyle(BubbleButton())
                    }
                }
            }
            Spacer()
            Button(action: {
                CardController.shared.createEntry(ofRating: Double(self.selection!.rawValue), types: self.selectedIndexes.map { self.factorTypes[$0] })
                self.selection = nil
                self.expanded = false
                self.xOffset = 0
                self.presentation.wrappedValue.dismiss()
            }) {
                ZStack {
                    Circle()
                        .foregroundColor(Color("LowContrast"))
                    Circle()
                        .stroke(Color("Standard"), lineWidth: 8)
                    Image(systemName: "checkmark")
                        .resizable()
                        .scaledToFit()
                        .accentColor(Color("Standard"))
                        .font(.system(size: 10, weight: .heavy, design: .rounded))
                        .padding(35)
                }
            }
            .buttonStyle(BubbleButton())
            .frame(width: 100, height: 100)
            .padding()
            .padding([.bottom], 30)
        }
        .background(Color("Background"))
        .edgesIgnoringSafeArea([.bottom])
    }
}
