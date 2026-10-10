//
//  EditorFieldable.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-09.
//

import SwiftUI

protocol EditorFieldable: CharacterLimiting {
    var placeholder: LocalizedStringResource { get }
    var text: Binding<String> { get }

    var focusBinding: FocusState<EditorField?>.Binding { get }
    var field: EditorField { get }

    var charLimit: Int { get }
}
