//
//  NoteEditorLink.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-08.
//

import SwiftUI

extension NoteEditorLink where Label == NewEditorLinkLabel {
    static var newEditor: NoteEditorLink<NewEditorLinkLabel> {
        .init { NewEditorLinkLabel() }
    }
}

struct NewEditorLinkLabel: View {
    var body: some View {
        Image(systemName: SystemKey.plus)
    }
}

struct NoteEditorLink<Label: View>: View {
    let dto: NoteDTO?
    @ViewBuilder let label: () -> Label

    @State private var presentingSheet = false

    init(dto: NoteDTO? = nil, @ViewBuilder label: @escaping () -> Label) {
        self.dto = dto
        self.label = label
    }

    var body: some View {
        Button(action: presentSheet, label: label)
            .buttonStyle(.plain)
            .sheet(isPresented: $presentingSheet) {
                NoteEditorView(dto: dto)
            }
    }

    private func presentSheet() {
        presentingSheet = true
    }
}

#Preview {
    NoteEditorLink.newEditor
}
