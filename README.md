# Three Column Method (iOS)

A SwiftUI port of the Android "Three Column Method" app, based on David Burns'
*Feeling Good: The New Mood Therapy*. It implements the Three-Column Technique
(automatic thought → cognitive distortion → rational response) plus a
single-topic Journal, mirroring the Android app's features and behavior:

- **Thought Records** — list, read-only detail view, and an editor with a
  situation field, an automatic-thought entry, belief-before/after sliders,
  tappable cognitive-distortion chips (with descriptions shown once selected),
  and a rational-response entry. Records can be shared as plain text.
- **Journal** — a single-topic notebook seeded with a starting page on first
  launch. Pages can be added, edited, deleted, shared as text, and reordered
  by dragging (via the list's native Edit mode).
- **Theme** — System / Light / Dark, with an exact-hex "notebook" palette
  (paper, ink, margin-line, highlighter, etc.) matching the Android app.
- **Language** — System / English / Simplified Chinese, switchable in-app
  without restarting, via a small self-built string table (`Strings.swift`)
  rather than Xcode's String Catalog, so it mirrors the Android
  `strings.xml` / `values-zh/strings.xml` files key-for-key.
- **Data export/import** — exports all records/pages as JSON via the system
  file picker (`.fileExporter`), and imports/batch-adds from a JSON file
  (`.fileImporter`) in the same format the Android app uses.

Built with SwiftUI + SwiftData (iOS 17+), targeting a single-target Xcode
project (no external dependencies).

## ⚠️ Not compile-verified

This app was written in a Linux sandbox with no Xcode or Swift toolchain
available, so **none of this has been compiled or run**. The
`project.pbxproj` was generated programmatically (with a small Python script,
not hand-typed) to avoid UUID-collision/typo mistakes, and each Swift file
was written against well-documented, stable SwiftUI/SwiftData APIs to
minimize risk — but there may still be small mistakes (a typo, a missing
import, an API used slightly wrong) that only Xcode's compiler will catch.

**Please open the project in Xcode, try a build, and report back anything
that fails.** Also note:

- No app-icon image was provided — the `AppIcon.appiconset` only has the
  `Contents.json` describing a single 1024×1024 universal slot; add an actual
  PNG there (or Xcode will warn about a missing app icon on archive).
- Deployment target is iOS 17.0 (required by SwiftData's `@Model` macro).

## Project layout

```
ThreeColumnMethod/
  ThreeColumnMethodApp.swift   – app entry point, SwiftData container, seed data
  RootView.swift               – TabView (Thought Records / Journal), theme/palette wiring
  Models/                      – SwiftData models + JSON import/export
  Localization/                – AppLanguage, LocalizationManager, Strings (EN/ZH table)
  Theme/                       – NotebookPalette (light/dark), ThemeManager
  Views/
    ThoughtRecords/            – list, read-only detail, editor
    Journal/                   – list (drag-to-reorder), entry editor
    About/                     – about screen, theme/language pickers, data import/export
    Shared/                    – FlowLayout (wrapping chip layout)
```
