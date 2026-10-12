//
//  DataStore.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-07.
//

import Foundation
import SwiftData

struct DataStore: NoteDataEditing {
    static let shared = DataStore()
    private init() {}

    func save(context: ModelContext) throws {
        do {
            try context.save()
        } catch {
            throw DataStoreError.failedToSave.loggedDataError(error)
        }
    }

    func createNote(from dto: NoteDTO, context: ModelContext) throws {
        let newModel = NoteModel(fromDTO: dto)
        context.insert(newModel)
        try save(context: context)
    }

    func updateNote(from dto: NoteDTO, context: ModelContext) throws {
        do {
            guard let model = try fetchNote(byNoteId: dto.noteId, context: context) else {
                throw DataStoreError.failedToFetchNote(noteId: dto.noteId).loggedDataError()
            }
            model.update(fromDTO: dto)
            try save(context: context)
        } catch let dataStoreError as DataStoreError {
            throw dataStoreError
        } catch {
            throw DataStoreError.unknownError.loggedDataError(error)
        }
    }

    func deleteNote(withNoteId noteId: String, context: ModelContext) throws {
        do {
            guard let model = try fetchNote(byNoteId: noteId, context: context) else {
                throw DataStoreError.failedToFetchNote(noteId: noteId).loggedDataError()
            }
            context.delete(model)
            try save(context: context)
        } catch let dataStoreError as DataStoreError {
            throw dataStoreError
        } catch {
            throw DataStoreError.unknownError.loggedDataError(error)
        }
    }
}

// MARK: - Fetching
extension DataStore {
    func fetchNoteCount(from context: ModelContext) throws -> Int {
        do {
            return try context.fetchCount(FetchDescriptor<NoteModel>())
        } catch {
            throw DataStoreError.failedToFetchCount.loggedDataError(error)
        }
    }

    func fetchNotes(from context: ModelContext) throws -> [NoteModel] {
        do {
            return try context.fetch(FetchDescriptor<NoteModel>())
        } catch {
            throw DataStoreError.failedToFetch.loggedDataError(error)
        }
    }

    func fetchNote(byNoteId noteId: String, context: ModelContext) throws -> NoteModel? {
        do {
            let descriptor = FetchDescriptor<NoteModel>(
                predicate: #Predicate { $0.noteId == noteId }
            )
            return try context.fetch(descriptor).first
        } catch {
            throw DataStoreError.failedToFetchNote(noteId: noteId).loggedDataError(error)
        }
    }
}
