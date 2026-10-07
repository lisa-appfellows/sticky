# Sticky Design

A pin board for sticky notes with a widget for one note, available on all three sizes.

## Constraints

- Use LazyVGrid with .draggable / .dropDestination. See [SwiftUI Grid Reordering](/design-strategies/swiftui-grid-reordering.md)
- SwiftData for persistence. See [SwiftData + Widget Sharing](/design-strategies/swiftdata-widget-sharing.md)

## App Color Theme


| Color       | Meaning     |
| ----------- | ----------- |
| System Blue | Action      |
| System Red  | Destruction |


## View Nav Flow

*One page flow, sheet presentations only*

### Toolbar Navigation


| Toolbar Item | Placement                      | SF Symbol                    | Presentation |
| ------------ | ------------------------------ | ---------------------------- | ------------ |
| View Type    | topBarLeading                  | `ViewType.icon`              | Menu         |
| Create Note  | topBarTrailing (leading side)  | `plus`                       | Sheet        |
| Clean Up     | topBarTrailing (trailing side) | `arrow.up.arrow.down.square` | Menu         |




### Note Tap Navigation


| Open         | Option A                     | Option B                                | Decision    |
| ------------ | ---------------------------- | --------------------------------------- | ----------- |
| Editing Flow | Editable from board / widget | Editable on tap into sheet presentation | [ ] A [x] B |




## Content View

- Empty CTA: "Create a note to get started."
- Note sizes / display controlled by View Type on nav
- Color Filtering controlled by ColorSortPicker
- Searchable: use `.searchable`



### ColorSortPicker

- Filters board by selected color, display only (does not modify sortOrder), sortOrder applies after filtering
- Data Type: `NoteColor?`
- SegmentedPicker
- Empty CTA: "No [color] notes"


| Name                             | Option           |
| -------------------------------- | ---------------- |
| All                              | `nil`            |
| `NoteColor.rawValue.capitalized` | `NoteColor.case` |




## NotesListView

- handles fetching via injected predicate from ContentView
- changes for both color filtering via `ColorPicker` and searching via `.searchable`
- also handles size changes via injected `ViewType`



## StickyNote

- Tap on note leads to editing. Editing contains delete with confirmation.
- Color selected on Create / Edit from `NoteColor`
- Size is a container property(`NoteSize` from `ViewType`); fonts relative to size (`NoteFont`)
- Board points are proportional to widgets, not pixel-identical to `WidgetFamily` sizes
- Fixed height; overflow truncates inside the note (see [Sticky Note Sizing](/design-strategies/sticky-note-sizing.md))



## Data Types



### ViewType

- `rawValue`: String
- `iconName`: String

  | Case      | SF Symbol             | NoteSize |
  | --------- | --------------------- | -------- |
  | `list`    | `list.bullet`         | `large`  |
  | `compact` | `rectangle.split.2x1` | `medium` |
  | `grid`    | `square.grid.2x2`     | `small`  |




### NoteSize


| Case     | Board layout (2-col)   | Aspect intent      | Widget         |
| -------- | ---------------------- | ------------------ | -------------- |
| `small`  | 1 column × square cell | ~1:1               | `systemSmall`  |
| `medium` | full width × short     | ~2:1               | `systemMedium` |
| `large`  | full width × tall      | ~1:1 at full width | `systemLarge`  |




### NoteColor

- `rawValue`: String
- `sortPriority`: Int
- `color`: Color

  | Case     | Light Mode | Dark Mode | Sort Priority (ascending) |
  | -------- | ---------- | --------- | ------------------------- |
  | `blue`   | #d4f8ff    | #02e4f6   | 0                         |
  | `green`  | #cbffe3    | #32f206   | 1                         |
  | `yellow` | #fffecf    | #e2f008   | 2                         |
  | `pink`   | #ffd5e5    | #ee08cd   | 3                         |
  | `purple` | #fbd3ff    | #8606f4   | 4                         |




### NoteFont

ViewModifier

- `font`: Font


| Font          | Size |
| ------------- | ---- |
| `smallTitle`  | 16   |
| `mediumTitle` | 18   |
| `largeTitle`  | 24   |
| `smallText`   | 14   |
| `mediumText`  | 16   |
| `largeText`   | 18   |




### CleanUpOption

- `rawValue`: String
- `title`: String — `rawValue.capitalized`

  | case     | Sort off of Property      |
  | -------- | ------------------------- |
  | `newest` | `updated`                 |
  | `oldest` | `updated`                 |
  | `name`   | `title ?? text ?? newest` |
  | `color`  | `noteColorName`           |


Note: `color` will sort against the `sortPriority` for colors

## UserDefaults


| Key             | Value Type | Options                         |
| --------------- | ---------- | ------------------------------- |
| defaultViewType | String     | `DefaultViewType.case.rawValue` |




## SwiftData Models

*Prefer optionals for version deprecations*

### NoteModel

- id: String = UUID().uuidString
- updated: Date?
- sortOrder: Int?
- title: String?
- text: String?
- noteColorName: String? = NoteColor.yellow.rawValue
- `asDTO` → `NoteDTO` via `init(fromModel:)`



## DTOs



### NoteDTO

*For Create/Edit*

- id: String = UUID().uuidString
- updated: Date?
- sortOrder: Int = -1
- title: String
- text: String
- noteColor: NoteColor = .yellow
- `asModel` → `NoteModel` via `init(fromDTO:)`



## Create / Edit View

*Use DTO for modifications; apply to context on Save or Delete*

- top nav: `Cancel` and `Save`
- TITLE: TextField
- TEXT: TextEditor
- NOTE COLOR: 
  - Color swatches
  - default to .yellow on create
  - horizontal row of 60x60 circles
- bottom list item: `Delete note` with `xmark.circle.fill` in red/destructive
  - only available on edit; not present on create
- on create: `sortOrder` to `nextSortIndex`
- on save: set `updated`



## Widget

- One note, all three sizes; opt-in via Widget Gallery (no auto Home Screen placement)
- Shared store via App Group; app owns migration. See [SwiftData + Widget Sharing](/design-strategies/swiftdata-widget-sharing.md)
- On tap: open app to note's sheet.
- Note selection and sizing on widget edit screens
- Empty notes cta: `Open Sticky`



## In V1 Scope

- Versioned schema with migration plan



## Not in V1 Scope

- iCloud sync
- categories (possible v2)

