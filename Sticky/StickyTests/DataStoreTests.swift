//
//  DataStoreTests.swift
//  StickyTests
//
//  Created by Lisa Fellows on 2026-10-07.
//

import XCTest
@testable import Sticky

final class DataStoreTests: XCTestCase {
    func testModelContainer() {
        XCTAssertNotNil(DataStore.modelContainer(inMemoryOnly: true))
        XCTAssertNotNil(DataStore.modelContainer())
    }
}
