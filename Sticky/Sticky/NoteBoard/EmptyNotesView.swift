//
//  EmptyNotesView.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-10.
//

import SwiftUI

struct EmptyNotesView: View {
    let noteColor: NoteColor?
    @Binding var editorSheet: NoteEditorSheet?

    private var foreground: Color {
        noteColor == nil ? .primary : .black
    }

    private var fill: Color {
        noteColor?.color ?? .clear
    }

    private var strokeWidth: CGFloat {
        noteColor == nil ? 1 : 0
    }

    var body: some View {
        ContentUnavailableView {
            Text(LocalKey.emptyColorNotesTitle(for: noteColor))
        } description: {
            Text(LocalKey.emptyNotesMessage)
        } actions: {
            Button {
                editorSheet = .new(noteColor)
            } label: {
                Text(LocalKey.createNote)
                    .foregroundStyle(foreground)
                    .padding(.horizontal, 16)
                    .frame(height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 2)
                            .fill(fill)
                            .stroke(.primary, lineWidth: strokeWidth)
                    )
                    .padding()
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview("Empty") {
    EmptyNotesView(noteColor: nil, editorSheet: .constant(nil))
}

#Preview("Empty Color") {
    EmptyNotesView(noteColor: .blue, editorSheet: .constant(nil))
}
