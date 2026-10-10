//
//  SortOptionMenu.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-10.
//

import SwiftUI

struct SortOptionMenu: View {
    @Binding var selection: SortOption

    var body: some View {
        Menu {
            ForEach(SortOption.allCases, id: \.self) { option in
                Button {
                    selection = option
                } label: {
                    HStack {
                        Text(option.title)
                        if option == selection {
                            Image(systemName: SystemKey.checkmark)
                        }
                    }
                }
            }
        } label: {
            HStack {
                Text(selection.title)
                    .font(.footnote)
                Image(systemName: SystemKey.arrowUpArrowDown)
            }
        }
        .buttonStyle(.plain)
    }
}
