//
//  NoteDataEditing.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-11.
//

import Foundation
import SwiftData

protocol NoteDataEditing {
    func createNote(from dto: NoteDTO, context: ModelContext) throws
    func updateNote(from dto: NoteDTO, context: ModelContext) throws
    func deleteNote(withNoteId noteId: String, context: ModelContext) throws
}
