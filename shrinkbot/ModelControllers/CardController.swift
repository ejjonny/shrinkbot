//
//  CardController.swift
//  shrinkbot
//
//  Created by Ethan John on 2/7/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import Foundation
import CoreData
import Combine

class CardController: ObservableObject {
    
    var entryDateStyle: EntryDateStyles = .day
    
    // Singleton
    static var shared = CardController()
    
    @Published var cards: [Card] = []
    @Published var activeCardEntries: [Entry] = []
    @Published var activeCard: Card?
    
    func refreshActiveCard() {
        activeCard = findActiveCard()
        refreshActiveCardEntries()
    }
    
    func findActiveCard() -> Card {
        let activeArray = cards.filter{ $0.isActive == true }
        
        // Make sure datasource has cards, if not make a default card.
        if cards.isEmpty {
            let card = createCard(named: "My Mood")
            createFactorType(withName: "Slept Bad", onCard: card)
            createFactorType(withName: "Exercised", onCard: card)
            return card
        }
        
        if activeArray.count > 1 || activeArray.count == 0 {
            // Deactivate all & set last to active and return it if there are more than one active cards.
            if activeArray.count == 0 {
                print("No active cards")
            } else if activeArray.count > 1 {
                print("Error: Multiple active cards")
            }
            for card in activeArray {
                card.isActive = false
            }
            if let last = cards.last {
                last.isActive = true
                return last
            }
            CoreDataManager.saveToPersistentStore()
            
        } else if activeArray.count == 1, let first = activeArray.first {
            // If there is one active card return it. All is well.
            return first
        }
        // Last resort
        print("Error: active card computed property should cover all cases.")
        let card = createCard(named: "My Mood")
        createFactorType(withName: "Slept Bad", onCard: card)
        createFactorType(withName: "Exercised", onCard: card)
        return card
    }
    
    var activeCardFactorTypes: [FactorType] {
        guard let array = activeCard?.factorTypes?.array as? [FactorType] else { print("Unable to cast set as factor types."); return []}
        return array
    }
    
    // MARK: - Card control
    func createCard(named name: String) -> Card {
        let card = Card(name: name)
        self.setActive(card: card)
        CoreDataManager.saveToPersistentStore()
        refreshActiveCard()
        return card
    }
    
    func renameActiveCard(withName name: String) {
        self.activeCard?.name = name
        CoreDataManager.saveToPersistentStore()
        refreshActiveCard()
    }
    
    func deleteActiveCard(completion: ((Bool) -> Void)?) {
        guard let card = activeCard else { completion?(false) ; return }
        CoreDataStack.context.delete(card)
        CoreDataManager.saveToPersistentStore()
        refreshActiveCard()
        completion?(true)
    }
    
    func setActive(card: Card) {
        // If there is currently an active card deactivate it.
        for card in cards {
            if card.isActive {
                card.isActive = false
            }
        }
        card.isActive = true
        CoreDataManager.saveToPersistentStore()
        refreshActiveCard()
    }
    
    // MARK: - FactorType control
    func createFactorType(withName name: String, onCard card: Card? = nil) {
        guard let card = activeCard, let factorTypeCount = card.factorTypes?.count else { print("Card does not have any factor types."); return }
        if factorTypeCount < 6 {
            FactorType(name: name, card: card)
        } else {
            print("ERROR: Tried to save a factor when all factors on active card were full. Factor was not saved.")
        }
        CoreDataManager.saveToPersistentStore()
    }
    
    func renameFactorType(_ factorType: FactorType, withName name: String) {
        factorType.name = name
        CoreDataManager.saveToPersistentStore()
    }
    
    func deleteFactorType(_ factorType: FactorType) {
        CoreDataStack.context.delete(factorType)
        CoreDataManager.saveToPersistentStore()
    }
    
    func createFactorMark(ofType type: FactorType, onEntry entry: Entry) {
        guard let name = type.name else { print("FactorType name was nil. Entry not created"); return }
        FactorMark(name: name, entry: entry, type: type)
        CoreDataManager.saveToPersistentStore()
    }
    
    // MARK: - FactorMark Control
    func getMarks(entry: Entry) -> [FactorMark] {
        guard let array = entry.factorMarks?.array else { print("Unable to get mark objects from entry") ; return [] }
        let marks = array.compactMap{ $0 as? FactorMark }
        return marks
    }
    
