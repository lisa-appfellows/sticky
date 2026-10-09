//
//  ContentVMTests.swift
//  StickyTests
//
//  Created by Lisa Fellows on 2026-10-07.
//

import XCTest
@testable import Sticky

final class ContentVMTests: XCTestCase {
    private var defaultsSuiteName: String!
    private var defaults: UserDefaults!
    private var vm: ContentVM!

    override func setUp() {
        super.setUp()
        let suiteName = "ContentVM_\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!

        self.defaultsSuiteName = suiteName
        self.defaults = defaults
        self.vm = .init(defaults: defaults)
    }

    override func tearDown() {
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
}
