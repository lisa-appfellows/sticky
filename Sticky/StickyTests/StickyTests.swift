//
//  StickyTests.swift
//  StickyTests
//
//  Created by Lisa Fellows on 2026-10-06.
//

import XCTest
@testable import Sticky

final class StickyTests: XCTestCase {
    func testDefaultViewTypeSavesToDefaultsOnSet() {
        let suiteName = "StickyTest_.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defer { defaults.removeSuite(named: suiteName) }

        let sut = DefaultViewType(defaults: defaults)
        XCTAssertEqual(sut.value, .list) // starting value

        sut.value = .compact
        XCTAssertEqual(sut.value, .compact)
    }
}
