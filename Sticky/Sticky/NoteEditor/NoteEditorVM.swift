//
//  NoteEditorVM.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-07.
//

import SwiftData
import SwiftUI

enum EditorOperation { case save, delete, deleteConfirmation }

@MainActor
@Observable
final class NoteEditorVM {
    private let isNew: Bool
    private let store: NoteDataEditing
    var dto: NoteDTO

    private var currentOperation: EditorOperation?
    var shouldShowAlert = false
    private(set) var alertModel: AlertModel?
    private(set) var shouldDismiss = false

    var navTitle: LocalizedStringResource {
        isNew ? LocalKey.createNote : LocalKey.editNote
    }
    
    var rowBackgroundColor: Color {
        dto.noteColor.color
    }
    
    var dateString: LocalizedStringResource {
        let dateString = dto.updated.formatted(date: .long, time: .omitted)
        return isNew ?
        LocalKey.created(withDateString: dateString) :
        LocalKey.updated(withDateString: dateString)
    }
    
    var canDelete: Bool { !isNew }
    
    init(dto: NoteDTO, store: NoteDataEditing = DataStore.shared) {
        self.isNew = false
        self.store = store
        self.dto = dto
    }

    init(noteColor: NoteColor? = nil, store: NoteDataEditing = DataStore.shared) {
        self.isNew = true
        self.store = store
        self.dto = .init(noteColor: noteColor ?? .yellow)
    }

    func save(to context: ModelContext)  {
        clearAlert()
        currentOperation = .save

        do {
            if isNew {
                try store.createNote(from: dto, context: context)
            } else {
                dto.updated = .now
                try store.updateNote(from: dto, context: context)
            }
            shouldDismiss = true
        } catch {
            alertModel = saveFailureAlert(context: context)
            shouldShowAlert = true
        }
    }

    func delete(from context: ModelContext) {
        clearAlert()

        guard !isNew else {
            shouldDismiss = true
            return
        }

        if currentOperation == nil {
            currentOperation = .deleteConfirmation
            alertModel = deleteConfirmationAlert(context: context)
            shouldShowAlert = true
            return
        }

        if currentOperation != .delete { currentOperation = .delete }

        do {
            try store.deleteNote(withNoteId: dto.noteId, context: context)
            shouldDismiss = true
        } catch {
            alertModel = deleteFailureAlert(context: context)
            shouldShowAlert = true
        }
    }

    private func cancelOperation() {
        currentOperation = nil
        clearAlert()
    }

    private func clearAlert() {
        if alertModel != nil { alertModel = nil }
        if shouldShowAlert { shouldShowAlert = false }
    }

    private func saveFailureAlert(context: ModelContext) -> AlertModel {
        EditorAlert.saveFailure.model { [weak self] in
            self?.save(to: context)
        } cancel: { [weak self] in
            self?.cancelOperation()
        }
    }

    private func deleteFailureAlert(context: ModelContext) -> AlertModel {
        EditorAlert.deleteFailure.model { [weak self] in
            self?.delete(from: context)
        } cancel: { [weak self] in
            self?.cancelOperation()
        }

    }

    private func deleteConfirmationAlert(context: ModelContext) -> AlertModel {
        EditorAlert.deleteConfirmation.model { [weak self] in
            self?.delete(from: context)
        } cancel: { [weak self] in
            self?.cancelOperation()
        }
    }
}
