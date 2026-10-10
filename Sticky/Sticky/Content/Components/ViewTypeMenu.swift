//
//  ViewTypeMenu.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-08.
//

import SwiftUI

struct ViewTypeMenu: View {
    @Binding var selection: ViewType

    var body: some View {
        Menu {
            ForEach(ViewType.allCases, id: \.self) { viewType in
                Button {
                    selection = viewType
                } label: {
                    HStack {
                        Text(viewType.title)
                        if viewType == selection {
                            Image(systemName: SystemKey.checkmark)
                        }
                    }
                }
            }
        } label: {
            HStack {
                Image(systemName: selection.iconName)
                Text(selection.title)
                    .font(.footnote)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ViewTypeMenu(selection: .constant(.list))
}
