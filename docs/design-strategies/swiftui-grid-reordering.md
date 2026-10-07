# SwiftUI Grid Reordering

## Context

`UICollectionView` has first-party interactive cell moving. SwiftUI grids (`LazyVGrid` / `LazyHGrid` / `Grid`) do not. Prefer staying in SwiftUI via `.draggable` / `.dropDestination` rather than wrapping UIKit.

`List` + `.onMove` supports reordering, but that is list-only — not a grid.

## Required data for `.draggable` / `.dropDestination`

Both sides must use the **same** `Transferable` **type** (iOS 16+ / macOS 13+).

- Prefer a small payload — typically an item **ID** (`UUID` / `String`), not the full model.
- Custom types need `Transferable` + `transferRepresentation` (e.g. `CodableRepresentation`).
- Built-ins also work when appropriate: `String`, `Data`, `URL`, etc.
- Mismatched types → drops fail silently.

SwiftUI does **not** supply “move from index 3 → 7.” You own:


| Piece                 | Role                      |
| --------------------- | ------------------------- |
| Stable IDs            | Identify what was dragged |
| Source-of-truth array | Mutate order in the model |
| Drop targeting        | Decide where it landed    |
| Optional `isTargeted` | Highlight drop targets    |




## Mapping drop location → index (3-column, variable-row grid)

Do **not** use `index = row * 3 + col` arithmetic. Variable row heights, spacing, padding, and scrolling make it unreliable.

### Preferred: per-cell destinations

Put `.dropDestination` on each cell. The target index is already known; ignore `location`.

### Alternative: container drop + frames

If dropping on the container (e.g. empty trailing space):

1. Named coordinate space on the grid.
2. Each cell publishes its frame via `PreferenceKey` + `GeometryReader`.
3. On drop, find which `CGRect` contains `location` → that cell’s index.

`location` is in the destination view’s coordinates — keep frames and the drop destination in the same space.

## Animations

Not required for correctness.

- Free: system drag preview; grid jumps when the array updates.
- Recommended: wrap the reorder mutation in `withAnimation` so cells ease into place on drop.
- Stable `ForEach` IDs are what make that animation land on the right views.
- Not free (unlike `UICollectionView`): live gap-opening while dragging. That needs custom `isTargeted` / placeholder work; most apps animate only the snap on drop.

