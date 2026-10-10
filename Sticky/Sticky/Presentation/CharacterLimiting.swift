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

    func clampText(_ newText: String) {
        guard newText.count > charLimit else { return }
        text.wrappedValue = String(newText.prefix(charLimit))
    }
}
