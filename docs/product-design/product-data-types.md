# Data Types

Product enums live in `Shared/` and carry their own UI labels (titles, colors, icons) on the type. No separate Domain / Presentation split in V1.

## `ViewType`

Layout mode for the board. UI labels are list / compact / grid — not small / medium / large.

- `rawValue`: `String` (persisted via `DefaultsStorage.viewType`)
- `title`: `LocalizedStringResource`
- `iconName`: SF Symbol via `SystemKey`
- `noteSpacing`: `CGFloat` = `12`

| Case | Symbol | Columns | Card footprint |
| ---- | ------ | ------- | -------------- |
| `list` | `rectangle` | 1 | Full width × tall (~1:1) |
| `compact` | `rectangle.split.1x2` | 1 | Full width × short (~2:1) |
| `grid` | `square.grid.2x2` | 2 | Half width × short (~1:1) |

Sizing / fonts for cards are derived from `ViewType` (former `NoteSize` merged in). For V1 accessibility, larger Dynamic Type needs are met by switching to list / compact rather than reflowing fixed card or editor heights.

## `NoteColor`

- `rawValue`: `String`
- `sortPriority`: `Int` — on the type for future use; **not** used by V1 board sort
- `title`, `color` (`Color` from asset catalog)

| Case | Light (α ~35%) | Dark (α 100%) |
| ---- | -------------- | ------------- |
| `blue` | `#02E4F6` | `#9AEAF5` |
| `green` | `#32F206` | `#B0EF8A` |
| `yellow` | `#E2F008` | `#EDE89C` |
| `pink` | `#EE08CD` | `#F5A3D9` |
| `purple` | `#8606F4` | `#C4A0FF` |

Light mode stays soft paper washes on the canvas; dark mode uses pastel-neon full pads so black ink stays readable. Opacity and per-appearance RGB live in the colorsets.

`appSecondary` (dates, placeholders, counters on note surfaces): black @ ~30% light / ~55% dark.

## `NoteFont`

View modifier for note title/body on cards and in the editor.

| Case | Size | Role |
| ---- | ---- | ---- |
| `smallTitle` | 16 | Grid title |
| `mediumTitle` | 18 | Compact / editor title |
| `largeTitle` | 24 | List title |
| `smallText` | 14 | Grid body |
| `mediumText` | 16 | Compact / editor body |
| `largeText` | 18 | List body |

Titles use bold; body regular. Scaled relative to `.title2` / `.body`.

## `SortOption`

Display-only board order. Persisted via `DefaultsStorage.sortOption`. Default: `.newest`.

- `rawValue`: `String`
- `title`: localized via `LocalKey`

| Case | Sorts by |
| ---- | -------- |
| `newest` | `updatedString` (newest first) |
| `oldest` | `updatedString` (oldest first) |
| `name` | `title ?? text` (localized compare) |

**Rules (all cases):**

- Applied in memory by `NoteBoardLayout` after `@Query` — does **not** rewrite `sortOrder` on models
- Nil / missing primary keys sort last
- Ties → `sortOrder` (stable-ish secondary; often `-1` until V2 drag)
