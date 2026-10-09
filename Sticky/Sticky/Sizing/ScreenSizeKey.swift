//
//  ScreenSizeKey.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-08.
//

import SwiftUI

struct ScreenSizeKey: EnvironmentKey {
    static var defaultValue: CGSize = .zero
}

extension EnvironmentValues {
    var screenSize: CGSize {
        get { self[ScreenSizeKey.self] }
        set { self[ScreenSizeKey.self] = newValue}
    }
}