    // MARK: - Entry Control
    /// Should be used for getting the last day / week / month / year of entry statistics
    func entriesWith(graphViewStyle: GraphRangeOptions) -> [EntryStats] {
        var stats: [EntryStats] = []
        var grouped: [[Entry]] = []
        var name: String = ""
        var dateFormat: (Date) -> () -> String = Date.asString
        switch graphViewStyle {
        case .allTime:
            let filtered = getRecentEntriesIn(interval: .all)
            grouped = getEntries(entries: filtered, groupedBy: .day)
            dateFormat = Date.asGenericUseString
        case .thisMonth:
            let filtered = getRecentEntriesIn(interval: .month)
            grouped = getEntries(entries: filtered, groupedBy: .day)
            dateFormat = Date.asMonthSpecificString
        case .thisWeek:
            let filtered = getRecentEntriesIn(interval: .week)
            grouped = getEntries(entries: filtered, groupedBy: .day)
            dateFormat = Date.asWeekSpecificString
        case .thisYear:
            let filtered = getRecentEntriesIn(interval: .year)
            grouped = getEntries(entries: filtered, groupedBy: .month)
            dateFormat = Date.asYearSpecificString
        case .today:
            let filtered = getRecentEntriesIn(interval: .day)
            grouped = getEntries(entries: filtered, groupedBy: .all)
            dateFormat = Date.asDaySpecificString
        }
        for group in grouped {
            if let date = group.first?.date {
                name = dateFormat(date)()
            }
            var markTypes = [FactorType]()
            group.forEach{
                let marksArray = $0.factorMarks?.array as! [FactorMark]
                for mark in marksArray {
                    guard let type = mark.type,
                        !markTypes.contains(type) else { continue }
                    markTypes.append(type)
                }
            }
            // This filters out entries saved with only a factor & no rating so that data isn't skewed.
            let ratings = group.map { $0.rating }
            if let upperBound = ratings.max(), let lowerBound = ratings.min() {
                let stat = EntryStats(name: name, ratingCount: group.count, ratingRange: lowerBound..<upperBound, factorTypes: markTypes)
                stats.append(stat)
            }
        }
        return stats
    }
    
    /// Should be used for getting grouped statistics.
    func entriesWith(dateStyle: EntryDateStyles) -> [EntryStats] {
        var stats: [EntryStats] = []
        for group in getEntries(groupedBy: dateStyle) {
            let ratings = group.map{ $0.rating }
            var name = ""
            guard let date = group.first?.date else { print("Error compiling entries by date") ; return [] }
            switch dateStyle {
            case .all:
                name = date.asTimeSpecificString()
            case .day:
                name = date.asString()
            case .month:
                name = date.asMonthSpecificString()
            case .week:
                break
            case .year:
                break
            }
            if let upperBound = ratings.max(), let lowerBound = ratings.min() {
                stats.append(EntryStats(name: name, ratingCount: group.count, ratingRange: lowerBound..<upperBound, factorTypes: []))
            }
        }
        return stats.reversed()
    }
    
    /// For getting entries grouped by an interval relative to current date
    /// Ex. Last 24 hours for example would need to be grouped relative to current date so that grouping at 12:01am will still include a full day rather than just the calendar day that started at 12am
    func entriesGroupedByInterval(dateStyle: EntryDateStyles) -> [[Entry]] {
        guard let entrySet = activeCard?.entries else { return [[]] }
        let entries = entrySet.compactMap{ $0 as? Entry}
        var grouped: [Date :[Entry]] = [:]
        switch dateStyle {
        case .all:
            return [entries]
        case .day:
            grouped = group(entries: entries, byInterval: day)
        case .week:
            grouped = group(entries: entries, byInterval: week)
        case .month:
            grouped = group(entries: entries, byInterval: month)
        case .year:
            grouped = group(entries: entries, byInterval: year)
        }
        return grouped.map{ $0.value }.sorted(by: { (arrayOne, arrayTwo) -> Bool in
            guard let firstDate = arrayOne.first?.date,
                let secondDate = arrayTwo.first?.date else { print("Failed to sort") ; return true }
            return firstDate.compare(secondDate) == ComparisonResult.orderedAscending
        })
    }
    
