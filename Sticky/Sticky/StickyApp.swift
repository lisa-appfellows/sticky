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
    
    init() {
        container = DataStore.modelContainer()
    }
    
    var body: some Scene {
        WindowGroup {
            SizingContainer {
                ContentView()
            }
        }
        .modelContainer(container)
    }
}
