//
//  PreviewSupport.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-07.
//

#if DEBUG
import Foundation
import SwiftData

enum PreviewSupport {
    static var modelContainer: ModelContainer {
        DataStore.modelContainer(inMemoryOnly: true)
    }
    static var defaultViewType: DefaultViewType {
        .init(defaults: .init(suiteName: "PreviewSupport.\(UUID().uuidString)")!)
    }
}
#endif
