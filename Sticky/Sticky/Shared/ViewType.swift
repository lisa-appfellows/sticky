//
//  ViewType.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-07.
//

import Foundation

enum ViewType: String, CaseIterable {
    case list
    case compact
    case grid

    var title: LocalizedStringResource {
        switch self {
        case .list: return LocalKey.list
        case .compact: return LocalKey.compact
        case .grid: return LocalKey.grid
        }
    }

    var iconName: String {
        switch self {
        case .list: return SystemKey.rectangle
        case .compact: return SystemKey.rectangleSplit1x2
        case .grid: return SystemKey.squareGrid2x2
        }
    }

    var noteSpacing: CGFloat { 12 }
}
