# Data Types

Domain enums stay UI-free where possible; presentation (titles, colors, fonts) lives in `+UI` / Presentation.

## `ViewType`

Layout mode for the board. UI labels are list / compact / grid — not small / medium / large.

- `rawValue`: `String` (persisted in UserDefaults)
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
- `sortPriority`: `Int` (cleanup-by-color)
- Presentation: `title`, `color` (`Color` from asset catalog)

| Case | Hex (approx) | Light opacity | Dark opacity | Sort priority |
| ---- | ------------ | ------------- | ------------ | ------------- |
| `blue` | `#02E4F6` | ~35% | 100% | 0 |
| `green` | `#32F206` | ~35% | 100% | 1 |
| `yellow` | `#E2F008` | ~35% | 100% | 2 |
| `pink` | `#EE08CD` | ~35% | 100% | 3 |
| `purple` | `#8606F4` | ~35% | 100% | 4 |

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

## `CleanUpOption`

- `rawValue`: `String`
- `title`: localized via `LocalKey` (not `rawValue.capitalized`)

| Case | Sorts by |
| ---- | -------- |
| `newest` | `updatedString` (newest first) |
| `oldest` | `updatedString` (oldest first) |
| `name` | `title ?? text` (localized compare); undated/unnamed last; ties → `sortOrder` |
| `color` | `NoteColor.sortPriority`; unknown/nil color last; ties → `sortOrder` |

Each cleanup pass is a **new primary sort** and rewrites dense `sortOrder`. Prior order is only a secondary key inside that pass.
