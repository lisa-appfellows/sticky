# Views & Environments

## App chrome

| Color | Meaning |
| ----- | ------- |
| Primary / black text on notes | Actions & note ink |
| `appBackground` (light white / dark black) | Canvas & toolbars |
| System red | Destructive (delete) |

No system-blue tint on board chrome — menus and Save/Cancel stay plain.

## Main views

### `ContentView`

- Top nav (brand + create), `ColorSortPicker`, `NoteBoardView`, `BottomToolbar`
- Owns `ContentVM` (view type, color filter / predicate, sort option)
- `NoteBoardView` is `.id(colorFilter)` so `@Query` rebuilds when the filter changes

### `NoteBoardView`

- `@Query` filtered by `ContentVM.predicate`, sorted by `sortOrder` (secondary / future drag)
- Display order: `NoteBoardVM.sorted(_:by:)` using `ContentVM.sortOption`
- `LazyVGrid` columns from `ViewType` (1 column list/compact, 2 column grid)
- Renders `NoteCardView` via `noteEditorSheet`

### `NoteBoardVM`

- Column count, horizontal padding, card width math
- In-memory sort for `SortOption` (newest / oldest / name)

### `NoteCardView`

- Shows title, text, updated line
- Tap → edit sheet
- Footprint from `ViewType` + available width (`ScreenSizeKey`)

| ViewType | Footprint |
| -------- | --------- |
| `list` | Full width × tall (~1:1) |
| `compact` | Full width × short (~2:1) |
| `grid` | Half width × short (~1:1 cell) |

Fixed height; overflow truncates. Board proportions stay related to future widgets — not pixel-identical. See [Sticky Note Sizing](../design-strategies/sticky-note-sizing.md).

### `NoteEditorView`

- Create and edit share one sheet; work on a `NoteDTO`, apply on Save / Delete
- Top: Cancel / Save (plain; Save semibold)
- Color swatches (rounded rects, checkmark on selection; default `.yellow` on create, or seed from board filter)
- `TitleField` (limit 45) + `BodyEditor` (limit 450)
- Updated / created date line
- Delete only when editing (not on create)
- Save / delete failures → system alert (Retry / Cancel)

## Color filter — `ColorSortPicker`

- Horizontal pill strip: **All** (`nil`) + each `NoteColor`
- Filters the board only — does **not** change persisted note data or `sortOrder`
- Sort mode still applies to whatever the filter shows
- Selection scrolls into view (`ScrollViewReader` / `scrollTo`); scroll does not change the filter
- Empty (filtered) CTA: “No [color] notes”

## Sort — `SortOptionMenu`

- Bottom-trailing menu: Newest / Oldest / Name
- Display-only; persisted preference via `DefaultsStorage.sortOption`
- Default: Newest

## Empty states

| State | CTA |
| ----- | --- |
| No notes | “Create a note to get started.” |
| Filter has no matches | “No [color] notes” |

## Wrappers

### `noteEditorSheet` / editor link

- Tap target + sheet presentation
- Wraps note cards; toolbar `+` opens create (optional color seed from filter)

### `SizingContainer`

- `GeometryReader` → updates `ScreenSizeKey`
- Lets the board compute available width for card sizing

## Environment

| Key | Type | Role |
| --- | ---- | ---- |
| `screenSize` | `CGSize` | Board / card width math |