    private func group(entries: [Entry], byInterval interval: TimeInterval) -> [Date: [Entry]]{
        var grouped: [Date: [Entry]] = [:]
        let reversed = Array(entries.reversed())
        guard let firstObject = reversed.first,
            var firstDateInGroup = firstObject.date else { print("First Obj didn't exist or didn't have a date when grouping") ; return [:] }
        for i in reversed.indices {
            guard let date = reversed[i].date else { print("An entry was missing a date") ; return [:] }
            if grouped[firstDateInGroup] != nil, abs(date.timeIntervalSince(firstDateInGroup)) <= interval {
                grouped[firstDateInGroup]!.append(reversed[i])
            } else {
                firstDateInGroup = date
                grouped[firstDateInGroup] = [reversed[i]]
            }
        }
        return grouped
    }
    
    func getRecentEntriesIn(entries: [Entry] = [], interval: EntryDateStyles) -> [Entry] {
        var entryArray = entries
        if entryArray.isEmpty {
            entryArray = activeCardEntries
        }
        var period = DateInterval()
        switch interval {
        case .year:
            guard let startOfInterval = Calendar.current.date(byAdding: .year, value: -1, to: Date()) else { return [] }
            period = DateInterval(start: startOfInterval, end: Date())
        case .month:
            guard let startOfInterval = Calendar.current.date(byAdding: .month, value: -1, to: Date()) else { return [] }
            period = DateInterval(start: startOfInterval, end: Date())
        case .week:
            guard let startOfInterval = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date()) else { return [] }
            period = DateInterval(start: startOfInterval, end: Date())
        case .day:
            guard let startOfInterval = Calendar.current.date(byAdding: .day, value: -1, to: Date()) else { return [] }
            period = DateInterval(start: startOfInterval, end: Date())
        default:
            break
        }
        return entryArray.filter {
            guard let date = $0.date else { print("An entry was missing a date") ; return false }
            return period.contains(date)
        }
    }
    
    /// For getting entries grouped by a calendar period of time.
    /// Ex. With .day you would recieve entries on April 25th, 26th, 27th etc. regardless of current date / time
    func getEntries(entries: [Entry] = [], groupedBy dateStyle: EntryDateStyles) -> [[Entry]] {
        var input = entries
        if entries.isEmpty {
            guard let cardEntries = activeCard?.entries else { return [[]] }
            input = cardEntries.map{ $0 as! Entry}
        }
        let calendar = Calendar.current
        let grouped: [DateComponents:[Entry]]
        switch dateStyle {
        case .all:
            grouped = Dictionary(grouping: input, by: {
                calendar.dateComponents([.second,.minute,.day,.month,.year], from: $0.date!)
            })
        case .day:
            grouped = Dictionary(grouping: input, by: {
                calendar.dateComponents([.day, .month, .year], from: $0.date!)
            })
        case .week:
            grouped = Dictionary(grouping: input, by: {
                calendar.dateComponents([.weekOfYear], from: $0.date!)
            })
        case .month:
            grouped = Dictionary(grouping: input, by: {
                calendar.dateComponents([.month, .year], from: $0.date!)
            })
        case .year:
            grouped = Dictionary(grouping: input, by: {
                calendar.dateComponents([.year], from: $0.date!)
            })
        }
        return grouped.map{ $0.value }.sorted() { (arrayOne, arrayTwo) -> Bool in
            guard let firstDate = arrayOne.first?.date,
                let secondDate = arrayTwo.first?.date else { print("Failed to sort") ; return true }
            return firstDate.compare(secondDate) == ComparisonResult.orderedAscending
        }
    }
    
    func createEntry(ofRating rating: Double, types: [FactorType]) {
        guard let activeCard = activeCard else { return }
        let entry = Entry(rating: rating, onCard: activeCard)
        for type in types {
            guard let name = type.name else { print("Name on factor type was nil. Mark not created."); return }
            FactorMark(name: name, entry: entry, type: type)
        }
        CoreDataManager.saveToPersistentStore()
        refreshActiveCardEntries()
    }
    
    func delete(entry: Entry) {
        CoreDataStack.context.delete(entry)
        CoreDataManager.saveToPersistentStore()
        refreshActiveCardEntries()
    }
    
    func refreshActiveCardEntries() {
        guard let entries = activeCard?.entries?.array as? [Entry] else { print("There was an error with OrderedSet to Array conversion") ; return }
        activeCardEntries = entries
    }
}

