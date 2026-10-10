//
//  TitleField.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-09.
//

import SwiftUI

struct TitleField: View, EditorFieldable {
    let placeholder: LocalizedStringResource
    var text: Binding<String>

    var focusBinding: FocusState<EditorField?>.Binding
    let field: EditorField = .title
    
    var charLimit: Int

    init(
        _ placeholder: LocalizedStringResource,
        text: Binding<String>,
        focusBinding: FocusState<EditorField?>.Binding,
        charLimit: Int = 45
    ) {
        self.placeholder = placeholder
        self.text = text
        self.focusBinding = focusBinding
        self.charLimit = charLimit
    }
    
    var body: some View {
        HStack(alignment: .bottom) {
            TextField(text: text, axis: .vertical) { Text(placeholder) }
                .lineLimit(2...2)
                .noteFont(.mediumTitle)
                .focused(focusBinding, equals: field)
                .onChange(of: text.wrappedValue) { _, newText in
                    clampText(newText)
                }
            Text(charCounterText)
                .font(.caption)
                .foregroundStyle(.appSecondary)
            
        }
    }
}



#if DEBUG
struct TestTitleFieldContainer: View {
    @FocusState private var focusedField: EditorField?
    @State private var text = ""

    var body: some View {
        NavigationStack {
            TitleField(LocalKey.enterTextPlaceholder, text: $text, focusBinding: $focusedField)
                .background(Color.appBlue)
                .padding()
                .toolbar {
                    Button {
                        focusedField = nil
                    } label: {
                        Text("Done")
                    }
                }
        }
    }
}

#Preview {
    TestTitleFieldContainer()
}
#endif
