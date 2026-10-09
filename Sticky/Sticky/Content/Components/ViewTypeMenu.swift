//
//  ViewTypeMenu.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-08.
//

import SwiftUI

struct ViewTypeMenu: View {
    let selected: ViewType
    let action: (ViewType) -> Void

    var body: some View {
        Menu {
            ForEach(ViewType.allCases, id: \.self) { viewType in
                Button {
                    action(viewType)
                } label: {
                    HStack {
                        Text(viewType.title)
                        if viewType == selected {
                            Image(systemName: SystemKey.checkmark)
                        }
                    }
                }
            }
        } label: {
            HStack {
                Image(systemName: selected.iconName)
                Text(selected.title)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ViewTypeMenu(selected: .grid) { viewType in }
}
