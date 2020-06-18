//
//  Constants.swift
//  shrinkbot
//
//  Created by Ethan John on 3/5/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import UIKit
import SwiftUI

let chillBlue: UIColor = #colorLiteral(red: 0.9126966596, green: 0.9402826428, blue: 0.998428762, alpha: 1)
let deepChillBlue: UIColor = #colorLiteral(red: 0.7379525547, green: 0.8377566145, blue: 0.9988933206, alpha: 1)
let middleChillBlue: UIColor = #colorLiteral(red: 0.8476651309, green: 0.9208347701, blue: 0.9988933206, alpha: 1)
let legendColors = [#colorLiteral(red: 0.7883887887, green: 0.7393109202, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.8194651824, blue: 0.894031874, alpha: 1), #colorLiteral(red: 1, green: 0.9575231352, blue: 0.7737829244, alpha: 1), #colorLiteral(red: 0.7617713751, green: 1, blue: 0.8736094954, alpha: 1), #colorLiteral(red: 1, green: 0.6711962363, blue: 0.9908545294, alpha: 1), #colorLiteral(red: 0.7044421855, green: 0.9814820289, blue: 1, alpha: 1)]

enum EntryDateStyles: String {
    case all = "all"
    case day = "day"
    case week = "week"
    case month = "month"
    case year = "year"
}

enum GraphRangeOptions: String, CaseIterable {
    case allTime = "All"
    case thisYear = "Year"
    case thisMonth = "Month"
    case thisWeek = "Week"
    case today = "Today"
}

enum Frequency: Int16 {
    case daily
    case weekly
}

let day = TimeInterval(exactly: 86400)!
let week = TimeInterval(exactly: 604800)!
let month = TimeInterval(exactly: 2629800)!
let year = TimeInterval(exactly: 31557600)!

enum Rating: Int, CaseIterable {
    case realBad
    case bad
    case meh
    case good
    case realGood
    
    func imageString() -> String {
        switch self {
        case .realBad:
            return "SBA"
        case .bad:
            return "BA"
        case .meh:
            return "NA"
        case .good:
            return "GA"
        case .realGood:
            return "SGA"
        }
    }
    
    func color() -> Color {
        switch self {
        case .realBad:
            return Color(red: 141 / 255, green: 170 / 255, blue: 204 / 255)
        case .bad:
            return Color(red: 172 / 255, green: 200 / 255, blue: 233 / 255)
        case .meh:
            return Color(red: 232 / 255, green: 232 / 255, blue: 232 / 255)
        case .good:
            return Color(red: 206 / 255, green: 228 / 255, blue: 253 / 255)
        case .realGood:
            return Color(red: 229 / 255, green: 241 / 255, blue: 254 / 255)
        }
    }
}
