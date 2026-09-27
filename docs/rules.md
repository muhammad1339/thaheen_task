# Project rules

How the code is organised and written. Keep things simple: add structure only
when it removes real duplication or risk.

## Architecture

Feature-first clean architecture. Dependencies point inward:
**presentation → domain ← data**.

- **Domain** (`domain/`): entities, repository contracts and pure business
  rules. Plain Dart only — no Flutter, Hive, video player or GetIt.
- **Data** (`data/`): JSON models, mappers and repository implementations.
  Catches exceptions and returns `Result` (`Success` / `FailureResult`).
- **Presentation** (`presentation/`): cubits, screens and widgets. Talks to
  data only through domain repository contracts.
- A business rule lives in one place (e.g. `ProgressRules`) and is never
  reimplemented in widgets or cubits.

## Folders and naming

```text
lib/
  main.dart            calls thaheenApp()
  app/                 startup, composition root, router, root widget
  core/                design system, shared widgets, Result/Failure
  features/<feature>/
    data/model/        …Serializable (fromJson)
    data/mapper/       …Mapper extensions (toEntity)
    data/repository/   <Tech>…Repository (e.g. HiveProgressRepository)
    domain/entity/     …Entity
    domain/repository/ contracts (no I prefix, no Impl suffix)
    presentation/bloc/ cubits and states
    presentation/screen/ route-level screens
    presentation/widget/ feature widgets
  utils/               logger and small helpers
test/features/<feature>/domain/  unit tests mirroring lib/
```

- Folders are singular; files are `snake_case`; classes are `PascalCase`.
- App-level and design-system classes use the `Thaheen` prefix
  (`ThaheenModule`, `ThaheenTheme`, `ThaheenSpacing`, `ThaheenErrorStateView`).
- Route paths and links come from `RoutePaths`; never hand-build URLs.
- Package imports only (`package:thaheen_task/...`); relative imports inside
  `lib/` are analyzer errors.

## State and UI

- State lives in cubits with immutable state classes; application widgets do
  not call `setState`. StatefulWidgets are only for owning controllers and
  lifecycle hooks.
- Screens compose; extract UI sections into small widget classes, not
  widget-returning helper methods.
- Each screen creates and closes its own cubits; app-wide cubits (settings,
  progress) are provided once at the root.
- Give route screens a `ValueKey` of their ID when the same route can show
  different items.

## Dependencies

- GetIt is used only in the composition root (`ThaheenModule`). Everything
  else receives dependencies through constructors.
- Startup failures the user can fix by retrying throw
  `ThaheenStartupException`; anything else is treated as a bug.

## Design system and text

- Use `ThaheenSpacing`, `ThaheenSizes`, `ThaheenRadius`,
  `ThaheenResponsiveLayout` and the theme (`ThaheenColors`) — no hard-coded
  colors, sizes or spacing in features.
- Reuse shared widgets (`ThaheenErrorStateView`, `ThaheenRetryNotice`,
  `ThaheenChoiceChips`, `ThaheenCenteredContent`, …) instead of copying UI.
- All user-facing text comes from ARB localizations (Arabic and English keys
  kept in sync); layout uses directional (RTL-safe) geometry.

## Errors and logging

- Failures are `Failure(FailureType.storage | invalidData | notFound | media)`;
  show them with `failure.localizedMessage(l)`.
- Log with `AppLogger` (`d`, `i`, `w`, `e`) and a tag; never `print`.
  Logging and `BlocLogger` run in debug builds only. Never log note text.

## Code quality

- No code generation; JSON models are hand-written.
- No unused code: remove dead constants, methods and translations.
- `dart format`, `flutter analyze` (strict lints) and `flutter test` must pass.
- Unit-test pure business rules with one clearly named test per case.
