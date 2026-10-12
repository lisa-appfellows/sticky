//
//  DataStoreError.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-11.
//

import Foundation

enum DataStoreError: Error, LocalizedError {
    case failedToFetch
    case failedToFetchCount
    case failedToFetchNote(noteId: String)
    case failedToSave
    case unknownError

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
        case .unknownError:
            return "Unknown error"
        }
    }

    func loggedDataError(_ error: Error? = nil) -> Self {
        var message = localizedDescription
        if let error { message += ": \(error.localizedDescription)" }
        AppLogger.data.error("\(message)")
        return self
    }
}
