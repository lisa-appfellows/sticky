//
//  DataStoreTests.swift
//  StickyTests
//
//  Created by Lisa Fellows on 2026-10-07.
//

import SwiftData
import XCTest
@testable import Sticky

@MainActor
final class DataStoreTests: XCTestCase {
    private var container: ModelContainer!
    private var context: ModelContext!

    override func setUp() {
        super.setUp()
        container = DataStore.modelContainer(inMemoryOnly: true)
        context = container.mainContext
    }

    func testSave() throws {
        let note = NoteModel(noteId: "saved", title: "Saved")
        context.insert(note)

        try DataStore.save(context: context)

        let fetched = try XCTUnwrap(
            try DataStore.fetchNote(byNoteId: "saved", context: context)
        )
        XCTAssertEqual(fetched.title, "Saved")
    }

    func testCreateNoteShouldInsert() throws {
        let dto = NoteDTO(title: "Title A")
        try DataStore.createNote(from: dto, context: context)

        let fetched = try DataStore.fetchNotes(from: context)
        XCTAssertEqual(fetched.count, 1)
        XCTAssertEqual(fetched.first?.title, "Title A")
    }

    func testUpdateNoteShouldUpdateModel() throws {
        let noteId = UUID().uuidString
        let note = NoteModel(noteId: noteId, title: "Unmodified")
        context.insert(note)
        try context.save()

        let firstFetch = try DataStore.fetchNote(byNoteId: noteId, context: context)
        var dto = try XCTUnwrap(firstFetch?.asDTO)
        dto.title = "Updated"

        try DataStore.updateNote(from: dto, context: context)

        let secondFetch = try XCTUnwrap(
            try DataStore.fetchNote(byNoteId: noteId, context: context)
        )
        XCTAssertEqual(secondFetch.title, "Updated")
    }

    func testDeleteNoteShouldDelete() throws {
        let noteId = UUID().uuidString
        let note = NoteModel(noteId: noteId)
        context.insert(note)
        try context.save()

        let firstFetch = try DataStore.fetchNote(byNoteId: noteId, context: context)
        XCTAssertNotNil(firstFetch)

        try DataStore.deleteNote(byNoteId: noteId, context: context)

        let secondFetch = try DataStore.fetchNote(byNoteId: noteId, context: context)
        XCTAssertNil(secondFetch)
    }
}

// MARK: - Fetching
extension DataStoreTests {
    func testFetchNoteCount() throws {
        (1...3).forEach { index in
            let new = NoteModel(title: "Title \(index)")
            context.insert(new)
        }
        try context.save()

        let count = try DataStore.fetchNoteCount(from: context)
        XCTAssertEqual(count, 3)
    }

    func testFetchNotes() throws {
        (1...3).forEach { index in
            let new = NoteModel(text: "Text \(index)")
            context.insert(new)
        }
        try context.save()

        let fetchedNotes = try DataStore.fetchNotes(from: context)
        XCTAssertEqual(fetchedNotes.count, 3)
    }

    func testFetchNoteByNoteId() throws {
        let noteId = UUID().uuidString
        let note = NoteModel(noteId: noteId, title: "Note")
        context.insert(note)

        let fetched = try DataStore.fetchNote(byNoteId: noteId, context: context)
        XCTAssertEqual(fetched?.noteId, noteId)
        XCTAssertEqual(fetched?.title, "Note")
    }
}
