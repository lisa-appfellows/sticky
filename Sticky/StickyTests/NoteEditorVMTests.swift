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

        // Over-limit clamp also posts an accessibility announcement (side effect).
        tester.changeText(to: "567890")
        XCTAssertEqual(value, "56789", "Should clamp over-limit characters and overwrite")
        XCTAssertEqual(tester.charCounterText, "5 / 5")
    }

    func testCharacterLimitingAccessibilityHintShouldStateMaximum() {
        var value = ""
        let binding = Binding(
            get: { value },
            set: { newValue in value = newValue }
        )
        let tester = CharacterLimitingTester(text: binding, charLimit: 45)

        XCTAssertEqual(
            tester.charLimitAccessibilityHint,
            String(localized: LocalKey.a11yCharLimitHint(45))
        )
    }

    func testSaveOnNewShouldDismissOnSuccess() {
        let probe = StoreProbe()
        let vm = NoteEditorVM(store: probe)
        
        vm.save(to: context)
        
        XCTAssertFalse(vm.shouldShowAlert)
        XCTAssertNil(vm.alertModel)
        XCTAssertTrue(vm.shouldDismiss)
    }

    func testSaveOnExistingShouldUpdateDateAndDismissOnSuccess() {
        let today = Date()
        let yesterday = TestSupport.calendar.date(byAdding: .day, value: -1, to: today)!

        let probe = StoreProbe()
        let dto = NoteDTO(updated: yesterday)

        let vm = NoteEditorVM(dto: dto, store: probe)
        XCTAssertTrue(TestSupport.isSameDay(vm.dto.updated, as: yesterday))

        vm.save(to: context)

        XCTAssertTrue(TestSupport.isSameDay(vm.dto.updated, as: today))
        XCTAssertFalse(vm.shouldShowAlert)
        XCTAssertNil(vm.alertModel)
        XCTAssertTrue(vm.shouldDismiss)
    }

    func testSaveOnNewWithErrorShouldCreateAlertModelAndTriggerAlert() {
        let probe = StoreProbe(shouldError: true)
        let vm = NoteEditorVM(store: probe)

        vm.save(to: context)

        XCTAssertTrue(vm.shouldShowAlert)
        XCTAssertEqual(vm.alertModel?.title, LocalKey.saveAlertTitle)
        XCTAssertFalse(vm.shouldDismiss)
    }

    func testRetryOnSaveShouldDismissOnSuccess() {
        let probe = StoreProbe(shouldError: true)
        let vm = NoteEditorVM(store: probe)

        vm.save(to: context)
        XCTAssertNotNil(vm.alertModel)

        probe.removeError()
        vm.alertModel?.primaryAction.action()

        XCTAssertTrue(vm.shouldDismiss)
    }

    func testCancelRetryOnSaveShouldClearAlertModelAndNotDismiss() {
        let probe = StoreProbe(shouldError: true)
        let vm = NoteEditorVM(store: probe)

        vm.save(to: context)
        XCTAssertNotNil(vm.alertModel)

        probe.removeError()
        vm.alertModel?.cancelAction.action()

        XCTAssertNil(vm.alertModel)
        XCTAssertFalse(vm.shouldDismiss)
    }

    func testDeleteExistingBeforeConfirmationShouldAlertWithConfirmation() {
        let probe = StoreProbe()
        let dto = NoteDTO()
        let vm = NoteEditorVM(dto: dto, store: probe)

        vm.delete(from: context)

        XCTAssertTrue(vm.shouldShowAlert)
        XCTAssertEqual(vm.alertModel?.title, LocalKey.deleteConfirmationAlertTitle)
        XCTAssertFalse(vm.shouldDismiss)
    }

    func testDeleteExistingAfterConfirmationShouldDismissOnSuccess() {
        let probe = StoreProbe()
        let dto = NoteDTO()
        let vm = NoteEditorVM(dto: dto, store: probe)

        vm.delete(from: context)
        XCTAssertNotNil(vm.alertModel)

        vm.alertModel?.primaryAction.action()

        XCTAssertNil(vm.alertModel)
        XCTAssertTrue(vm.shouldDismiss)
    }

    func testDeleteConfirmationCancellationShouldClearAndNotDismiss() {
        let probe = StoreProbe()
        let dto = NoteDTO()
        let vm = NoteEditorVM(dto: dto, store: probe)

        vm.delete(from: context)
        XCTAssertNotNil(vm.alertModel)

        vm.alertModel?.cancelAction.action()

        XCTAssertNil(vm.alertModel)
        XCTAssertFalse(vm.shouldDismiss)
    }

    func testDeleteExistingWithErrorAfterConfirmationShouldCreateAlertModelAndTriggerAlert() {
        let probe = StoreProbe(shouldError: true)
        let dto = NoteDTO()
        let vm = NoteEditorVM(dto: dto, store: probe)

        vm.delete(from: context)
        XCTAssertNotNil(vm.alertModel)

        vm.alertModel?.primaryAction.action()

        XCTAssertTrue(vm.shouldShowAlert)
        XCTAssertEqual(vm.alertModel?.title, LocalKey.deleteAlertTitle)
        XCTAssertFalse(vm.shouldDismiss)
    }

    func testRetryOnDeleteShouldDismissOnSuccess() {
        let probe = StoreProbe(shouldError: true)
        let dto = NoteDTO()
        let vm = NoteEditorVM(dto: dto, store: probe)

        vm.delete(from: context)
        XCTAssertEqual(vm.alertModel?.title, LocalKey.deleteConfirmationAlertTitle)

        vm.alertModel?.primaryAction.action()
        XCTAssertEqual(vm.alertModel?.title, LocalKey.deleteAlertTitle)

        probe.removeError()
        vm.alertModel?.primaryAction.action()

        XCTAssertTrue(vm.shouldDismiss)
    }

    func testCancelRetryOnDeleteShouldClearAlertAndResetTriggerAndNotDismiss() {
        let probe = StoreProbe(shouldError: true)
        let dto = NoteDTO()
        let vm = NoteEditorVM(dto: dto, store: probe)

        vm.delete(from: context)
        XCTAssertEqual(vm.alertModel?.title, LocalKey.deleteConfirmationAlertTitle)

        vm.alertModel?.primaryAction.action()
        XCTAssertEqual(vm.alertModel?.title, LocalKey.deleteAlertTitle)

        probe.removeError()
        vm.alertModel?.cancelAction.action()

        XCTAssertNil(vm.alertModel)
        XCTAssertFalse(vm.shouldDismiss)
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

private final class StoreProbe: NoteDataEditing {
    private var shouldError: Bool
    private let error = DataStoreError.failedToSave

    init(shouldError: Bool = false) {
        self.shouldError = shouldError
    }

    func removeError() {
        shouldError = false
    }

    func createNote(from dto: NoteDTO, context: ModelContext) throws {
        if shouldError { throw error }
    }
    
    func updateNote(from dto: NoteDTO, context: ModelContext) throws {
        if shouldError { throw error }
    }
    
    func deleteNote(withNoteId noteId: String, context: ModelContext) throws {
        if shouldError { throw error }
    }
}
