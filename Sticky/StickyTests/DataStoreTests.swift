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

// MARK: - Update Sorting
extension DataStoreTests {
    func testAssignSortOrdersByDateNewestShouldSortNewest() throws {
        let modelA = NoteModel(
            updatedString: TestSupport.createDateString(year: 2025)
        )
        let modelB = NoteModel(
            updatedString: TestSupport.createDateString(year: 2026)
        )
        let modelC = NoteModel(
            updatedString: TestSupport.createDateString(year: 2024)
        )

        [modelA, modelB, modelC].forEach { context.insert($0) }
        try context.save()

        try DataStore.resortModels(byCleanUp: .newest, context: context)
        XCTAssertEqual(modelA.sortOrder, 1)
        XCTAssertEqual(modelB.sortOrder, 0)
        XCTAssertEqual(modelC.sortOrder, 2)
    }

    func testAssignSortOrdersByDateOldestShouldSortOldest() throws {
        let modelA = NoteModel(
            updatedString: TestSupport.createDateString(year: 2025)
        )
        let modelB = NoteModel(
            updatedString: TestSupport.createDateString(year: 2026)
        )
        let modelC = NoteModel(
            updatedString: TestSupport.createDateString(year: 2024)
        )

        [modelA, modelB, modelC].forEach { context.insert($0) }
        try context.save()

        try DataStore.resortModels(byCleanUp: .oldest, context: context)
        XCTAssertEqual(modelA.sortOrder, 1)
        XCTAssertEqual(modelB.sortOrder, 2)
        XCTAssertEqual(modelC.sortOrder, 0)
    }

    func testAssignSortOrdersByDateNilDateShouldSortLast() throws {
        let modelA = NoteModel(updatedString: nil, sortOrder: 3)
        let modelB = NoteModel(
            updatedString: TestSupport.createDateString(year: 2026),
            sortOrder: 2
        )
        let modelC = NoteModel(
            updatedString: TestSupport.createDateString(year: 2025),
            sortOrder: 5
        )

        [modelA, modelB, modelC].forEach { context.insert($0) }
        try context.save()

        try DataStore.resortModels(byCleanUp: .newest, context: context)
        XCTAssertEqual(modelA.sortOrder, 2)
        XCTAssertEqual(modelB.sortOrder, 0)
        XCTAssertEqual(modelC.sortOrder, 1)
    }

    func testAssignSortOrdersByDateWithAllNilDatesShouldDefaultToSortOrder() throws {
        let modelA = NoteModel(updatedString: nil, sortOrder: 3)
        let modelB = NoteModel(updatedString: nil, sortOrder: 2)
        let modelC = NoteModel(updatedString: nil, sortOrder: 5)

        [modelA, modelB, modelC].forEach { context.insert($0) }
        try context.save()

        try DataStore.resortModels(byCleanUp: .newest, context: context)
        XCTAssertEqual(modelA.sortOrder, 1)
        XCTAssertEqual(modelB.sortOrder, 0)
        XCTAssertEqual(modelC.sortOrder, 2)
    }

    func testAssignSortOrdersByDateWithSameDatesShouldDefaultToSortOrder() throws {
        let dateString = TestSupport.createDateString()
        let modelA = NoteModel(updatedString: dateString, sortOrder: 3)
        let modelB = NoteModel(updatedString: dateString, sortOrder: 2)
        let modelC = NoteModel(updatedString: dateString, sortOrder: 5)

        [modelA, modelB, modelC].forEach { context.insert($0) }
        try context.save()

        try DataStore.resortModels(byCleanUp: .newest, context: context)
        XCTAssertEqual(modelA.sortOrder, 1)
        XCTAssertEqual(modelB.sortOrder, 0)
        XCTAssertEqual(modelC.sortOrder, 2)
    }
}

// MARK: - Name Sorting
extension DataStoreTests {
    func testAssignSortOrdersByNameShouldSortByTitlesFirst() throws {
        let modelA = NoteModel(title: "B", text: "A")
        let modelB = NoteModel(title: "A", text: "B")

        [modelA, modelB].forEach { context.insert($0) }
        try context.save()

        try DataStore.resortModels(byCleanUp: .name, context: context)
        XCTAssertEqual(modelA.sortOrder, 1)
        XCTAssertEqual(modelB.sortOrder, 0)
    }

