//
//  CharacterLimiting.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-09.
//

import SwiftUI

protocol CharacterLimiting {
    var text: Binding<String> { get }
    var charLimit: Int { get }
}

extension CharacterLimiting {
    var charCounterText: String {
        "\(text.wrappedValue.count) / \(charLimit)"
    }

    var charLimitAccessibilityHint: String {
        String(localized: LocalKey.a11yCharLimitHint(charLimit))
    }

    func clampText(_ newText: String) {
        guard newText.count > charLimit else { return }
        text.wrappedValue = String(newText.prefix(charLimit))
        announceCharacterLimitReached()
    }

    func announceCharacterLimitReached() {
        AccessibilityNotification.Announcement(
            String(localized: LocalKey.a11yCharLimitReached)
        ).post()
    }
}
