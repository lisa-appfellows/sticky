# Data Store

SwiftData persistence. Prefer optionals on the model where fields may deprecate across versions.

## `NoteModel`

| Property | Type | Notes |
| -------- | ---- | ----- |
| `noteId` | `String` | Default `UUID().uuidString` |
| `updatedString` | `String?` | ISO8601 |
| `sortOrder` | `Int?` | `-1` / unset until sorted |
| `title` | `String?` | |
| `text` | `String?` | |
| `noteColorName` | `String?` | Default yellow raw value |

- `asDTO` → `NoteDTO`
- `init(fromDTO:)` / `update(fromDTO:)`

## `NoteDTO`

Struct for create / edit. Apply to the context on Save or Delete.

| Property | Type | Default |
| -------- | ---- | ------- |
| `noteId` | `String` | New UUID |
| `updated` | `Date` | `Date()` |
| `sortOrder` | `Int` | `-1` |
| `title` | `String` | `""` |
| `text` | `String` | `""` |
| `noteColor` | `NoteColor` | `.yellow` |

- `asModel` → `NoteModel`
- `init(fromModel:)`

## `DataStore`

### Setup

- `modelContainer(inMemoryOnly:)` — versioned schema + migration plan

### CRUD

- `save(context:)`
- `createNote(from:context:)`
- `updateNote(from:context:)` — throws if note missing
- `deleteNote(byNoteId:context:)` — throws if note missing

### Sort

- `resortModels(byCleanUp:context:)` — full board reorder + save
- `resortNote(atNoteId:to:context:)` — remove → insert → reindex + save

**Semantics:** Cleanup replaces global order. Color filter on the board does not change `sortOrder`. Within a cleanup pass, previous `sortOrder` is only a tiebreaker.

### Fetch

- `fetchNoteCount(from:)`
- `fetchNotes(from:)`
- `fetchNote(byNoteId:context:)` → `NoteModel?`

## UserDefaults

| Key | Type | Values |
| --- | ---- | ------ |
| `defaultViewType` | `String` | `ViewType.rawValue` (`list` / `compact` / `grid`) |

Owned by `ContentVM`; defaults to `.list` when unset / unknown.
