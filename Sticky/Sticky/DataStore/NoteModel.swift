//
//  NoteModel.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-07.
//

import Foundation
import SwiftData

@Model
final class NoteModel {
    var noteId: String = UUID().uuidString
    var updatedString: String?
    var sortOrder: Int?
    var title: String?
    var text: String?
    var noteColorName: String? = NoteColor.yellow.rawValue

    var asDTO: NoteDTO { .init(fromModel: self) }

    init(
        noteId: String = UUID().uuidString,
        updatedString: String? = Date().ISO8601Format(),
        sortOrder: Int? = -1,
        title: String? = nil,
        text: String? = nil,
        noteColorName: String? = NoteColor.yellow.rawValue
    ) {
        self.noteId = noteId
        self.updatedString = updatedString
        self.sortOrder = sortOrder
        self.title = title
        self.text = text
        self.noteColorName = noteColorName
    }

    init(fromDTO dto: NoteDTO) {
        self.noteId = dto.noteId
        self.updatedString = dto.updated.ISO8601Format()
        self.sortOrder = dto.sortOrder
        self.title = dto.title.isEmpty ? nil : dto.title
        self.text = dto.text.isEmpty ? nil : dto.text
        self.noteColorName = dto.noteColor.rawValue
    }

    func update(fromDTO dto: NoteDTO) {
        guard dto.noteId == noteId else { return }

        let dtoUpdatedString = dto.updated.ISO8601Format()
        if dtoUpdatedString != updatedString {
            updatedString = dtoUpdatedString
        }

        if dto.sortOrder != sortOrder {
            sortOrder = dto.sortOrder
        }

        if dto.title != title {
            title = dto.title.isEmpty ? nil : dto.title
        }

        if dto.text != text {
            text = dto.text.isEmpty ? nil : dto.text
        }
    
        if dto.noteColor.rawValue != noteColorName {
            noteColorName = dto.noteColor.rawValue
        }
    }
}
