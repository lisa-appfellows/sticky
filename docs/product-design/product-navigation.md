# Navigation

One page. Sheets for create and edit — no secondary destinations in V1.

## Top toolbar

| Item | Placement | Symbol | Presentation |
| ---- | --------- | ------ | ------------ |
| Brand (“Sticky”) | leading | — (serif text) | — |
| Create note | trailing | `plus` | Sheet (`noteEditorSheet`) |

## Bottom toolbar

| Item | Placement | Symbol | Presentation |
| ---- | --------- | ------ | ------------ |
| View type | leading | `ViewType.iconName` | Menu |
| Sort | trailing | `arrow.up.arrow.down` | Menu (`SortOptionMenu`) |

## Note → editor

| Open | Option A | Option B | Decision |
| ---- | -------- | -------- | -------- |
| Editing | Editable in place on the board / widget | Tap note → sheet | A ☐ · **B ☑** |

Create uses the same sheet with an empty DTO (optional seed color from the current filter); delete is only offered when editing an existing note.
