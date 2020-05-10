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
    var titleString: String {
        switch selection {
        case .realGood:
            return "Really Good"
        case .good:
            return "Pretty Good"
        case .meh:
            return "Fine"
        case .bad:
            return "Not Great"
        case .realBad:
            return "Really Bad"
        case .none:
            return "This isn't supposed to show up"
        }
    }
    var body: some View {
        VStack(spacing: 0) {
            ModalHandle()
            HStack {
            Text("Add factors to your journal entry that might have made a difference")
                .defaultFont(25)
                .padding()
                Spacer()
            }
            HStack {
                Text(titleString)
                    .defaultFont(15)
                    .padding([.leading, .trailing, .bottom])
                Spacer()
            }
            Divider()
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
                                .foregroundColor(Color("LowContrast"))
                                .shadow(color: Color.black.opacity(0.1), radius: 5, y: 5)
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(self.selectedIndexes.contains(index) ? Color.black : Color("Standard"), style: StrokeStyle(lineWidth: self.selectedIndexes.contains(index) ? 8 : 3))
                            Text(self.factorTypes[index].name!)
                                .defaultFont(12)
                        }
                        .frame(height: 60)
                        .padding([.leading, .trailing, .top], 8)
                    }
                    .buttonStyle(BubbleButton())
                }
            }
            Spacer()
            DoneButton {
                CardController.shared.createEntry(ofRating: Double(self.selection!.rawValue), types: self.selectedIndexes.map { self.factorTypes[$0] })
                self.selection = nil
                self.expanded = false
                self.xOffset = 0
                self.presentation.wrappedValue.dismiss()
            }
            .frame(width: 100, height: 100)
            .padding()
            .padding([.bottom], 30)
        }
        .background(Color("Background"))
        .edgesIgnoringSafeArea([.bottom])
    }
}
