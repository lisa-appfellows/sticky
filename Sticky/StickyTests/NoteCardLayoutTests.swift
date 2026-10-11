//
//  NoteCardLayoutTests.swift
//  StickyTests
//
//  Created by Lisa Fellows on 2026-10-08.
//

import XCTest
@testable import Sticky

@MainActor
final class NoteCardLayoutTests: XCTestCase {
    func testDateStringGridViewShouldUseNumeric() {
        let updated = TestSupport.updatedDate
        let expectedFormat = updated.formatted(date: .numeric, time: .omitted)
        let expectedString = "Updated: \(expectedFormat)"

        let dto = NoteDTO(updated: updated)
        let vm = NoteCardLayout(dto: dto, viewType: .grid)

        var resource = vm.dateString
        resource.locale = Locale(identifier: "en")
        let localizedDateString = String(localized: resource)

        XCTAssertEqual(localizedDateString, expectedString)
    }

    func testDateStringCompactViewShouldUseLong() {
        let updated = TestSupport.updatedDate
        let expectedFormat = updated.formatted(date: .long, time: .omitted)
        let expectedString = "Updated: \(expectedFormat)"

        let dto = NoteDTO(updated: updated)
        let vm = NoteCardLayout(dto: dto, viewType: .compact)

        var resource = vm.dateString
        resource.locale = Locale(identifier: "en")
        let localizedDateString = String(localized: resource)

        XCTAssertEqual(localizedDateString, expectedString)
    }

    func testDateStringListViewShouldUseLong() {
        let updated = TestSupport.updatedDate
        let expectedFormat = updated.formatted(date: .long, time: .omitted)
        let expectedString = "Updated: \(expectedFormat)"

        let dto = NoteDTO(updated: updated)
        let vm = NoteCardLayout(dto: dto, viewType: .list)

        var resource = vm.dateString
        resource.locale = Locale(identifier: "en")
        let localizedDateString = String(localized: resource)

        XCTAssertEqual(localizedDateString, expectedString)
    }

    func testCardWidthForGridShouldResolveHalfMinusPadding() {
        let viewType = ViewType.grid
        let availableWidth: CGFloat = 240
        let expected = (availableWidth / 2) - viewType.noteSpacing
        let vm = NoteCardLayout(dto: .init(), viewType: viewType)
        XCTAssertEqual(vm.adjustedWidth(availableWidth), expected)
    }

    func testCardWidthForCompactShouldResolveFullWidth() {
        let availableWidth: CGFloat = 240
        let vm = NoteCardLayout(dto: .init(), viewType: .compact)
        XCTAssertEqual(vm.adjustedWidth(availableWidth), availableWidth)
    }

    func testCardWidthForListShouldResolveFullWidth() {
        let availableWidth: CGFloat = 240
        let vm = NoteCardLayout(dto: .init(), viewType: .list)
        XCTAssertEqual(vm.adjustedWidth(availableWidth), availableWidth)
    }

    func testCardHeightForGridShouldResolveHalfMinusPadding() {
        let viewType = ViewType.grid
        let availableWidth: CGFloat = 240
        let expected = (availableWidth / 2) - viewType.noteSpacing
        let vm = NoteCardLayout(dto: .init(), viewType: viewType)
        XCTAssertEqual(vm.adjustedHeight(availableWidth), expected)
    }

    func testCardHeightForCompactShouldResolveHalfWidth() {
        let availableWidth: CGFloat = 240
        let expected = availableWidth / 2
        let vm = NoteCardLayout(dto: .init(), viewType: .compact)
        XCTAssertEqual(vm.adjustedHeight(availableWidth), expected)
    }

    func testCardHeightForListShouldResolveFullWidth() {
        let availableWidth: CGFloat = 240
        let vm = NoteCardLayout(dto: .init(), viewType: .list)
        XCTAssertEqual(vm.adjustedHeight(availableWidth), availableWidth)
    }

    func testAccessibilityLabelIncludesTitleTextColorAndDate() {
        let updated = TestSupport.updatedDate
        let dateFormat = updated.formatted(date: .numeric, time: .omitted)
        let dto = NoteDTO(
            updated: updated,
            title: "Hello",
            text: "World",
            noteColor: .blue
        )
        let layout = NoteCardLayout(dto: dto, viewType: .grid)

        XCTAssertEqual(
            layout.accessibilityLabel(locale: Locale(identifier: "en")),
            "Hello, World, Blue, Updated: \(dateFormat)"
        )
    }

    func testAccessibilityLabelOmitsEmptyText() {
        let updated = TestSupport.updatedDate
        let dateFormat = updated.formatted(date: .numeric, time: .omitted)
        let dto = NoteDTO(
            updated: updated,
            title: "Hello",
            text: "",
            noteColor: .pink
        )
        let layout = NoteCardLayout(dto: dto, viewType: .grid)

        XCTAssertEqual(
            layout.accessibilityLabel(locale: Locale(identifier: "en")),
            "Hello, Pink, Updated: \(dateFormat)"
        )
    }

    func testAccessibilityLabelOmitsEmptyTitle() {
        let updated = TestSupport.updatedDate
        let dateFormat = updated.formatted(date: .numeric, time: .omitted)
        let dto = NoteDTO(
            updated: updated,
            title: "",
            text: "World",
            noteColor: .green
        )
        let layout = NoteCardLayout(dto: dto, viewType: .grid)

        XCTAssertEqual(
            layout.accessibilityLabel(locale: Locale(identifier: "en")),
            "World, Green, Updated: \(dateFormat)"
        )
    }

    func testAccessibilityLabelUsesNoteFallbackWhenTitleAndTextEmpty() {
        let updated = TestSupport.updatedDate
        let dateFormat = updated.formatted(date: .numeric, time: .omitted)
        let dto = NoteDTO(
            updated: updated,
            title: "",
            text: "",
            noteColor: .yellow
        )
        let layout = NoteCardLayout(dto: dto, viewType: .grid)

        XCTAssertEqual(
            layout.accessibilityLabel(locale: Locale(identifier: "en")),
            "Note, Yellow, Updated: \(dateFormat)"
        )
    }
}
