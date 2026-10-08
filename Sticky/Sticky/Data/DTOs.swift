//
//  DTOs.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-07.
//

import Foundation

struct NoteDTO {
    var noteId: String
    var updated: Date
    var sortOrder: Int
    var title: String
    var text: String
    var noteColor: NoteColor

    var asModel: NoteModel { .init(fromDTO: self) }

    init(
        noteId: String = UUID().uuidString,
        updated: Date = Date(),
        sortOrder: Int = -1,
        title: String = "",
        text: String = "",
        noteColor: NoteColor = .yellow
    ) {
        self.noteId = noteId
        self.updated = updated
        self.sortOrder = sortOrder
        self.title = title
        self.text = text
        self.noteColor = noteColor
    }

    init(fromModel model: NoteModel) {
        self.noteId = model.noteId
        self.sortOrder = model.sortOrder ?? -1
        self.title = model.title ?? ""
        self.text = model.text ?? ""
        self.noteColor = NoteColor(rawValue: model.noteColorName ?? "") ?? .yellow
        
        if let updatedString = model.updatedString,
           let updatedDate = ISO8601DateFormatter().date(from: updatedString) {
            self.updated = updatedDate
        } else {
            self.updated = Date()
        }
    }
}
