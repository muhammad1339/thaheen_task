# Thaheen — Mini Offline Learning App

An Arabic-first Flutter app for learning offline. It ships with its courses and
lesson videos, so no internet or account is needed.

## What it does

- **Courses:** browse two bundled courses, search by title or instructor, and
  see each course's progress.
- **Lessons:** lessons unlock in order; a lesson opens once the previous one
  is at least 90% watched.
- **Player:** local video with play/pause, seeking, speed (1×–2×) and
  fullscreen. The playback position is saved and resumed.
- **Continue watching:** a shortcut back to the lesson you left unfinished.
- **Notes:** write and save a note for each lesson.
- **Settings:** Arabic/English and light/dark theme.

Progress, notes and settings are stored on the device and survive restarts.

## Content

`assets/data/courses.json` keeps the suggested shape unchanged
(`courses → sections → lessons`, with `durationSec` and `video` per lesson): it
already had everything the screens need. It has 2 courses × 2 sections × 2
lessons. Lesson IDs are unique across the whole catalog because progress and
notes are stored by lesson ID. The three bundled clips (all under 4 MB) are
shared by the 8 lessons, and each `durationSec` matches its clip.

## Requirements

- Flutter **3.47.5** (stable) / Dart **3.13.4**
- An Android emulator/device or an iOS simulator/device

## Run

```sh
flutter pub get
flutter gen-l10n
flutter run
```

## Build

```sh
flutter build apk --debug       # Android
flutter build ios --simulator   # iOS simulator
```

## Test

```sh
flutter analyze
flutter test
```

26 tests: 23 unit tests for the progress rules (90% completion, sequential
unlocking across sections, progress %, unfinished lesson, Continue watching)
and 3 widget tests for the course screens (course list, locked-lesson message,
empty course).

## Architecture and state management

Feature-first clean architecture: **presentation → domain ← data**.

- **Domain** is plain Dart: entities, repository contracts and the pure
  progress rules (`ProgressRules`). The rules live in one place and are shared
  by the course list, course details and the player, so they cannot drift.
- **Data** reads the bundled JSON through small hand-written models and
  stores progress, notes and settings in Hive.
- **Presentation** uses **Cubit** (flutter_bloc) everywhere: simple, explicit
  state classes with no events to maintain, and easy to test. Progress and
  settings are app-wide cubits; each screen owns its own cubits.
- Navigation uses go_router with ID-based routes; the player re-checks that a
  lesson is unlocked, so a direct link cannot skip ahead.
- Video uses video_player with Chewie for fullscreen, behind a small
  `VideoSession` abstraction so the player logic doesn't depend on the plugin.

It is deliberately small: no code generation, no extra layers where a
repository can do the job directly.

## Why Hive

Progress, notes and settings are small key-value records (`progress/<lessonId>`,
`notes/<lessonId>`, `settings/...`). Hive stores them locally with no native
setup, schema or migrations, and is fast to read at startup. SharedPreferences
would also work but is less suited to many records; sqflite/Isar would add a
schema the data doesn't need.

## Arabic and RTL

The UI is Arabic-first with RTL layout, and can switch to English. The seek
bar is intentionally kept left-to-right in both languages: time on a video
timeline conventionally runs left to right, so the thumb moves the same way
the video plays.

## States and errors

- Loading spinners while data loads.
- Empty states: no courses, no search matches, and a course with no lessons.
- Errors with Retry: invalid catalog, missing course or lesson ("not found"),
  a missing or corrupt video, and storage failures. A corrupt progress record
  is skipped instead of blocking the app.

## Trade-offs and known issues

- Notes are saved explicitly with Save; an unsaved draft is lost if the app is
  killed.
- Progress is saved every 5 seconds while playing (and on pause, seek,
  completion, background and leaving), so a hard kill can lose up to ~5 s.
- Completion is position-based: seeking past 90% completes a lesson.
- The sample videos are generic clips, and the course content is minimal.
- Tested on an Android emulator and an iPhone simulator, not on physical
  devices.

## With more time

- Widget tests for the player and notes, and an integration test for the full
  watch-and-unlock flow.
- A full accessibility pass (screen reader labels, large text, contrast).
- Autosave for note drafts.
- Real-device testing and a release build with signing.

## Time spent

Around 6–8 hours, slightly over the 4–6 hour time box because all the bonus
features were included.
