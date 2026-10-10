//
//  ContentVMTests.swift
//  StickyTests
//
//  Created by Lisa Fellows on 2026-10-07.
//

import SwiftData
import XCTest
@testable import Sticky

final class ContentVMTests: XCTestCase {
    private var vm: ContentVM!
    private var defaults: UserDefaults!
    private var suiteName: String!

    override func setUp() {
        super.setUp()
        let suiteName = "ContentVMTests_\(UUID().uuidString)"
        self.suiteName = suiteName

        let defaults = UserDefaults(suiteName: suiteName)!
        self.defaults = defaults

        self.vm = ContentVM(defaults: defaults)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: suiteName)
        super.tearDown()
    }

    func testColorFilterSavesToDefaultsOnSetOfValid() throws {
        let storage = DefaultsStorage.noteColor
        
        XCTAssertNil(vm.colorFilter, "Should default to nil with no prior save")

        vm.colorFilter = .blue
        let saved = try XCTUnwrap(NoteColor(rawValue: storage.load(from: defaults)))
        XCTAssertEqual(saved, .blue, "Should have saved `blue` on assignment")

        let newVM = ContentVM(defaults: defaults)
        XCTAssertEqual(newVM.colorFilter, .blue, "Should have loaded last previous save on new init")
    }

    func testColorFilterRemovesPreviousValueFromDefaultsOnNilSet() throws {
        let storage = DefaultsStorage.noteColor
        
        XCTAssertNil(vm.colorFilter, "Should default to nil with no prior save")

        vm.colorFilter = .blue
        let savedBlue = try XCTUnwrap(NoteColor(rawValue: storage.load(from: defaults)))
        XCTAssertEqual(savedBlue, .blue, "Should have saved `blue` on assignment")

        vm.colorFilter = nil
        let removed = NoteColor(rawValue: storage.load(from: defaults))
        XCTAssertNil(removed, "Should have removed `blue` on nil assignment")

        let newVM = ContentVM(defaults: defaults)
        XCTAssertNil(newVM.colorFilter, "Should have registered previous removal on new init")
    }

    func testSortOptionSavesToDefaultsOnSet() throws {
        let storage = DefaultsStorage.sortOption
        
        XCTAssertEqual(vm.sortOption, .newest, "Should default to `newest` with no prior save")

        vm.sortOption = .name
        let saved = try XCTUnwrap(SortOption(rawValue: storage.load(from: defaults)))
        XCTAssertEqual(saved, .name, "Should have saved `name` on assignment")

        let newVM = ContentVM(defaults: defaults)
        XCTAssertEqual(newVM.sortOption, .name, "Should have loaded last previous save on new init")
    }

    func testViewTypeSavesToDefaultsOnSet() throws {
        let storage = DefaultsStorage.viewType
        
        XCTAssertEqual(vm.viewType, .list, "Should default to `list` with no prior save")

        vm.viewType = .grid
        let saved = try XCTUnwrap(ViewType(rawValue: storage.load(from: defaults)))
        XCTAssertEqual(saved, .grid, "Should have saved `grid` on assignment")

        let newVM = ContentVM(defaults: defaults)
        XCTAssertEqual(newVM.viewType, .grid, "Should have loaded last previous save on new init")
    }
}
