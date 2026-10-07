//
//  StickyApp.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-06.
//

import SwiftData
import SwiftUI

@main
struct StickyApp: App {
    private let container: ModelContainer
    @State private var defaultViewType = DefaultViewType()

    init() {
        container = DataStore.modelContainer()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
        .environment(defaultViewType)
    }
}
