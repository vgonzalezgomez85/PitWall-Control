# AGENTS.md

Flutter desktop app **PitWall Control** — offline manager for slot-car championships (championships, races, technical verifications, catalogs, treasury, Google Sheets sync). Multi-platform: macOS, Windows, Android. Primary dev target is macOS.

## Language

The whole codebase is **Spanish**: identifiers, comments, UI strings, commit messages, and the changelog. Write new code in Spanish to match (e.g. `pantalla_`, `repositorio_`, `editor_`, `importador_` prefixes). Do not translate existing identifiers.

## Commands

- `flutter analyze` — lint/typecheck.
- `flutter test` — run all tests. Desktop tests bypass the plugin-heavy widget tree, so most run fine headless; prefer macOS device for anything plugin-dependent.
- `dart run build_runner build --delete-conflicting-outputs` — regenerate Drift code. **Required after any change to `lib/data/database/tables.dart`.**

## Database (drift / SQLite)

- Schema lives in `lib/data/database/tables.dart` + `app_database.dart`; `app_database.g.dart` is generated. Never hand-edit the `.g.dart`.
- `schemaVersion` is currently `37`. Every schema change must bump it **and** add a step in the `onUpgrade` block using the `_aplicar()` helper — the helper swallows `duplicate column` / `already exists` errors because dev DBs can lag behind the declared `user_version`. Use `customStatement('ALTER TABLE ... ADD COLUMN ...')` for new columns, `_aplicar(() => m.createTable(...))` for new tables.
- Changes that are purely additive are safe; destructive migrations must be justified (see schema 31 dedup and 33/35 drop+re-add patterns).
- `Seeds.sembrar(db)` + `limpiarDuplicados()` run on every app start in `main.dart`; both must stay idempotent.
- Local DB files and `fotos_verificaciones/` (verification photos) are gitignored.

## Tests

- Construct an in-memory DB with `AppDatabase.forTesting(NativeDatabase.memory())` (do not touch the real DB). See `test/excel_catalogos_test.dart`.
- **`test/importador_pitwall_csv_test.dart` requires the fixture `/tmp/test1_control.csv`** (exported by the external PitWall Manager server; comment in the file explains how to generate it). It fails without it — don't panic, and don't commit a binary fixture.

## Architecture notes

- Feature-first layout: `lib/features/<modulo>/` holds screens (`pantalla_*`), repositories, and importers per feature. Global providers (`dbProvider`, active championship, dark mode) live in `lib/core/proveedores.dart`. PDF/network/Google services live in `lib/services/`.
- Riverpod v3 (legacy `AsyncNotifier`/`Notifier` APIs, not codegen).
- Google Sheets/Drive sync needs OAuth configured at runtime (Settings → Google: paste a Google Cloud Client ID + Secret); no credentials are in the repo. Google-backed features only work on desktop.
- "PitWall Manager" (local server) integration uses LAN discovery (`nsd`) + REST; `wordpress-plugin/resisbarna-sync/` is a legacy leftover from the previous Resisbarna app and should not be touched.

## Workflow conventions

- Commit messages are conventional-commit in Spanish, scoped by feature: `feat(verificaciones): ...`, `fix(catalogos): ...`, `chore: ...`.
- Every feature/fix merge **must bump `version` in `pubspec.yaml`** and add a matching `CHANGELOG.md` entry under **Añadido / Mejorado / Corregido** (rules are documented at the top of `CHANGELOG.md`). The version is shown in the app's sidebar (Material: `vX.Y.Z`).
- GPLv3 + App Store exception; every Dart file carries a license header — keep it on new files.