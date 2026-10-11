//
//  NoteBoardLayoutTests.swift
//  StickyTests
//
//  Created by Lisa Fellows on 2026-10-10.
//

import XCTest
@testable import Sticky

final class NoteBoardLayoutTests: XCTestCase {
    private var sut: NoteBoardLayout!

    override func setUp() {
        super.setUp()
        sut = NoteBoardLayout()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    private var testNotes: [NoteModel] {
        (1...5).map { index in
            let dto = NoteDTO(
                noteId: "\(index)",
                updated: TestSupport.createDate(year: 2026, month: 1, day: index),
                title: "Title \(index)"
            )
            return NoteModel(fromDTO: dto)
        }
    }
}

// MARK: - Sort Updated
extension NoteBoardLayoutTests {
    func testSortNewestShouldReturnSortedByNewest() {
        let notes = testNotes.shuffled()

        let sorted = sut.sorted(notes, by: .newest)

        XCTAssertEqual(sorted[0].noteId, "5")
        XCTAssertEqual(sorted[1].noteId, "4")
        XCTAssertEqual(sorted[2].noteId, "3")
        XCTAssertEqual(sorted[3].noteId, "2")
        XCTAssertEqual(sorted[4].noteId, "1")
    }

    func testSortOldestShouldReturnSortedByOldest() {
        let notes = testNotes.shuffled()

        let sorted = sut.sorted(notes, by: .oldest)

        XCTAssertEqual(sorted[0].noteId, "1")
        XCTAssertEqual(sorted[1].noteId, "2")
        XCTAssertEqual(sorted[2].noteId, "3")
        XCTAssertEqual(sorted[3].noteId, "4")
        XCTAssertEqual(sorted[4].noteId, "5")
    }

    func testSortEitherDateRangeShouldSortNilLast() {
        let modelA = NoteModel(updatedString: nil, sortOrder: 3)
        let modelB = NoteModel(
            updatedString: TestSupport.createDateString(year: 2026),
            sortOrder: 2
        )
        let modelC = NoteModel(
            updatedString: TestSupport.createDateString(year: 2025),
            sortOrder: 5
        )
        let notes = [modelA, modelB, modelC]

        let sorted = sut.sorted(notes, by: .newest)
        XCTAssertEqual(sorted[0].noteId, modelB.noteId)
        XCTAssertEqual(sorted[1].noteId, modelC.noteId)
        XCTAssertEqual(sorted[2].noteId, modelA.noteId)
    }

    func testSortEitherDateRangeShouldDefaultToSortOrderOnNilDates() {
        let modelA = NoteModel(updatedString: nil, sortOrder: 3)
        let modelB = NoteModel(updatedString: nil, sortOrder: 2)
        let modelC = NoteModel(updatedString: nil, sortOrder: 5)
        let notes = [modelA, modelB, modelC]

        let sorted = sut.sorted(notes, by: .oldest)
        XCTAssertEqual(sorted[0].noteId, modelB.noteId)
        XCTAssertEqual(sorted[1].noteId, modelA.noteId)
        XCTAssertEqual(sorted[2].noteId, modelC.noteId)
    }

    func testSortEitherDateRangeShouldDefaultToSortOrderOnSameDates() {
        let dateString = TestSupport.createDateString()
        let modelA = NoteModel(updatedString: dateString, sortOrder: 3)
        let modelB = NoteModel(updatedString: dateString, sortOrder: 2)
        let modelC = NoteModel(updatedString: dateString, sortOrder: 5)
        let notes = [modelA, modelB, modelC]

        let sorted = sut.sorted(notes, by: .oldest)
        XCTAssertEqual(sorted[0].noteId, modelB.noteId)
        XCTAssertEqual(sorted[1].noteId, modelA.noteId)
        XCTAssertEqual(sorted[2].noteId, modelC.noteId)
    }
}

// MARK: - Sort Name
extension NoteBoardLayoutTests {
    func testSortNameShouldReturnSortedByName() {
        let notes = testNotes.shuffled()

        let sorted = sut.sorted(notes, by: .name)

        XCTAssertEqual(sorted[0].noteId, "1")
        XCTAssertEqual(sorted[1].noteId, "2")
        XCTAssertEqual(sorted[2].noteId, "3")
        XCTAssertEqual(sorted[3].noteId, "4")
        XCTAssertEqual(sorted[4].noteId, "5")
    }

    func testSortNameShouldSortByTitlesFirst() {
        let modelA = NoteModel(title: "B", text: "A")
        let modelB = NoteModel(title: "A", text: "B")
        let notes = [modelA, modelB]

        let sorted = sut.sorted(notes, by: .name)
        XCTAssertEqual(sorted[0].noteId, modelB.noteId)
        XCTAssertEqual(sorted[1].noteId, modelA.noteId)
    }

    func testSortNameShouldSortTextOnNilTitle() {
        let modelA = NoteModel(title: "B", text: "A")
        let modelB = NoteModel(text: "A")
        let notes = [modelA, modelB]

        let sorted = sut.sorted(notes, by: .name)
        XCTAssertEqual(sorted[0].noteId, modelB.noteId)
        XCTAssertEqual(sorted[1].noteId, modelA.noteId)
    }

    func testSortNameShouldDefaultToNonNilName() {
        let modelA = NoteModel()
        let modelB = NoteModel(title: "A")
        let notes = [modelA, modelB]

        let sorted = sut.sorted(notes, by: .name)
        XCTAssertEqual(sorted[0].noteId, modelB.noteId)
        XCTAssertEqual(sorted[1].noteId, modelA.noteId)
    }

    func testSortNameShouldDefaultToSortOrderOnSameName() {
        let modelA = NoteModel(sortOrder: 2, title: "Same")
        let modelB = NoteModel(sortOrder: 1, title: "Same")
        let notes = [modelA, modelB]

        let sorted = sut.sorted(notes, by: .name)
        XCTAssertEqual(sorted[0].noteId, modelB.noteId)
        XCTAssertEqual(sorted[1].noteId, modelA.noteId)
    }
}
