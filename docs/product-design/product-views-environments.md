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
- Owns `ContentVM` (view type, color filter, sort option) and editor sheet item
- Passes `colorFilter` into `NoteBoardView` so `@Query` rebuilds when the filter changes

### `NoteBoardView`

- `@Query` built from `colorFilter` init param; Query sort on `sortOrder` (secondary / future drag)
- Display order: `NoteBoardLayout.sorted(_:by:)` using `ContentVM.sortOption`
- Empty board → `EmptyNotesView` (filter-aware title + create CTA)
- Otherwise `LazyVGrid` columns from `ViewType` (1 column list/compact, 2 column grid)
- Card tap / empty CTA / toolbar `+` set `NoteEditorSheet` on `ContentView`

### `NoteBoardLayout`

- Column count, horizontal padding, card width math
- In-memory sort for `SortOption` (newest / oldest / name)

### `NoteCardView` / `NoteCardLayout`

- Shows title, text, updated line
- Tap → edit sheet
- Footprint from `ViewType` + available width (`ScreenSizeKey`)
- Card is its own button (`editorSheet` binding); VoiceOver: one label (title/body/color/date) + edit hint
- Label composition lives on `NoteCardLayout.accessibilityLabel(locale:)` (unit-tested)

| ViewType | Footprint |
| -------- | --------- |
| `list` | Full width × tall (~1:1) |
| `compact` | Full width × short (~2:1) |
| `grid` | Half width × short (~1:1 cell) |

Fixed height; overflow uses `lineLimit` + ellipsis (fade deferred to V2). Board proportions stay related to future widgets — not pixel-identical. See [Sticky Note Sizing](../design-strategies/sticky-note-sizing.md).

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
- Selection scrolls into view (`ScrollViewReader` / `scrollTo`); respects Reduce Motion; scroll does not change the filter
- Empty filtered board uses color-specific title (see Empty states)
- VoiceOver: color name + selected state; filter hint on the strip

## Accessibility (V1)

Pass complete for soak. Intentional leans:

| Area | V1 choice |
| ---- | --------- |
| Contrast | Dark pink/purple pastel pads + black ink; `appSecondary` ~55% dark; filter selection without muddy unselected opacity |
| Overflow | Card title/body `lineLimit` + ellipsis (fade → V2) |
| Motion | Filter `scrollTo` gated on Reduce Motion |
| Dynamic Type | Fixed card/editor footprints; larger reading via `ViewType` (list / compact) |
| VoiceOver | Cards, filter pills, color swatches, empty CTA, sort/view menus — string labels where composite `Text` failed |
| Tests | `NoteCardLayout` accessibility label builders (not a11y key catalogs) |

## Sort — `SortOptionMenu`

- Bottom-trailing menu: Newest / Oldest / Name
- Display-only; persisted preference via `DefaultsStorage.sortOption`
- Default: Newest

## Empty states — `EmptyNotesView`

`ContentUnavailableView` with title, shared message, and create action (sheet seeded from current filter color when set).

| State | Title | Message | Action |
| ----- | ----- | ------- | ------ |
| All / no notes | “No Notes” | “Create a note to get started.” | “Create Note” (outlined) |
| Filter has no matches | “No [color] Notes” | same | “Create Note” (filled with filter color) |

Localized `en` / `es` via `LocalKey.emptyNotesTitle`, `emptyColorNotesTitle(for:)`, `emptyNotesMessage`, `createNote`. Shared “get started” message is intentional for color filters too (getting started in that color).

## Wrappers

### `noteEditorSheet(item:)`

- `ContentView` owns `@State` sheet item and presents via `.noteEditorSheet(item:)`
- Call sites assign `.new(color?)` or `.existing(dto)` — no Button wrapper on cards

### `SizingContainer`

- `GeometryReader` → updates `ScreenSizeKey`
- Lets the board compute available width for card sizing

## Environment

| Key | Type | Role |
| --- | ---- | ---- |
| `screenSize` | `CGSize` | Board / card width math |
