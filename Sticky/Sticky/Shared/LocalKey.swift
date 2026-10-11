//
//  LocalKey.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-07.
//

import Foundation

enum LocalKey {
    static let a11yEditNoteHint = makeLocal("a11yEditNoteHint.key")
    static let a11yFilterHint = makeLocal("a11yFilterHint.key")
    static let a11yNoteColorHint = makeLocal("a11yNoteColorHint.key")
    static let a11ySelected = makeLocal("a11ySelected.key")
    static let alertMessage = makeLocal("alertMessage.key")
    static let all = makeLocal("all.key")
    static let blue = makeLocal("blue.key")
    static let cancel = makeLocal("cancel.key")
    static let compact = makeLocal("compact.key")
    static let createNote = makeLocal("createNote.key")
    static let deleteAlertTitle = makeLocal("deleteAlertTitle.key")
    static let deleteNote = makeLocal("deleteNote.key")
    static let done = makeLocal("done.key")
    static let editNote = makeLocal("editNote.key")
    static let emptyNotesMessage = makeLocal("emptyNotesMessage.key")
    static let emptyNotesTitle = makeLocal("emptyNotesTitle.key")
    static let enterTextPlaceholder = makeLocal("enterTextPlaceholder.key")
    static let enterTitlePlaceholder = makeLocal("enterTitlePlaceholder.key")
    static let green = makeLocal("green.key")
    static let grid = makeLocal("grid.key")
    static let list = makeLocal("list.key")
    static let name = makeLocal("name.key")
    static let newest = makeLocal("newest.key")
    static let note = makeLocal("note.key")
    static let noteColor = makeLocal("noteColor.key")
    static let oldest = makeLocal("oldest.key")
    static let operationFailedTitle = makeLocal("operationFailed.key")
    static let pink = makeLocal("pink.key")
    static let purple = makeLocal("purple.key")
    static let save = makeLocal("save.key")
    static let saveAlertTitle = makeLocal("saveAlertTitle.key")
    static let sticky = makeLocal("sticky.key")
    static let tryAgain = makeLocal("tryAgain.key")
    static let yellow = makeLocal("yellow.key")

    static func emptyColorNotesTitle(for noteColor: NoteColor?) -> LocalizedStringResource {
        guard let noteColor else { return emptyNotesTitle }
        return .init("emptyColorNotesTitle.key", defaultValue: "No \(noteColor.title) Notes")
    }

    static func created(withDateString dateString: String) -> LocalizedStringResource {
        .init("createdFormat.key", defaultValue: "Created: \(dateString)")
    }

    static func updated(withDateString dateString: String) -> LocalizedStringResource {
        .init("updatedFormat.key", defaultValue: "Updated: \(dateString)")
    }

    static func sortMenu(for option: SortOption) -> LocalizedStringResource {
        .init("sortMenu.key", defaultValue: "Sort, \(option.title)")
    }

    static func viewTypeMenu(for viewType: ViewType) -> LocalizedStringResource {
        .init("viewTypeMenu.key", defaultValue: "View type, \(viewType.title)")
    }

    private static func makeLocal(_ key: String.LocalizationValue) -> LocalizedStringResource {
        LocalizedStringResource(key)
    }
}
