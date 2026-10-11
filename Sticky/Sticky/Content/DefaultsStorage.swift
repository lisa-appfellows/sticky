//
//  DefaultsStorage.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-10.
//

import Foundation

enum DefaultsStorage: String {
    case noteColor
    case sortOption
    case viewType

    var key: String {
        "defaults_\(rawValue)"
    }

    func load(from defaults: UserDefaults) -> String {
        defaults.string(forKey: self.key) ?? ""
    }

    func set(_ value: String, to defaults: UserDefaults) {
        defaults.set(value, forKey: self.key)
    }

    func remove(from defaults: UserDefaults) {
        defaults.removeObject(forKey: self.key)
    }
}
