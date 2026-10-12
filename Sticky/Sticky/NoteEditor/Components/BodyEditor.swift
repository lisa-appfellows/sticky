//
//  BodyEditor.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-09.
//

import SwiftUI

struct BodyEditor: View, EditorFieldable {
    let placeholder: LocalizedStringResource
    var text: Binding<String>

    var focusBinding: FocusState<EditorField?>.Binding
    let field = EditorField.text

    let charLimit: Int

    private var shouldShowPlaceholder: Bool {
        text.wrappedValue.isEmpty &&
        focusBinding.wrappedValue != field
    }

    init(
        _ placeholder: LocalizedStringResource,
        text: Binding<String>,
        focusBinding: FocusState<EditorField?>.Binding,
        charLimit: Int = 450
    ) {
        self.placeholder = placeholder
        self.text = text
        self.focusBinding = focusBinding
        self.charLimit = charLimit
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if shouldShowPlaceholder {
                Text(placeholder)
                    .noteFont(.mediumText)
                    .foregroundStyle(.appSecondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }

            TextEditor(text: text)
                .noteFont(.mediumText)
                .scrollContentBackground(.hidden)
                .focused(focusBinding, equals: field)
                .accessibilityHint(charLimitAccessibilityHint)
                .onChange(of: text.wrappedValue) { _, newText in
                    clampText(newText)
                }
                .padding(.bottom, 20)

            Text(charCounterText)
                .font(.caption)
                .foregroundStyle(.appSecondary)
                .padding(.trailing, 4)
                .padding(.bottom, 2)
                .accessibilityHidden(true)
        }
        .frame(height: 240)
    }
}

#if DEBUG
struct TestBodyEditorContainer: View {
    @FocusState private var focusedField: EditorField?
    @State private var text = ""

    var body: some View {
        NavigationStack {
            BodyEditor(LocalKey.enterTextPlaceholder, text: $text, focusBinding: $focusedField)
                .background(Color.appBlue)
                .padding()
                .toolbar {
                    Button {
                        focusedField = nil
                    } label: {
                        Text(LocalKey.done)
                    }
                }
        }
    }
}

#Preview {
    TestBodyEditorContainer()
}
#endif
