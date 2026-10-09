//
//  NoteColor+UI.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-07.
//

import SwiftUI

extension NoteColor {
    var title: LocalizedStringResource {
        switch self {
        case .blue: return LocalKey.blue
        case .green: return LocalKey.green
        case .yellow: return LocalKey.yellow
        case .pink: return LocalKey.pink
        case .purple: return LocalKey.purple
        }
    }

    var color: Color {
        switch self {
        case .blue: return .appBlue
        case .green: return .appGreen
        case .yellow: return .appYellow
        case .pink: return .appPink
        case .purple: return .appPurple
        }
    }
}
