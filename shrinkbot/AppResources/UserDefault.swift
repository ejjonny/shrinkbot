//
//  UserDefault.swift
//  shrinkbot
//
//  Created by Ethan John on 6/18/20.
//  Copyright © 2020 Ethan John. All rights reserved.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T

    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

struct Defaults {
    @UserDefault("timesUsed", defaultValue: 0)
    static var timesUsedEntryButton: Int
}
