# Design Strategies

Implementation notes for harder SwiftUI / SwiftData problems. These are **not** V1 requirements unless the [product roadmap](../product-design/product-version-roadmap.md) says so.

| Doc | Topic | Relates to |
| --- | ----- | ---------- |
| [Sticky Note Sizing](sticky-note-sizing.md) | Fixed footprints, columns, ellipsis truncate | V1 board layout; fade → V2; future widget proportions |
| [SwiftUI Grid Reordering](swiftui-grid-reordering.md) | `.draggable` / `.dropDestination` | **V2** drag reorder |
| [SwiftData + Widget Sharing](swiftdata-widget-sharing.md) | App Group store, migration ownership | **V3** widget |

## How to use these

- Product *what* lives in [product design](../product-design/index.md) (V1: display sort + color filter; no persisted cleanup)
- Strategies are *how* for a specific constraint — keep them when shipping that version
- Prefer linking from the roadmap over copying constraints into the product index
