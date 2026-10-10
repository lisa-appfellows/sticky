//
//  NoteCardView.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-07.
//

import SwiftUI

struct NoteCardView: View {
    private let vm: NoteCardVM
    let availableWidth: CGFloat

    init(dto: NoteDTO, viewType: ViewType, availableWidth: CGFloat) {
        self.vm = .init(dto: dto, viewType: viewType)
        self.availableWidth = availableWidth
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading, spacing: 8) {
                Text(vm.title)
                    .noteFont(vm.titleFont)
                Text(vm.text)
                    .noteFont(vm.textFont)
                Spacer()
                Text(vm.dateString)
                    .font(.caption2)
                    .foregroundStyle(.appSecondary)
            }
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .frame(
                width: vm.adjustedWidth(availableWidth),
                height: vm.adjustedHeight(availableWidth)
            )
            .background(vm.backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 2))
        }
    }
}

#Preview("Grid") {
    NoteCardView(
        dto: PreviewSupport.sampleNoteDTO(noteColor: .blue),
        viewType: .grid,
        availableWidth: 370
    )
}

#Preview("Compact") {
    NoteCardView(
        dto: PreviewSupport.sampleNoteDTO(noteColor: .green),
        viewType: .compact,
        availableWidth: 370
    )
}

#Preview("List") {
    NoteCardView(
        dto: PreviewSupport.sampleNoteDTO(noteColor: .yellow),
        viewType: .list,
        availableWidth: 370
    )
}
