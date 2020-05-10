//
//  EntryStats.swift
//  shrinkbot
//
//  Created by Ethan John on 2/19/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import Foundation

class EntryStats {
    let name: String
    let ratingCount: Int
    let averageRating: Double
    let factorTypes: [FactorType]
    let factorTypeCounts: [FactorType: Int]
    
    init(name: String, ratingCount: Int, averageRating: Double, factorTypes: [FactorType], factorTypeCounts: [FactorType: Int]) {
        self.name = name
        self.ratingCount = ratingCount
        self.averageRating = averageRating
        self.factorTypes = factorTypes
        self.factorTypeCounts = factorTypeCounts
    }
}

extension EntryStats: Equatable {
    
    static func == (lhs: EntryStats, rhs: EntryStats) -> Bool {
        return lhs.name == rhs.name && lhs.averageRating == rhs.averageRating && lhs.ratingCount == rhs.ratingCount && lhs.factorTypes == rhs.factorTypes
    }
}
