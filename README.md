# Sticky

A pin board for sticky notes — one page, sheet for create and edit, SwiftData under the board.

V1 is a complete sticky loop on portrait iPhone: create, edit, delete, color filter, display sort, and three board densities (list / compact / grid). Light and dark use asset-catalog paper colors with black ink.

## Requirements

- Xcode 15.2+ (or newer with iOS 17.2 SDK)
- iOS 17.2+
- Portrait iPhone (landscape / iPad planned for V2)

## Open & run

1. Open `Sticky/Sticky.xcodeproj`
2. Select the **Sticky** scheme and an iPhone simulator or device
3. Run (⌘R)

Unit tests: **Product → Test** (⌘U), or:

```bash
cd Sticky
xcodebuild test -scheme Sticky -destination 'platform=iOS Simulator,name=iPhone 15 Pro'
```

## What’s in V1

| Area | Behavior |
| ---- | -------- |
| Board | Lazy grid / list of notes; tap opens editor sheet |
| Editor | Title (45) + body (450), color swatches, save / delete |
| Filter | Color pills (display-only; does not rewrite note data) |
| Sort | Newest / oldest / name (display-only; default newest) |
| Layout | List, compact, grid via `ViewType` |
| Locale | English and Spanish |
| Accessibility | Contrast, VoiceOver labels, Reduce Motion, card ellipsis; larger reading via ViewType |

## Project layout

```
Sticky/
  Sticky/                 App target (feature folders)
    Content/              Shell, prefs, color filter, sheet host
    NoteBoard/            Board + empty state
    NoteCard/             Card view + layout
    NoteEditor/           Create / edit sheet
    DataStore/            SwiftData model, DTO, CRUD
    Shared/               Colors, fonts, localization keys, enums
    Sizing/               Screen size environment
  StickyTests/            Unit tests
docs/
  product-design/         Specs (roadmap, views, types, store)
  design-strategies/      V2+ notes (drag reorder, widgets, sizing)
```

## Docs

- [Product design](docs/product-design/index.md) — scope, navigation, views, data types, store
- [Version roadmap](docs/product-design/product-version-roadmap.md) — V1–V4 and what’s deferred
- [Design strategies](docs/design-strategies/index.md) — sizing, grid reorder, widget sharing

## Roadmap (short)

| Version | Focus |
| ------- | ----- |
| **V1** | Core loop (current) |
| **V2** | Drag reorder; iPad + landscape |
| **V3** | Home Screen widget |
| **V4** | Possible iCloud sync |

Cuts are intentional — see the [roadmap](docs/product-design/product-version-roadmap.md) for the full deferral list.
