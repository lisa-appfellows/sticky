//
//  ContentVM.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-07.
//

import SwiftData
import SwiftUI

@Observable
final class ContentVM {
    private static let viewTypeKey = "defaultViewType"
    private let defaults: UserDefaults

    var predicate: Predicate<NoteModel>?
    var colorFilter: NoteColor?
    private(set) var viewType: ViewType

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults

        let rawViewType = defaults.string(forKey: Self.viewTypeKey)
        self.viewType = ViewType(rawValue: rawViewType ?? "") ?? .list
    }

    func cleanUpOptionSelected(_ option: CleanUpOption) {
        // TODO: CleanUpOption action
    }

    func setViewType(_ viewType: ViewType) {
        defaults.set(viewType.rawValue, forKey: Self.viewTypeKey)
        self.viewType = viewType
    }
}
