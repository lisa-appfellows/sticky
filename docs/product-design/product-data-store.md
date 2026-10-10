# Data Store

SwiftData persistence. Prefer optionals on the model where fields may deprecate across versions.

## `NoteModel`

| Property | Type | Notes |
| -------- | ---- | ----- |
| `noteId` | `String` | Default `UUID().uuidString` |
| `updatedString` | `String?` | ISO8601 |
| `sortOrder` | `Int?` | Default `-1`; unused by V1 display sort; reserved for V2 drag reorder |
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
- Edit save refreshes `updated` so newest / oldest stay meaningful

## `DataStore`

CRUD + fetch only. Board order is **not** persisted here — see `NoteBoardVM` + `SortOption`.

### Setup

- `modelContainer(inMemoryOnly:)` — versioned schema + migration plan

### CRUD

- `save(context:)`
- `createNote(from:context:)`
- `updateNote(from:context:)` — throws if note missing
- `deleteNote(byNoteId:context:)` — throws if note missing

### Fetch

- `fetchNoteCount(from:)`
- `fetchNotes(from:)`
- `fetchNote(byNoteId:context:)` → `NoteModel?`

## `DefaultsStorage`

UserDefaults keys owned by `ContentVM`. Pattern: `defaults_<case>`.

| Case | Key | Values | Default when unset |
| ---- | --- | ------ | ------------------ |
| `noteColor` | `defaults_noteColor` | `NoteColor.rawValue` or removed for All | All (`nil`) |
| `sortOption` | `defaults_sortOption` | `newest` / `oldest` / `name` | `.newest` |
| `viewType` | `defaults_viewType` | `list` / `compact` / `grid` | `.list` |
