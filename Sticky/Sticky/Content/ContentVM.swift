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

    var colorFilter: NoteColor?
    var currentOperation: CleanUpOption?
    var shouldShowAlert = false
    private(set) var viewType: ViewType

    var predicate: Predicate<NoteModel>? {
        guard let colorFilterName = colorFilter?.rawValue else {
            return nil
        }
        return #Predicate { $0.noteColorName == colorFilterName }
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults

        let rawViewType = defaults.string(forKey: Self.viewTypeKey)
        self.viewType = ViewType(rawValue: rawViewType ?? "") ?? .list
    }

    func retryOperation(context: ModelContext) {
        if shouldShowAlert { shouldShowAlert = false }
        guard let currentOperation else { return }

        cleanUpOptionSelected(currentOperation, context: context)
    }

    func cleanUpOptionSelected(_ option: CleanUpOption, context: ModelContext) {
        currentOperation = option

        do {
            try DataStore.resortModels(byCleanUp: option, context: context)
        } catch {
            // TODO: Logging and Banner presentation
            shouldShowAlert = true
        }
    }

    func cancelOperation() {
        currentOperation = nil
    }

    func setViewType(_ viewType: ViewType) {
        defaults.set(viewType.rawValue, forKey: Self.viewTypeKey)
        self.viewType = viewType
    }
}
