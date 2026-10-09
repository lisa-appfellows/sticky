//
//  CleanUpMenu.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-07.
//

import SwiftUI

struct CleanUpMenu: View {
    let action: (CleanUpOption) -> Void

    var body: some View {
        Menu {
            ForEach(CleanUpOption.allCases, id: \.self) { option in
                Button {
                    action(option)
                } label: {
                    Text(option.title)
                }
            }
        } label: {
            HStack {
                Text(LocalKey.cleanUp)
                Image(systemName: SystemKey.arrowUpArrowDown)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CleanUpMenu { option in
        print(option.title)
    }
}
