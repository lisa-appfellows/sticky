//
//  NoteEditorVM.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-07.
//

import SwiftUI

@MainActor
@Observable
final class NoteEditorVM {
    private let isNew: Bool
    var dto: NoteDTO

    var navTitle: LocalizedStringResource {
        isNew ? LocalKey.createNote : LocalKey.editNote
    }

    var rowBackgroundColor: Color {
        dto.noteColor.color
    }

    var dateString: LocalizedStringResource {
        let dateString = dto.updated.formatted(date: .long, time: .omitted)
        return isNew ?
        LocalKey.created(withDateString: dateString) :
        LocalKey.updated(withDateString: dateString)
    }

    var canDelete: Bool { !isNew }

    init(dto: NoteDTO?) {
        self.isNew = dto == nil
        self.dto = dto ?? .init()
    }

    func noteColorIsSelected(_ noteColor: NoteColor) -> Bool {
        noteColor == dto.noteColor
    }
}
