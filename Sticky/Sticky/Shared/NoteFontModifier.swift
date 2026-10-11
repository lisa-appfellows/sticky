//
//  NoteFontModifier.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-07.
//

import SwiftUI

extension View {
    func noteFont(_ noteFont: NoteFont) -> some View {
        modifier(NoteFontModifier(noteFont: noteFont))
    }
}

private struct NoteFontModifier: ViewModifier {
    @ScaledMetric private var fontSize: Double
    private let isBold: Bool

    init(noteFont: NoteFont) {
        _fontSize = ScaledMetric(
            wrappedValue: noteFont.fontSize,
            relativeTo: noteFont.relativeToStyle
        )
        self.isBold = noteFont.isTitle
    }

    func body(content: Content) -> some View {
        content
            .font(.system(size: fontSize, weight: isBold ? .bold : .regular))
    }
}
