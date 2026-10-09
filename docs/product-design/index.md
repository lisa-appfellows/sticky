# Product Design

Sticky is a pin board for sticky notes — one page, sheet for create/edit, SwiftData under the board.

V1 ships the core loop on a portrait iPhone. Drag reorder, iPad, and widgets land later; implementation notes for those live under [design strategies](../design-strategies/index.md).

## Specs

| Doc | What’s in it |
| --- | --- |
| [Version roadmap](product-version-roadmap.md) | V1–V4 scope and what’s deferred |
| [Navigation](product-navigation.md) | Toolbars, sheet editing, one-page flow |
| [Views & environments](product-views-environments.md) | Main views, wrappers, sizing, empty states, ColorSortPicker |
| [Data types](product-data-types.md) | ViewType, NoteColor, NoteFont, CleanUpOption |
| [Data store](product-data-store.md) | NoteModel / NoteDTO, CRUD, sort, fetch, UserDefaults |

## Product rules (short)

- One page + sheets only — no multi-tab shell in V1
- Color filter is display-only; cleanup rewrites `sortOrder`
- Layout modes are list / compact / grid (not “small / medium / large” in the UI)
- Brand serif for “Sticky”; note body and controls stay system sans
