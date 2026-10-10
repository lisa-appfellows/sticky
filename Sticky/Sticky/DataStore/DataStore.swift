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

// MARK: - Sorting
extension DataStore {
    static func resortModels(byCleanUp option: CleanUpOption, context: ModelContext) throws {
        let notes = try fetchNotes(from: context)
    
        switch option {
        case .newest:
            assignSortOrdersByDate(notes, isNewest: true)
        case .oldest:
            assignSortOrdersByDate(notes, isNewest: false)
        case .name:
            assignSortOrdersByName(notes)
        case .color:
            assignSortOrdersByColor(notes)
        }
    
        try save(context: context)
    }

    static func resortNote(atNoteId noteId: String, to index: Int, context: ModelContext) throws {
        let notes = try fetchNotes(from: context)
        var ordered = notes.sorted { ($0.sortOrder ?? -1) < ($1.sortOrder ?? -1)}

        guard let from = ordered.firstIndex(where: { $0.noteId == noteId }),
              from != index else {
            return
        }

        let note = ordered.remove(at: from)
        let clamped = min(max(index, 0), ordered.count)
        ordered.insert(note, at: clamped)

        assignSortOrders(toOrderedNotes: ordered)
        try save(context: context)
    }

    private static func assignSortOrders(toOrderedNotes notes: [NoteModel]) {
        for (index, note) in notes.enumerated() {
            note.sortOrder = index
        }
    }

    private static func assignSortOrdersByDate(_ notes: [NoteModel], isNewest: Bool) {
        let sorted = notes.sorted {
            switch ($0.updatedString, $1.updatedString) {
            case let (a?, b?) where a != b:
                return isNewest ? a > b : a < b
            case (_?, nil):
                return true
            case (nil, _?):
                return false
            default:
                return ($0.sortOrder ?? -1) < ($1.sortOrder ?? -1)
            }
        }
        assignSortOrders(toOrderedNotes: sorted)
    }

    private static func assignSortOrdersByName(_ notes: [NoteModel]) {
        let sorted = notes.sorted {
            switch (($0.title ?? $0.text), ($1.title ?? $1.text)) {
            case let (a?, b?) where a != b:
                return a.localizedStandardCompare(b) == .orderedAscending
            case (_?, nil):
                return true
            case (nil, _?):
                return false
            default:
                return ($0.sortOrder ?? -1) < ($1.sortOrder ?? -1)
            }
        }
        assignSortOrders(toOrderedNotes: sorted)
    }

    private static func assignSortOrdersByColor(_ notes: [NoteModel]) {
        let sorted = notes.sorted { a, b in
            let colorA = NoteColor(rawValue: a.noteColorName ?? "")?.sortPriority ?? Int.max
            let colorB = NoteColor(rawValue: b.noteColorName ?? "")?.sortPriority ?? Int.max
            if colorA != colorB { return colorA < colorB }
            return (a.sortOrder ?? -1) < (b.sortOrder ?? -1)
        }
        assignSortOrders(toOrderedNotes: sorted)
    }
}
