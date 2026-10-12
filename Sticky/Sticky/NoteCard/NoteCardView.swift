//
//  NoteCardView.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-07.
//

import SwiftUI

struct NoteCardView: View {
    private let layout: NoteCardLayout
    let availableWidth: CGFloat
    @Binding var editorSheet: NoteEditorSheet?

    init(
        dto: NoteDTO,
        viewType: ViewType,
        availableWidth: CGFloat,
        editorSheet: Binding<NoteEditorSheet?>
    ) {
        self.layout = .init(dto: dto, viewType: viewType)
        self.availableWidth = availableWidth
        _editorSheet = editorSheet
    }

    var body: some View {
        Button {
            editorSheet = .existing(layout.dto)
        } label: {
            VStack(alignment: .leading, spacing: layout.cardSpacing) {
                Text(layout.title)
                    .noteFont(layout.titleFont)
                Text(layout.text)
                    .noteFont(layout.textFont)
                Spacer()
                Text(layout.dateString)
                    .font(.caption2)
                    .foregroundStyle(.appSecondary)
            }
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .frame(
                width: layout.adjustedWidth(availableWidth),
                height: layout.adjustedHeight(availableWidth)
            )
            .background(layout.backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 2))
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(layout.accessibilityLabel())
        .accessibilityHint(String(localized: LocalKey.a11yEditNoteHint))
    }
}

#Preview("Grid") {
    NoteCardView(
        dto: PreviewSupport.sampleNoteDTO(noteColor: .blue),
        viewType: .grid,
        availableWidth: 370,
        editorSheet: .constant(nil)
    )
}

#Preview("Compact") {
    NoteCardView(
        dto: PreviewSupport.sampleNoteDTO(noteColor: .green),
        viewType: .compact,
        availableWidth: 370,
        editorSheet: .constant(nil)
    )
}

#Preview("List") {
    NoteCardView(
        dto: PreviewSupport.sampleNoteDTO(noteColor: .yellow),
        viewType: .list,
        availableWidth: 370,
        editorSheet: .constant(nil)
    )
}
