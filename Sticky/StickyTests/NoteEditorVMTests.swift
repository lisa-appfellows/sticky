//
//  NoteEditorVMTests.swift
//  StickyTests
//
//  Created by Lisa Fellows on 2026-10-08.
//

import XCTest
@testable import Sticky

@MainActor
final class NoteEditorVMTests: XCTestCase {
    func testDateStringIsNewShouldUseCreatedLocalization() {
        let expectedString = "Created: \(dateFormatted(Date()))"

        let vm = NoteEditorVM(dto: nil)

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

    private func dateFormatted(_ date: Date) -> String {
        date.formatted(date: .long, time: .omitted)
    }
}
