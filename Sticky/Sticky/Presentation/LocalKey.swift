//
//  LocalKey.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-07.
//

import Foundation

enum LocalKey {
    static let all = LocalizedStringResource("all.key")
    static let blue = LocalizedStringResource("blue.key")
    static let cancel = LocalizedStringResource("cancel.key")
    static let cleanUp = LocalizedStringResource("cleanUp.key")
    static let cleanUpByColor = LocalizedStringResource("cleanUpColor.key")
    static let cleanUpByName = LocalizedStringResource("cleanUpName.key")
    static let cleanUpByNewest = LocalizedStringResource("cleanUpNewest.key")
    static let cleanUpByOldest = LocalizedStringResource("cleanUpOldest.key")
    static let compact = LocalizedStringResource("compact.key")
    static let createNote = LocalizedStringResource("createNote.key")
    static let deleteNote = LocalizedStringResource("deleteNote.key")
    static let editNote = LocalizedStringResource("editNote.key")
    static let enterTextPlaceholder = LocalizedStringResource("enterTextPlaceholder.key")
    static let enterTitlePlaceholder = LocalizedStringResource("enterTitlePlaceholder.key")
    static let green = LocalizedStringResource("green.key")
    static let grid = LocalizedStringResource("grid.key")
    static let list = LocalizedStringResource("list.key")
    static let note = LocalizedStringResource("note.key")
    static let noteColor = LocalizedStringResource("noteColor.key")
    static let pink = LocalizedStringResource("pink.key")
    static let purple = LocalizedStringResource("purple.key")
    static let save = LocalizedStringResource("save.key")
    static let sticky = LocalizedStringResource("sticky.key")
    static let yellow = LocalizedStringResource("yellow.key")

    static func created(withDateString dateString: String) -> LocalizedStringResource {
        .init("createdFormat.key", defaultValue: "Created: \(dateString)")
    }

    static func updated(withDateString dateString: String) -> LocalizedStringResource {
        .init("updatedFormat.key", defaultValue: "Updated: \(dateString)")
    }
}
