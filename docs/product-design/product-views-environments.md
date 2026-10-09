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
- Owns `ContentVM` (view type, color filter / predicate)

### `NoteBoardView`

- Builds `@Query` from the injected predicate
- `LazyVGrid` columns from `ViewType` (1 column list/compact, 2 column grid)
- Renders `NoteCardView` via `NoteEditorLink`

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
- Color swatches (rounded rects, checkmark on selection; default `.yellow` on create)
- Title `TextField`; body field (TextEditor + character limit on the next polish branch)
- Updated / created date line
- Delete only when editing (not on create)

## Color filter — `ColorSortPicker`

- Horizontal pill strip: **All** (`nil`) + each `NoteColor`
- Filters the board only — does **not** rewrite `sortOrder`; cleanup still owns order
- Selection scrolls into view (`ScrollViewReader` / `scrollTo`); scroll does not change the filter
- Empty (filtered) CTA: “No [color] notes”

## Empty states

| State | CTA |
| ----- | --- |
| No notes | “Create a note to get started.” |
| Filter has no matches | “No [color] notes” |

## Wrappers

### `NoteEditorLink`

- Tap target + sheet presentation
- Wraps note cards; `newEditor` is the toolbar `+`

### `SizingContainer`

- `GeometryReader` → updates `ScreenSizeKey`
- Lets the board compute available width for card sizing

## Environment

| Key | Type | Role |
| --- | ---- | ---- |
| `screenSize` | `CGSize` | Board / card width math |
