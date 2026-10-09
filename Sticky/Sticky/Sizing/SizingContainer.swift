//
//  SizingContainer.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-08.
//

import SwiftUI

struct SizingContainer<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        GeometryReader { proxy in
            content()
                .environment(\.screenSize, proxy.size)
        }
    }
}

