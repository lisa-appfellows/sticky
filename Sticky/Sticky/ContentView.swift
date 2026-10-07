//
//  ContentView.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-06.
//

import SwiftUI

struct ContentView: View {
    @Environment(DefaultViewType.self) private var viewType

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!.")
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .modelContainer(PreviewSupport.modelContainer)
        .environment(PreviewSupport.defaultViewType)
}
