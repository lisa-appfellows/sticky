//
//  ColorSortPicker.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-07.
//

import SwiftUI

struct ColorSortPicker: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
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
                if reduceMotion {
                    proxy.scrollTo(newSelection, anchor: .center)
                } else {
                    withAnimation {
                        proxy.scrollTo(newSelection, anchor: .center)
                    }
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
        .accessibilityLabel(pillAccessibilityLabel)
        .accessibilityHint(String(localized: LocalKey.a11yFilterHint))
    }

    private var pillAccessibilityLabel: String {
        let name = String(localized: noteColor?.title ?? LocalKey.all)
        guard isSelected else { return name }
        return "\(name), \(String(localized: LocalKey.a11ySelected))"
    }

    private func didSelect() {
        selection = noteColor
    }

    private var isNil: Bool { noteColor == nil }
    private var isSelected: Bool { selection == noteColor }

    private var foreground: Color {
        isNil ? Color.primary : .black
    }

    private var background: Color {
        guard let noteColor else { return .appBackground }
        return noteColor.color.opacity(isSelected ? 1 : 0.65)
    }

    private var stroke: Color {
        noteColor?.color ?? .primary
    }

    private var strokeWidth: CGFloat {
        isSelected ? 2 : (isNil ? 0.2 : 0)
    }
}

#Preview {
    ColorSortPicker(selection: .constant(.blue))
}
