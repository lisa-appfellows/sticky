# Version Roadmap

| Version | State | Features |
| ------- | ----- | -------- |
| **V1** | Active | CRUD; light + dark (asset catalogs); cleanup sorting; ViewType layouts; portrait-locked iPhone |
| **V2** | Planned | Drag / dropDestination reorder; iPad + dual orientation (iPhone stays portrait) |
| **V3** | Planned | Home Screen widget (one note, three sizes) |
| **V4** | Possible | iCloud sync |

## V1 includes

- Versioned SwiftData schema + migration plan
- Color filter (display only)
- Localized UI (en / es)
- Character limits for title/body (planned polish on editor branch)

## Explicitly not V1

| Idea | When |
| ---- | ---- |
| Drag reorder on the board | V2 — see [SwiftUI Grid Reordering](../design-strategies/swiftui-grid-reordering.md) |
| iPad / landscape | V2 |
| Widget | V3 — see [SwiftData + Widget Sharing](../design-strategies/swiftdata-widget-sharing.md) |
| Categories / tags | Later (not scheduled) |
| Search (`.searchable`) | Later (not scheduled) |
| iCloud | V4 / maybe |

## Notes for reviewers

Cuts are intentional. V1 is a complete sticky loop on one constrained surface; V2–V3 add board craft and a second surface once order and layout are stable.
