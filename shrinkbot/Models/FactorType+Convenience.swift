//
//  FactorType+Convenience.swift
//  shrinkbot
//
//  Created by Ethan John on 2/1/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import Foundation
import CoreData
import SwiftUI

extension FactorType {
    @discardableResult
    convenience init(name: String, card: Card, moc: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: moc)
        self.name = name
        self.card = card
    }
}

struct FactorTypeColors {
    var colors: [Color] {
        [
        Color("1"),
        Color("2"),
        Color("3"),
        Color("4"),
        Color("5"),
        Color("6"),
        Color("7"),
        Color("8")
    ]
    }
}
