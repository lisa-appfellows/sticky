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

    static var userDefaults: UserDefaults {
        .init(suiteName: "PreviewSupport.\(UUID().uuidString)")!
    }

    static func sampleNoteDTO(noteColor: NoteColor = .yellow) -> NoteDTO {
        .init(title: "Sample Note Title", text: "A note to see what a sticky note will look like.", noteColor: noteColor)
    }
}
#endif
