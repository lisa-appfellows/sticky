//
//  NoteColor.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-07.
//

import Foundation

enum NoteColor: String, CaseIterable {
    case blue
    case green
    case yellow
    case pink
    case purple

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
