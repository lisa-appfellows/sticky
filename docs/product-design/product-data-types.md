# Data Types

Domain enums stay UI-free where possible; presentation (titles, colors, fonts) lives in `+UI` / Presentation.

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

Sizing / fonts for cards are derived from `ViewType` (former `NoteSize` merged in).

## `NoteColor`

- `rawValue`: `String`
- `sortPriority`: `Int` — on the type for future use; **not** used by V1 board sort
- Presentation: `title`, `color` (`Color` from asset catalog)

| Case | Hex (approx) | Light opacity | Dark opacity |
| ---- | ------------ | ------------- | ------------ |
| `blue` | `#02E4F6` | ~35% | 100% |
| `green` | `#32F206` | ~35% | 100% |
| `yellow` | `#E2F008` | ~35% | 100% |
| `pink` | `#EE08CD` | ~35% | 100% |
| `purple` | `#8606F4` | ~35% | 100% |

Light mode stays soft paper washes; dark mode uses full pads. Opacity lives in the colorsets.

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

- Applied in memory by `NoteBoardVM` after `@Query` — does **not** rewrite `sortOrder` on models
- Nil / missing primary keys sort last
- Ties → `sortOrder` (stable-ish secondary; often `-1` until V2 drag)
