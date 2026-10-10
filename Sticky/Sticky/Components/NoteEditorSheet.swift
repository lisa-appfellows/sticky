//
//  NoteEditorSheet.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-08.
//

import SwiftUI

enum NoteEditorSheet { case new(NoteColor?), existing(NoteDTO) }

extension View {
    func noteEditorSheet(_ sheet: NoteEditorSheet) -> some View {
        modifier(NoteEditorSheetModifier(sheet: sheet))
    }
}

struct NoteEditorSheetModifier: ViewModifier {
    let sheet: NoteEditorSheet

    @State private var presentingSheet = false

    func body(content: Content) -> some View {
        Button {
            presentingSheet = true
        } label: {
            content
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $presentingSheet) {
            switch sheet {
            case .new(let noteColor):
                NoteEditorView(noteColor: noteColor)
            case .existing(let noteDTO):
                NoteEditorView(dto: noteDTO)
            }
        }
    }
}
