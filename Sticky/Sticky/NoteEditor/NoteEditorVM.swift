//
//  NoteEditorVM.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-07.
//

import SwiftData
import SwiftUI

enum EditorOperation { case save, delete }

@MainActor
@Observable
final class NoteEditorVM {
    private let isNew: Bool
    let defaultedColor: NoteColor

    var dto: NoteDTO
    var currentOperation: EditorOperation?
    var shouldShowAlert = false
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

    var failedOperationTitle: LocalizedStringResource {
        switch currentOperation {
        case .save:
            return LocalKey.saveAlertTitle
        case .delete:
            return LocalKey.deleteAlertTitle
        case nil:
            return LocalKey.operationFailedTitle
        }
    }
    
    var canDelete: Bool { !isNew }
    
    init(dto: NoteDTO? = nil, noteColor: NoteColor? = nil) {
        self.isNew = dto == nil
        self.defaultedColor = noteColor ?? .yellow
        self.dto = dto ?? .init()

        if self.dto.noteColor != defaultedColor {
            self.dto.noteColor = defaultedColor
        }
    }

    func retryOperation(context: ModelContext) {
        if shouldShowAlert { shouldShowAlert = false }
        guard let currentOperation else { return }

        switch currentOperation {
        case .save:
            save(to: context)
        case .delete:
            delete(from: context)
        }
    }

    func save(to context: ModelContext) {
        currentOperation = .save

        do {
            if isNew {
                try DataStore.createNote(from: dto, context: context)
            } else {
                try DataStore.updateNote(from: dto, context: context)
            }
            shouldDismiss = true
        } catch {
            // TODO: Logging
            shouldShowAlert = true
        }
    }

    func delete(from context: ModelContext) {
        currentOperation = .delete

        guard !isNew else {
            shouldDismiss = true
            return
        }

        do {
            try DataStore.deleteNote(byNoteId: dto.noteId, context: context)
            shouldDismiss = true
        } catch {
            // TODO: Logging
            shouldShowAlert = true
        }
    }

    func cancelOperation() {
        currentOperation = nil
    }
}
