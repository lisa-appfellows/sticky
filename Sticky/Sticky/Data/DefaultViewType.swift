//
//  DefaultViewType.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-07.
//

import SwiftUI

@Observable
final class DefaultViewType {
    private let storageKey = "defaultViewType"
    private let defaults: UserDefaults

    var value: ViewType {
        get { get() }
        set { set(newValue) }
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    private func set(_ value: ViewType) {
        defaults.set(value.rawValue, forKey: storageKey)
    }

    private func get() -> ViewType {
        if let rawValue = defaults.string(forKey: storageKey),
           let viewType = ViewType(rawValue: rawValue) {
            return viewType
        }
        
        let new = ViewType.list
        set(new)
        return new
    }
}