    func testAssignSortOrdersByNameShouldDefaultToTextOnNilTitle() throws {
        let modelA = NoteModel(title: "B", text: "A")
        let modelB = NoteModel(text: "A")

        [modelA, modelB].forEach { context.insert($0) }
        try context.save()

        try DataStore.resortModels(byCleanUp: .name, context: context)
        XCTAssertEqual(modelA.sortOrder, 1)
        XCTAssertEqual(modelB.sortOrder, 0)
    }

    func testAssignSortOrdersByNameShouldDefaultToNonNilName() throws {
        let modelA = NoteModel()
        let modelB = NoteModel(title: "A")

        [modelA, modelB].forEach { context.insert($0) }
        try context.save()

        try DataStore.resortModels(byCleanUp: .name, context: context)
        XCTAssertEqual(modelA.sortOrder, 1)
        XCTAssertEqual(modelB.sortOrder, 0)
    }

    func testAssignSortOrdersByNameShouldDefaultToSortOrderOnSameName() throws {
        let modelA = NoteModel(sortOrder: 2, title: "Same")
        let modelB = NoteModel(sortOrder: 1, title: "Same")

        [modelA, modelB].forEach { context.insert($0) }
        try context.save()

        try DataStore.resortModels(byCleanUp: .name, context: context)
        XCTAssertEqual(modelA.sortOrder, 1)
        XCTAssertEqual(modelB.sortOrder, 0)
    }
}

// MARK: - Color Sorting
extension DataStoreTests {
    func testAssignSortOrdersByColorShouldSortBySortPriority() throws {
        let green = NoteModel(noteColorName: NoteColor.green.rawValue)
        let blue = NoteModel(noteColorName: NoteColor.blue.rawValue)
        let pink = NoteModel(noteColorName: NoteColor.pink.rawValue)
        let purple = NoteModel(noteColorName: NoteColor.purple.rawValue)
        let yellow = NoteModel(noteColorName: NoteColor.yellow.rawValue)

        [green, blue, pink, purple, yellow].forEach { context.insert($0) }
        try context.save()

        try DataStore.resortModels(byCleanUp: .color, context: context)
        XCTAssertEqual(blue.sortOrder, 0)
        XCTAssertEqual(green.sortOrder, 1)
        XCTAssertEqual(yellow.sortOrder, 2)
        XCTAssertEqual(pink.sortOrder, 3)
        XCTAssertEqual(purple.sortOrder, 4)
    }

    func testAssignSortOrdersByColorShouldDefaultToSortOrderOnSimilarColor() throws {
        let greenName = NoteColor.green.rawValue
        let pinkName = NoteColor.pink.rawValue

        let green1 = NoteModel(sortOrder: 1, noteColorName: greenName)
        let green2 = NoteModel(sortOrder: 2, noteColorName: greenName)
        let pink1 = NoteModel(sortOrder: 1, noteColorName: pinkName)
        let pink2 = NoteModel(sortOrder: 2, noteColorName: pinkName)

        [pink2, green1, pink1, green2].forEach { context.insert($0) }
        try context.save()

        try DataStore.resortModels(byCleanUp: .color, context: context)
        XCTAssertEqual(green1.sortOrder, 0)
        XCTAssertEqual(green2.sortOrder, 1)
        XCTAssertEqual(pink1.sortOrder, 2)
        XCTAssertEqual(pink2.sortOrder, 3)
    }

    func testAssignSortOrdersByColorNilColorShouldLandLast() throws {
        let nilColor = NoteModel(sortOrder: 0, noteColorName: nil)
        let blueColor = NoteModel(sortOrder: 3, noteColorName: NoteColor.blue.rawValue)
        let yellowColor = NoteModel(sortOrder: 1, noteColorName: NoteColor.yellow.rawValue)

        [yellowColor, nilColor, blueColor].forEach { context.insert($0) }
        try context.save()

        try DataStore.resortModels(byCleanUp: .color, context: context)
        XCTAssertEqual(nilColor.sortOrder, 2)
        XCTAssertEqual(blueColor.sortOrder, 0)
        XCTAssertEqual(yellowColor.sortOrder, 1)
    }
}

