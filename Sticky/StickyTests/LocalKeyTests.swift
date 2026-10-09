//
//  LocalKeyTests.swift
//  StickyTests
//
//  Created by Lisa Fellows on 2026-10-08.
//

import SwiftUI
import XCTest
@testable import Sticky

final class LocalKeyTests: XCTestCase {
    func testLocalKeyResolvesEnglishString() {
        var localKey = LocalKey.cancel
        localKey.locale = Locale(identifier: "en")
        let localized = String(localized: localKey)
        XCTAssertEqual(localized, "Cancel")
    }

    func testLocalKeyResolvesSpanishString() {
        var localKey = LocalKey.cancel
        localKey.locale = Locale(identifier: "es")
        let localized = String(localized: localKey)
        XCTAssertEqual(localized, "Cancelar")
    }

    func testCreatedLocalKeyResolvesEnglishWithDateString() {
        let dateString = "January 1, 2026"
        var localKey = LocalKey.created(withDateString: dateString)
        localKey.locale = Locale(identifier: "en")
        let localized = String(localized: localKey)
        XCTAssertEqual(localized, "Created: \(dateString)")
    }

    func testCreatedLocalKeyResolvesSpanishWithDateString() {
        let dateString = "1 de enero de 2026"
        var localKey = LocalKey.created(withDateString: dateString)
        localKey.locale = Locale(identifier: "es")
        let localized = String(localized: localKey)
        XCTAssertEqual(localized, "Creada: \(dateString)")
    }

    func testUpdatedLocalKeyResolvesEnglishWithDateString() {
        let dateString = "January 1, 2026"
        var localKey = LocalKey.updated(withDateString: dateString)
        localKey.locale = Locale(identifier: "en")
        let localized = String(localized: localKey)
        XCTAssertEqual(localized, "Updated: \(dateString)")
    }

    func testUpdatedLocalKeyResolvesSpanishWithDateString() {
        let dateString = "1 de enero de 2026"
        var localKey = LocalKey.updated(withDateString: dateString)
        localKey.locale = Locale(identifier: "es")
        let localized = String(localized: localKey)
        XCTAssertEqual(localized, "Actualizada: \(dateString)")
    }
}
