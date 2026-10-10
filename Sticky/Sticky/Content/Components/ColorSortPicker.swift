//
//  ColorSortPicker.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-07.
//

import SwiftUI

struct ColorSortPicker: View {
    @Binding var selection: NoteColor?

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ColorSortPill(selection: $selection, noteColor: nil)
                        .id(Optional<NoteColor>.none)
                    
                    ForEach(NoteColor.allCases, id: \.self) { noteColor in
                        ColorSortPill(selection: $selection, noteColor: noteColor)
                            .id(noteColor)
                    }
                }
                .frame(height: 45)
            }
            .safeAreaPadding(.horizontal, 24)
            .onChange(of: selection) { _, newSelection in
                withAnimation {
                    proxy.scrollTo(newSelection, anchor: .center)
                }
            }
        }
    }
}

private struct ColorSortPill: View {
    @Binding var selection: NoteColor?
    let noteColor: NoteColor?

    var body: some View {
        Button(action: didSelect) {
            Text(noteColor?.title ?? LocalKey.all)
                .bold()
                .foregroundStyle(foreground)
                .frame(width: 120, height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 2)
                        .fill(background)
                        .strokeBorder(stroke, lineWidth: strokeWidth)
                )
        }
        .buttonStyle(.plain)
    }

    private func didSelect() {
        selection = noteColor
    }

    private var isSelected: Bool {
        selection == noteColor
    }

    private var foreground: Color {
        (noteColor == nil ? Color.primary : .black)
            .opacity(isSelected ? 1 : 0.4)
    }

    private var background: Color {
        guard let noteColor else { return .appBackground }
        return noteColor.color.opacity(isSelected ? 1 : 0.4)
    }

    private var stroke: Color {
        (noteColor?.color ?? .primary)
            .opacity(isSelected ? 1 : 0.4)
    }

    private var strokeWidth: CGFloat {
        noteColor == nil ? 1 : 0
    }
}

#Preview {
    ColorSortPicker(selection: .constant(.blue))
}
