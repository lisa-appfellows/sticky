//
//  CleanUpOption+UI.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-07.
//

import Foundation

extension CleanUpOption {
    var title: LocalizedStringResource {
        switch self {
        case .newest: return LocalKey.cleanUpByNewest
        case .oldest: return LocalKey.cleanUpByOldest
        case .name: return LocalKey.cleanUpByName
        case .color: return LocalKey.cleanUpByColor
        }
    }
}
