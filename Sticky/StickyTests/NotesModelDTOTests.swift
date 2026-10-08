//
//  SwiftDataTests.swift
//  StickyTests
//
//  Created by Lisa Fellows on 2026-10-07.
//

import SwiftData
import XCTest
@testable import Sticky

@MainActor
final class NotesModelDTOTests: XCTestCase {
    private var container: ModelContainer!
    private var context: ModelContext!

    override func setUp() {
        super.setUp()
        container = PreviewSupport.modelContainer
        context = container.mainContext
    }

    func testNoteDTODefaultCreation() {
        let dto = NoteDTO()
        XCTAssertTrue(
            TestSupport.gregorianCalendar
                .isDate(dto.updated, inSameDayAs: Date())
        )
        XCTAssertEqual(dto.sortOrder, -1)
        XCTAssertTrue(dto.title.isEmpty)
        XCTAssertTrue(dto.text.isEmpty)
        XCTAssertEqual(dto.noteColor, .yellow)
    }

    func testNoteDTOManualCreation() {
        let updated = TestSupport.updatedDate
        let dto = NoteDTO(
            updated: updated,
            sortOrder: 1,
            title: "Title 1",
            text: "Text 1",
            noteColor: .purple
        )

        XCTAssertEqual(dto.updated, updated)
        XCTAssertEqual(dto.sortOrder, 1)
        XCTAssertEqual(dto.title, "Title 1")
        XCTAssertEqual(dto.text, "Text 1")
        XCTAssertEqual(dto.noteColor, .purple)
    }

    func testNoteModelDefaultCreation() throws {
        let newModel = NoteModel()
        
        let updatedString = try XCTUnwrap(newModel.updatedString)
        XCTAssertTrue(try TestSupport.sameDay(dateString: updatedString, asDate: Date()))
        XCTAssertEqual(newModel.sortOrder, -1)
        XCTAssertNil(newModel.title)
        XCTAssertNil(newModel.text)
        XCTAssertEqual(newModel.noteColorName, NoteColor.yellow.rawValue)
    }

    func testNoteModelManualCreation() {
        let updatedString = TestSupport.updatedDateString
        let newModel = NoteModel(
            updatedString: updatedString,
            sortOrder: 1,
            title: "Title 1",
            text: "Text 1",
            noteColorName: NoteColor.pink.rawValue
        )

        XCTAssertEqual(newModel.updatedString, updatedString)
        XCTAssertEqual(newModel.sortOrder, 1)
        XCTAssertEqual(newModel.title, "Title 1")
        XCTAssertEqual(newModel.text, "Text 1")
        XCTAssertEqual(newModel.noteColorName, NoteColor.pink.rawValue)
    }

    func testNoteModelCreationFromDTO() {
        let dto = NoteDTO(
            updated: TestSupport.updatedDate,
            sortOrder: 3,
            title: "Title 3",
            text: "Text 3",
            noteColor: .blue
        )

        let newModel = NoteModel(fromDTO: dto)
        XCTAssertEqual(newModel.noteId, newModel.noteId)
        XCTAssertEqual(newModel.updatedString, TestSupport.updatedDateString)
        XCTAssertEqual(newModel.sortOrder, dto.sortOrder)
        XCTAssertEqual(newModel.title, dto.title)
        XCTAssertEqual(newModel.text, dto.text)
        XCTAssertEqual(newModel.noteColorName, dto.noteColor.rawValue)
    }

    func testNoteModelUpdateFromDTO() {
        let model = NoteModel(
            updatedString: TestSupport.updatedDateString,
            sortOrder: 0,
            title: "Title",
            text: "Text",
            noteColorName: NoteColor.pink.rawValue
        )

        var dto = NoteDTO(fromModel: model)
        let newUpdated = TestSupport.createDate(
            year: 2026, month: 8, day: 1, hour: 2, minute: 30, second: 5
        )
        dto.updated = newUpdated
        dto.sortOrder = 2
        dto.title = "New Title"
        dto.text = ""
        dto.noteColor = .blue

        model.update(fromDTO: dto)
        XCTAssertEqual(model.updatedString, newUpdated.ISO8601Format())
        XCTAssertEqual(model.sortOrder, 2)
        XCTAssertEqual(model.title, "New Title")
        XCTAssertNil(model.text)
        XCTAssertEqual(model.noteColorName, NoteColor.blue.rawValue)
        
    }

    func testNoteDTOCreationFromModel() {
        let model = NoteModel(
            updatedString: TestSupport.updatedDateString,
            sortOrder: 4,
            title: "Title 4",
            text: "Text 4",
            noteColorName: NoteColor.blue.rawValue
        )

        let newDTO = NoteDTO(fromModel: model)
        XCTAssertEqual(newDTO.noteId, model.noteId)
        XCTAssertEqual(newDTO.updated, TestSupport.updatedDate)
        XCTAssertEqual(newDTO.sortOrder, model.sortOrder)
        XCTAssertEqual(newDTO.title, model.title)
        XCTAssertEqual(newDTO.text, model.text)
        XCTAssertEqual(newDTO.noteColor, .blue)
    }

    func testNoteModelFetch() throws {
        let updatedString = TestSupport.updatedDateString
        let newModel = NoteModel(
            updatedString: updatedString,
            sortOrder: 2,
            title: "Title 2",
            text: "Text 2",
            noteColorName: NoteColor.green.rawValue
        )

        context.insert(newModel)
        try context.save()

        let fetched = try context.fetch(FetchDescriptor<NoteModel>())
        XCTAssertEqual(fetched.count, 1)

        let first = try XCTUnwrap(fetched.first)
        XCTAssertEqual(first.updatedString, updatedString)
        XCTAssertEqual(first.sortOrder, 2)
        XCTAssertEqual(first.title, "Title 2")
        XCTAssertEqual(first.text, "Text 2")
        XCTAssertEqual(first.noteColorName, NoteColor.green.rawValue)
    }

    func testNoteModelMutationPersists() throws {
        let newModel = NoteModel(title: "First Title")

        context.insert(newModel)
        try context.save()

        let firstFetch = try context.fetch(FetchDescriptor<NoteModel>())
        let firstModel = try XCTUnwrap(firstFetch.first)
        XCTAssertEqual(firstModel.title, "First Title")

        firstModel.title = "Second Title"
        try context.save()

        let secondFetch = try context.fetch(FetchDescriptor<NoteModel>())
        let secondModel = try XCTUnwrap(secondFetch.first)
        XCTAssertEqual(secondModel.title, "Second Title")
    }
}
