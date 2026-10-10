//
//  DataStore.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-07.
//

import Foundation
import SwiftData

enum DataStoreError: Error, LocalizedError {
    case failedToFetch
    case failedToFetchCount
    case failedToFetchNote(noteId: String)
    case failedToSave
    case unknownError(Error)

    var errorDescription: String? {
        switch self {
        case .failedToFetch:
            return "Failed to fetch notes"
        case .failedToFetchCount:
            return "Failed to fetch note count"
        case .failedToFetchNote(let noteId):
            return "Failed to fetch note for noteId \(noteId)"
        case .failedToSave:
            return "Failed to save"
        case .unknownError(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
}

enum DataStore {
    static func save(context: ModelContext) throws {
        do {
            try context.save()
        } catch {
            // TODO: Logging
            throw DataStoreError.failedToSave
        }
    }

    @discardableResult
    static func createNote(from dto: NoteDTO, context: ModelContext) throws -> NoteModel {
        let newModel = NoteModel(fromDTO: dto)
        context.insert(newModel)
        try save(context: context)
        return newModel
    }

    static func updateNote(from dto: NoteDTO, context: ModelContext) throws {
        do {
            guard let model = try fetchNote(byNoteId: dto.noteId, context: context) else {
                throw DataStoreError.failedToFetchNote(noteId: dto.noteId)
            }
            model.update(fromDTO: dto)
            try save(context: context)
        } catch let dataStoreError as DataStoreError {
            throw dataStoreError
        } catch {
            throw DataStoreError.unknownError(error)
        }
    }

    static func deleteNote(byNoteId noteId: String, context: ModelContext) throws {
        do {
            guard let model = try fetchNote(byNoteId: noteId, context: context) else {
                throw DataStoreError.failedToFetchNote(noteId: noteId)
            }
            context.delete(model)
            try save(context: context)
        } catch let dataStoreError as DataStoreError {
            throw dataStoreError
        } catch {
            // TODO: Logging
            throw DataStoreError.unknownError(error)
        }
    }
}

// MARK: - Fetching
extension DataStore {
    static func fetchNoteCount(from context: ModelContext) throws -> Int {
        do {
            return try context.fetchCount(FetchDescriptor<NoteModel>())
        } catch {
            // TODO: Logging
            throw DataStoreError.failedToFetchCount
        }
    }

    static func fetchNotes(from context: ModelContext) throws -> [NoteModel] {
        do {
            return try context.fetch(FetchDescriptor<NoteModel>())
        } catch {
            // TODO: Logging
            throw DataStoreError.failedToFetch
        }
    }

    static func fetchNote(byNoteId noteId: String, context: ModelContext) throws -> NoteModel? {
        do {
            let descriptor = FetchDescriptor<NoteModel>(
                predicate: #Predicate { $0.noteId == noteId }
            )
            return try context.fetch(descriptor).first
        } catch {
            // TODO: Logging
            throw DataStoreError.failedToFetchNote(noteId: noteId)
        }
    }
}
