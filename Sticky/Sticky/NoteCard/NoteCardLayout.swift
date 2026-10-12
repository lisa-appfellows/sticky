//
//  NoteCardLayout.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-08.
//

import SwiftUI

struct NoteCardLayout {
    let dto: NoteDTO
    private let viewType: ViewType

    var backgroundColor: Color {
        dto.noteColor.color
    }

    var cardSpacing: CGFloat {
        viewType == .list ? 16 : 8
    }

    var title: String { dto.title }
    var titleFont: NoteFont {
        switch viewType {
        case .list: return .largeTitle
        case .compact: return .mediumTitle
        case .grid: return .smallTitle
        }
    }

    var text: String { dto.text }
    var textFont: NoteFont {
        switch viewType {
        case .list: return .largeText
        case .compact: return .mediumText
        case .grid: return .smallText
        }
    }

    var dateString: LocalizedStringResource {
        let dateString = dto.updated.formatted(
            date: viewType == .grid ? .numeric : .long,
            time: .omitted
        )
        return LocalKey.updated(withDateString: dateString)
    }

    /// Plain string — VoiceOver often ignores composite `Text` labels and falls back to children.
    func accessibilityLabel(locale: Locale = .autoupdatingCurrent) -> String {
        var parts: [String] = []
        if !title.isEmpty {
            parts.append(title)
        }
        if !text.isEmpty {
            parts.append(text)
        }
        if parts.isEmpty {
            parts.append(localized(LocalKey.note, locale: locale))
        }
        parts.append(localized(dto.noteColor.title, locale: locale))
        parts.append(localized(dateString, locale: locale))
        return parts.joined(separator: ", ")
    }

    private func localized(
        _ resource: LocalizedStringResource,
        locale: Locale
    ) -> String {
        var localizedResource = resource
        localizedResource.locale = locale
        return String(localized: localizedResource)
    }

    init(dto: NoteDTO, viewType: ViewType) {
        self.dto = dto
        self.viewType = viewType
    }

    func adjustedWidth(_ available: CGFloat) -> CGFloat {
        switch viewType {
        case .grid: return (available / 2) - viewType.noteSpacing
        default: return available
        }
    }

    func adjustedHeight(_ availableWidth: CGFloat) -> CGFloat {
        switch viewType {
        case .list: return availableWidth
        case .compact: return availableWidth / 2
        case .grid: return (availableWidth / 2) - viewType.noteSpacing
        }
    }
}
