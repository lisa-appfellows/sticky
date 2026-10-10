//
//  ContentVMTests.swift
//  StickyTests
//
//  Created by Lisa Fellows on 2026-10-07.
//

import SwiftData
import XCTest
@testable import Sticky

@MainActor
final class ContentVMTests: XCTestCase {
    private var container: ModelContainer!
    private var context: ModelContext!

    private var defaultsSuiteName: String!
    private var defaults: UserDefaults!

    private var vm: ContentVM!

    override func setUp() {
        super.setUp()
        container = DataStore.modelContainer(inMemoryOnly: true)
        context = container.mainContext

        let suiteName = "ContentVM_\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!

        self.defaultsSuiteName = suiteName
        self.defaults = defaults

        self.vm = .init(defaults: defaults)
    }

    override func tearDown() {
        container = nil
        context = nil
        defaults.removePersistentDomain(forName: defaultsSuiteName)
        defaultsSuiteName = nil
        defaults = nil
        vm = nil
        super.tearDown()
    }

    func testViewTypeSavesToDefaultsOnSet() {
        XCTAssertEqual(vm.viewType, .list)

        vm.setViewType(.grid)
        XCTAssertEqual(vm.viewType, .grid)

        let newVM = ContentVM(defaults: defaults)
        XCTAssertEqual(newVM.viewType, .grid)
    }

    func testCleanUpNewestShouldSortByNewestDate() throws {
        try seedStore()
        vm.cleanUpOptionSelected(.newest, context: context)

        let fetchedNotes = try DataStore.fetchNotes(from: context)
        let sorted = sortNotes(fetchedNotes)

        XCTAssertEqual(sorted.count, 5)
        // Seed days 0...4 → newest puts day 4 at sortOrder 0
        for (index, model) in sorted.enumerated() {
            let day = sorted.count - 1 - index
            let expected = TestSupport.createDate(year: 2026, month: 1, day: day)
            XCTAssertEqual(model.updatedString, expected.ISO8601Format())
        }
    }

    func testCleanUpOldestShouldSortByOldestDate() throws {
        try seedStore()
        vm.cleanUpOptionSelected(.oldest, context: context)

        let fetchedNotes = try DataStore.fetchNotes(from: context)
        let sorted = sortNotes(fetchedNotes)

        XCTAssertEqual(sorted.count, 5)
        for (index, model) in sorted.enumerated() {
            let expected = TestSupport.createDate(year: 2026, month: 1, day: index)
            XCTAssertEqual(model.updatedString, expected.ISO8601Format())
        }
    }

    func testCleanUpByNameShouldSortByName() throws {
        try seedStore()
        vm.cleanUpOptionSelected(.name, context: context)

        let fetchedNotes = try DataStore.fetchNotes(from: context)
        let sorted = sortNotes(fetchedNotes)

        XCTAssertEqual(sorted.count, 5)
        for (index, model) in sorted.enumerated() {
            XCTAssertEqual(model.title, "Title \(index)")
        }
    }

    func testCleanUpColorShouldSortByColor() throws {
        try seedStore()
        vm.cleanUpOptionSelected(.color, context: context)

        let fetchedNotes = try DataStore.fetchNotes(from: context)
        let sorted = sortNotes(fetchedNotes)

        XCTAssertEqual(sorted.count, 5)

        let noteColors = NoteColor.allCases
        for (index, model) in sorted.enumerated() {
            let expected = noteColors[index]
            XCTAssertEqual(model.noteColorName, expected.rawValue)
        }
    }
}

// MARK: - Helper
extension ContentVMTests {
    private func seedStore() throws {
        for (index, noteColor) in NoteColor.allCases.enumerated() {
            let newDTO = NoteDTO(
                updated: TestSupport.createDate(year: 2026, month: 1, day: index),
                title: "Title \(index)",
                noteColor: noteColor
            )
            try DataStore.createNote(from: newDTO, context: context)
        }
    }

    private func sortNotes(_ notes: [NoteModel]) -> [NoteModel] {
        notes.sorted { ($0.sortOrder ?? -1) < ($1.sortOrder ?? -1) }
    }
}
