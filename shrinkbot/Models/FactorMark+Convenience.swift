//
//  FactorMark+Convenience.swift
//  shrinkbot
//
//  Created by Ethan John on 2/14/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import Foundation
import CoreData

extension FactorMark {
    @discardableResult
    convenience init(name: String, entry: Entry, type: FactorType, moc: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: moc)
        self.name = name
        self.entry = entry
        self.type = type
    }
}
