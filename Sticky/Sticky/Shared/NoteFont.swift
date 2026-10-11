//
//  NoteFont.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-07.
//

import SwiftUI

enum NoteFont {
    case smallTitle
    case mediumTitle
    case largeTitle
    case smallText
    case mediumText
    case largeText

    var fontSize: CGFloat {
        switch self {
        case .smallTitle: return 16
        case .mediumTitle: return 18
        case .largeTitle: return 24
        case .smallText: return 14
        case .mediumText: return 16
        case .largeText: return 18
        }
    }

    var isTitle: Bool {
        switch self {
        case .smallTitle, .mediumTitle, .largeTitle:
            return true
        default:
            return false
        }
    }

    var relativeToStyle: Font.TextStyle {
        isTitle ? .title2 : .body
    }
}

