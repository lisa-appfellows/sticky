//
//  NoteColorSelector.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-09.
//

import SwiftUI

struct NoteColorSelector: View {
    @Binding var selection: NoteColor

    var body: some View {
        HStack(spacing: 18) {
            ForEach(NoteColor.allCases, id: \.self) { noteColor in
                let isSelected = noteColor == selection
                Button {
                    selection = noteColor
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(noteColor.color)
                        if isSelected {
                            Image(systemName: SystemKey.checkmark)
                                .foregroundStyle(.black)
                                .accessibilityHidden(true)
                        }
                    }
                    .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(swatchLabel(for: noteColor, isSelected: isSelected))
                .accessibilityHint(String(localized: LocalKey.a11yNoteColorHint))
            }
        }
    }

    private func swatchLabel(for noteColor: NoteColor, isSelected: Bool) -> String {
        let name = String(localized: noteColor.title)
        guard isSelected else { return name }
        return "\(name), \(String(localized: LocalKey.a11ySelected))"
    }
}

#Preview {
    NoteColorSelector(selection: .constant(.yellow))
}
