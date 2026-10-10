//
//  NoteEditorVMTests.swift
//  StickyTests
//
//  Created by Lisa Fellows on 2026-10-08.
//

import SwiftData
import SwiftUI
import XCTest
@testable import Sticky

@MainActor
final class NoteEditorVMTests: XCTestCase {
    private var container: ModelContainer!
    private var context: ModelContext!

    override func setUp() {
        super.setUp()
        container = DataStore.modelContainer(inMemoryOnly: true)
        context = container.mainContext
    }

    func testIsNewWithNilNoteColorShouldDefaultToYellow() {
        let vm = NoteEditorVM()
        XCTAssertEqual(vm.dto.noteColor, .yellow)
    }

    func testIsNewNoteColorShouldDefaultToNoteColor() {
        let vm = NoteEditorVM(noteColor: .pink)
        XCTAssertEqual(vm.dto.noteColor, .pink)
    }

    func testDateStringIsNewShouldUseCreatedLocalization() {
        let expectedString = "Created: \(dateFormatted(Date()))"

        let vm = NoteEditorVM()

        var resource = vm.dateString
        resource.locale = Locale(identifier: "en")
        let localizedDateString = String(localized: resource)

        XCTAssertEqual(localizedDateString, expectedString)
    }

    func testDateStringIsNotNewShouldUseUpdatedLocalization() {
        let updated = TestSupport.updatedDate
        let expectedString = "Updated: \(dateFormatted(updated))"

        let dto = NoteDTO(updated: updated)
        let vm = NoteEditorVM(dto: dto)

        var resource = vm.dateString
        resource.locale = Locale(identifier: "en")
        let localizedDateString = String(localized: resource)

        XCTAssertEqual(localizedDateString, expectedString)
    }

    func testCharacterLimitingClampShouldClampAtCharLimitAndOverwrite() {
        var value = ""
        let binding = Binding(
            get: { value },
            set: { newValue in value = newValue }
        )

        let tester = CharacterLimitingTester(text: binding, charLimit: 5)
        tester.changeText(to: "1234")
        XCTAssertEqual(value, "", "Should not overwrite within character limit")
        XCTAssertEqual(tester.charCounterText, "0 / 5")

        tester.changeText(to: "567890")
        XCTAssertEqual(value, "56789", "Should clamp over-limit characters and overwrite")
        XCTAssertEqual(tester.charCounterText, "5 / 5")
    }

    func testSaveOnNewShouldCreateNewAndDismiss() throws {
        let vm = NoteEditorVM()

        vm.dto.title = "Title A"
        vm.save(to: context)

        let fetchedNotes = try DataStore.fetchNotes(from: context)
        XCTAssertEqual(fetchedNotes.first?.title, "Title A")
        XCTAssertTrue(vm.shouldDismiss)
    }

    func testSaveOnExistingShouldUpdateExistingAndDismiss() throws {
        let dto = NoteDTO(title: "Title B")
        try DataStore.createNote(from: dto, context: context)

        let firstFetchedNotes = try DataStore.fetchNotes(from: context)
        let first = try XCTUnwrap(firstFetchedNotes.first)
        XCTAssertEqual(first.title, "Title B")

        let vm = NoteEditorVM(dto: first.asDTO)

        vm.dto.title = "Updated Title"
        vm.save(to: context)

        let secondFetchedNotes = try DataStore.fetchNotes(from: context)
        XCTAssertEqual(secondFetchedNotes.first?.title, "Updated Title")
        XCTAssertTrue(vm.shouldDismiss)
    }

    func testDeleteOnExistingShouldDeleteExistingAndDismiss() throws {
        let dto = NoteDTO(title: "Title C")
        try DataStore.createNote(from: dto, context: context)

        let firstFetchedNotes = try DataStore.fetchNotes(from: context)
        let first = try XCTUnwrap(firstFetchedNotes.first)
        XCTAssertEqual(first.title, "Title C")

        let vm = NoteEditorVM(dto: first.asDTO)
        vm.delete(from: context)

        let fetchCount = try DataStore.fetchNoteCount(from: context)
        XCTAssertEqual(fetchCount, 0)
        XCTAssertTrue(vm.shouldDismiss)
    }

    func testRetryOnSaveOperationShouldSaveToContextAndDismiss() throws {
        let vm = NoteEditorVM()
        vm.currentOperation = .save

        vm.dto.title = "Title D"
        vm.retryOperation(context: context)

        let fetchedNotes = try DataStore.fetchNotes(from: context)
        XCTAssertEqual(fetchedNotes.first?.title, "Title D")
        XCTAssertTrue(vm.shouldDismiss)
    }

    func testRetryOnDeleteOperationShouldDeleteFromContextAndDismiss() throws {
        let dto = NoteDTO(title: "Title E")
        try DataStore.createNote(from: dto, context: context)

        let firstFetchedNotes = try DataStore.fetchNotes(from: context)
        let first = try XCTUnwrap(firstFetchedNotes.first)
        XCTAssertEqual(first.title, "Title E")

        let vm = NoteEditorVM(dto: first.asDTO)
        vm.currentOperation = .delete
        vm.retryOperation(context: context)

        let fetchCount = try DataStore.fetchNoteCount(from: context)
        XCTAssertEqual(fetchCount, 0)
        XCTAssertTrue(vm.shouldDismiss)
    }

    private func dateFormatted(_ date: Date) -> String {
        date.formatted(date: .long, time: .omitted)
    }
}

// MARK: - Helper
private struct CharacterLimitingTester: CharacterLimiting {
    var text: Binding<String>
    let charLimit: Int

    func changeText(to newText: String) {
        clampText(newText)
    }
}
