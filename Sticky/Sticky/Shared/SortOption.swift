//
//  SortOption.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-10.
//

import SwiftUI

enum SortOption: String, CaseIterable {
    case newest
    case oldest
    case name

    var title: LocalizedStringResource {
        switch self {
        case .newest: return LocalKey.newest
        case .oldest: return LocalKey.oldest
        case .name: return LocalKey.name
        }
    }
}
