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
                Button {
                    selection = noteColor
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(noteColor.color)
                        if noteColor == selection {
                            Image(systemName: SystemKey.checkmark)
                                .foregroundStyle(.black)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    NoteColorSelector(selection: .constant(.yellow))
}
