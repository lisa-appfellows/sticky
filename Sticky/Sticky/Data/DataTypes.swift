//
//  DataTypes.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-06.
//

import Foundation

enum CleanUpOption: String, CaseIterable {
    case newest
    case oldest
    case name
    case color

    var title: String { rawValue.capitalized }
}

enum NoteColor: String, CaseIterable {
    case blue 
    case green
    case yellow
    case pink
    case purple

    var title: String { rawValue.capitalized }

    var sortPriority: Int {
        switch self {
        case .blue: return 0
        case .green: return 1
        case .yellow: return 2
        case .pink: return 3
        case .purple: return 4
        }
    }
}

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
}

enum NoteSize {
    case small
    case medium
    case large
}

enum ViewType: String, CaseIterable {
    case list
    case compact
    case grid

    var iconName: String {
        switch self {
        case .list: return "list.bullet"
        case .compact: return "rectangle.split.2x1"
        case .grid: return "square.grid.2x2"
        }
    }

    var noteSize: NoteSize {
        switch self {
        case .list: return .large
        case .compact: return .medium
        case .grid: return .small
        }
    }
}
