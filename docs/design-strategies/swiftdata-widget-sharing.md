# SwiftData + Widget Sharing

## Context

The Sticky widget needs to show one note from the same store the app writes. A Widget Extension is a **separate process** with its own sandbox — it cannot see the app’s default SwiftData store.

Two concerns that are easy to conflate:


| Phrase                 | Means                                                                                                                                         |
| ---------------------- | --------------------------------------------------------------------------------------------------------------------------------------------- |
| **App owns migration** | At **runtime**, the main app process opens the store with the `SchemaMigrationPlan` and upgrades the DB. The widget does not drive migration. |
| **Shared models**      | At **build time**, both targets compile the same `@Model` sources. Not about which process “owns” the files.                                  |


“Owned by the app” is **not** a requirement that model files live at the project root.

## Put the store in an App Group from day one

Enable the same App Group on the app target now (and on the Widget Extension when it exists). Point SwiftData at that group:

```swift
let config = ModelConfiguration(
    "Sticky",
    schema: Schema([StickyNote.self]),
    groupContainer: .identifier("group.your.bundle.sticky")
)
let container = try ModelContainer(for: StickyNote.self, configurations: config)
```

Starting with the default (app-private) store and moving later means copying data into the group container yourself. Prefer landing in the App Group before shipping data users care about.

## Share model sources without a package

A Swift package is optional for this project size. Prefer a shared folder + dual **Target Membership**:

```
Sticky/
  Sticky/                 ← app sources, app entry
  StickyWidget/           ← widget sources (later)
  Shared/                 ← models + store setup both targets use
    StickyNote.swift
    StickyModelContainer.swift
```

`Shared/` can sit next to the app folder or under it — location is taste. What matters:

1. Select the shared file in Xcode.
2. File inspector → **Target Membership** → check **Sticky** and (later) **StickyWidget**.
3. Do **not** duplicate model files into the widget folder.

Both targets compile the same types → one schema, one store URL.

Use a package only if shared surface area grows (more extensions, separate test consumer, etc.).

## App owns migration; widget only reads

Shared helper pattern:

```swift
// Shared/StickyModelContainer.swift
enum StickyStore {
    static let appGroupID = "group.your.bundle.sticky"

    static func makeContainer(migrating: Bool) throws -> ModelContainer {
        let schema = Schema([StickyNote.self])
        let config = ModelConfiguration(
            schema: schema,
            groupContainer: .identifier(appGroupID)
        )
        if migrating {
            return try ModelContainer(
                for: schema,
                migrationPlan: StickyMigrationPlan.self,
                configurations: config
            )
        } else {
            return try ModelContainer(for: schema, configurations: config)
        }
    }
}
```


| Target   | Call                              | Role                                                                       |
| -------- | --------------------------------- | -------------------------------------------------------------------------- |
| Main app | `makeContainer(migrating: true)`  | Opens store, runs migration plan                                           |
| Widget   | `makeContainer(migrating: false)` | Reads after the app has prepared the store; on failure, show “Open Sticky” |




## Keep the schema widget-friendly

For a “one note” widget:

- **Stable identity** — persistent `UUID` on the note (not array index) for config / timeline lookups.
- **Clear “widget note” rule** — e.g. `isPinnedToWidget`, or “most recently edited,” decided in the app and written to the shared store.
- **Lean display fields** on the model (text, color, etc.) — widgets have tight memory and time budgets.
- **Versioned schema + migration plan** live with the shared models; only the **app** runs the plan.



## Refresh after writes

The shared store alone does not update the Home Screen. After saves that affect the widget note, call:

`WidgetCenter.shared.reloadTimelines(ofKind:)`

## Checklist before adding the Widget Extension


| Do now                                                     | Why                                   |
| ---------------------------------------------------------- | ------------------------------------- |
| App Group + `groupContainer` on `ModelConfiguration`       | Widget can open the same DB           |
| Shared `@Model` (+ container helper) via target membership | One schema for app + extension        |
| Explicit note ID + “which note is on the widget”           | Widget fetches one row cheaply        |
| Versioned schema; migration only from the app              | Extension won’t fight schema upgrades |
| Lean note payload for glance UI                            | Fits widget runtime limits            |


When the extension lands: same `ModelConfiguration`, fetch one note, render the three families (`.systemSmall` / `.systemMedium` / `.systemLarge`). Home Screen placement stays user opt-in; skip Widget Suggestion / relevance donations unless you intentionally want Smart Stack insertion.