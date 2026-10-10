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
    private let defaults: UserDefaults

    var colorFilter: NoteColor? {
        didSet {
           saveNoteColor(colorFilter)
        }
    }

    var sortOption: SortOption {
        didSet {
            saveSortOption(sortOption)
        }
    }

    var viewType: ViewType {
        didSet {
            saveViewType(viewType)
        }
    }

    var predicate: Predicate<NoteModel>? {
        guard let colorFilterName = colorFilter?.rawValue else {
            return nil
        }
        return #Predicate { $0.noteColorName == colorFilterName }
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.colorFilter = .init(rawValue: DefaultsStorage.noteColor.load(from: defaults))
        self.sortOption = .init(rawValue: DefaultsStorage.sortOption.load(from: defaults)) ?? .newest
        self.viewType = .init(rawValue: DefaultsStorage.viewType.load(from: defaults)) ?? .list
    }

    private func saveNoteColor(_ noteColor: NoteColor?) {
        let storage = DefaultsStorage.noteColor
        if let noteColor {
            storage.set(noteColor.rawValue, to: defaults)
        } else {
            storage.remove(from: defaults)
        }
    }

    private func saveSortOption(_ option: SortOption) {
        DefaultsStorage.sortOption.set(option.rawValue, to: defaults)
    }

    private func saveViewType(_ viewType: ViewType) {
        DefaultsStorage.viewType.set(viewType.rawValue, to: defaults)
    }
}
