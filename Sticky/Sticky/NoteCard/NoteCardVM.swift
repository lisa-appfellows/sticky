//
//  NoteCardVM.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-08.
//

import SwiftUI

struct NoteCardVM {
    private let dto: NoteDTO
    private let viewType: ViewType

    var backgroundColor: Color {
        dto.noteColor.color
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
