//
//  NoteEditorSheet.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-08.
//

import SwiftUI

enum NoteEditorSheet: Identifiable {
    case new(NoteColor?)
    case existing(NoteDTO)

    var id: String {
        switch self {
        case .new(let noteColor):
            "new-\(noteColor?.rawValue ?? "all")"
        case .existing(let dto):
            "existing-\(dto.noteId)"
        }
    }
}

extension View {
    func noteEditorSheet(item: Binding<NoteEditorSheet?>) -> some View {
        sheet(item: item) { sheet in
            NoteEditorSheetHost(sheet: sheet)
        }
    }
}

private struct NoteEditorSheetHost: View {
    let sheet: NoteEditorSheet

    var body: some View {
        switch sheet {
        case .new(let noteColor):
            NoteEditorView(noteColor: noteColor)
        case .existing(let noteDTO):
            NoteEditorView(dto: noteDTO)
        }
    }
}
