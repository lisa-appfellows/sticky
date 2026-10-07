# SwiftData Repository

## Methods

- `createNote(from dto: NoteDTO, context: ModelContext)`
- `updateNote(from dto: NoteDTO, context: ModelContext)`
- `resort(cleanUp option: CleanUpOption)`
- `resort(model: NotesModel, to index: Int)`
- `deleteNote(for id: String)`
- `save(context: ModelContext) throws`
  - use logging and `rollback` changes for errors
  - show banner on failed saves for either delete or save (not in scope, handled via view model)

## Not in Scope

- Fetching: the ContentView should pass down a predicate to NotesListView for either color filter or searching.

