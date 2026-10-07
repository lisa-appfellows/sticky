//
//  DataStore.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-07.
//

import Foundation
import SwiftData

enum V1Schema: VersionedSchema {
    static let versionIdentifier: Schema.Version = .init(1, 0, 0)
    static let models: [any PersistentModel.Type] = [
        NoteModel.self
    ]
}

enum MigrationPlan: SchemaMigrationPlan {
    static let schemas: [VersionedSchema.Type] = [
        V1Schema.self
    ]
    
    static let stages: [MigrationStage] = []
}

enum DataStore {
    static func modelContainer(inMemoryOnly: Bool = false) -> ModelContainer {
        do {
            let schema = Schema(versionedSchema: V1Schema.self)
            let config = ModelConfiguration(isStoredInMemoryOnly: inMemoryOnly)
            return try ModelContainer(
                for: schema,
                migrationPlan: MigrationPlan.self,
                configurations: config
            )
        } catch {
            fatalError("Failed to create model container: \(error.localizedDescription)")
        }
    }
}