// MARK: - Tiered Sorting
extension DataStoreTests {
    func testResortByCleanUpSortsAppropriately() throws {
        let noteA = NoteModel(
            updatedString: TestSupport.createDateString(year: 2026, month: 1),
            sortOrder: 4,
            title: "A",
            text: "A",
            noteColorName: NoteColor.blue.rawValue
        )
        let noteB = NoteModel(
            updatedString: TestSupport.createDateString(year: 2026, month: 2),
            sortOrder: 2,
            title: "B",
            text: "C",
            noteColorName: NoteColor.pink.rawValue
        )
        let noteC = NoteModel(
            updatedString: TestSupport.createDateString(year: 2026, month: 5),
            sortOrder: 1,
            noteColorName: NoteColor.yellow.rawValue
        )

        [noteA, noteB, noteC].forEach { context.insert($0) }
        try context.save()

        // Updated Sort - Newest
        try DataStore.resortModels(byCleanUp: .newest, context: context)
        XCTAssertEqual(noteA.sortOrder, 2)
        XCTAssertEqual(noteB.sortOrder, 1)
        XCTAssertEqual(noteC.sortOrder, 0)

        // Updated Sort - Oldest
        try DataStore.resortModels(byCleanUp: .oldest, context: context)
        XCTAssertEqual(noteA.sortOrder, 0)
        XCTAssertEqual(noteB.sortOrder, 1)
        XCTAssertEqual(noteC.sortOrder, 2)

        // Name Sort
        try DataStore.resortModels(byCleanUp: .name, context: context)
        XCTAssertEqual(noteA.sortOrder, 0)
        XCTAssertEqual(noteB.sortOrder, 1)
        XCTAssertEqual(noteC.sortOrder, 2)

        // Color Sort
        try DataStore.resortModels(byCleanUp: .color, context: context)
        XCTAssertEqual(noteA.sortOrder, 0)
        XCTAssertEqual(noteB.sortOrder, 2)
        XCTAssertEqual(noteC.sortOrder, 1)
    }
}

// MARK: - Index Insertion Sorting
extension DataStoreTests {
    func testResortNoteAtNoteIdToIndexMoveUpInsertsAndResorts() throws {
        let noteId = UUID().uuidString
        let noteA = NoteModel(noteId: UUID().uuidString, sortOrder: 0)
        let noteB = NoteModel(noteId: UUID().uuidString, sortOrder: 1)
        let noteC = NoteModel(noteId: noteId, sortOrder: 2)

        [noteA, noteB, noteC].forEach { context.insert($0) }
        try context.save()

        try DataStore.resortNote(atNoteId: noteId, to: 0, context: context)
        XCTAssertEqual(noteA.sortOrder, 1)
        XCTAssertEqual(noteB.sortOrder, 2)
        XCTAssertEqual(noteC.sortOrder, 0)
    }

    func testResortNoteAtNoteIdToIndexMoveDownInsertsAndResorts() throws {
        let noteId = UUID().uuidString
        let noteA = NoteModel(noteId: noteId, sortOrder: 0)
        let noteB = NoteModel(noteId: UUID().uuidString, sortOrder: 1)
        let noteC = NoteModel(noteId: UUID().uuidString, sortOrder: 2)

        [noteA, noteB, noteC].forEach { context.insert($0) }
        try context.save()

        try DataStore.resortNote(atNoteId: noteId, to: 2, context: context)
        XCTAssertEqual(noteA.sortOrder, 2)
        XCTAssertEqual(noteB.sortOrder, 0)
        XCTAssertEqual(noteC.sortOrder, 1)
    }

    func testResortNoteAtNoteIdToIndexSameIndexReturns() throws {
        let noteId = UUID().uuidString
        let noteA = NoteModel(noteId: UUID().uuidString, sortOrder: 0)
        let noteB = NoteModel(noteId: UUID().uuidString, sortOrder: 1)
        let noteC = NoteModel(noteId: noteId, sortOrder: 2)

        [noteA, noteB, noteC].forEach { context.insert($0) }
        try context.save()

        try DataStore.resortNote(atNoteId: noteId, to: 2, context: context)
        XCTAssertEqual(noteA.sortOrder, 0)
        XCTAssertEqual(noteB.sortOrder, 1)
        XCTAssertEqual(noteC.sortOrder, 2)
    }

    func testResortNoteAtNoteIdToIndexOutOfBoundsInsertsAtCount() throws {
        let noteId = UUID().uuidString
        let noteA = NoteModel(noteId: UUID().uuidString, sortOrder: 0)
        let noteB = NoteModel(noteId: noteId, sortOrder: 1)
        let noteC = NoteModel(noteId: UUID().uuidString, sortOrder: 2)

        [noteA, noteB, noteC].forEach { context.insert($0) }
        try context.save()

        try DataStore.resortNote(atNoteId: noteId, to: 6, context: context)
        XCTAssertEqual(noteA.sortOrder, 0)
        XCTAssertEqual(noteB.sortOrder, 2)
        XCTAssertEqual(noteC.sortOrder, 1)
    }
}
