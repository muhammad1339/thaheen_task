# Specification

What the app does and the exact rules it follows.

## Content

Courses are bundled in `assets/data/courses.json`; videos and thumbnails are
bundled assets. Nothing is downloaded.

```json
{
  "courses": [
    {
      "id": "anatomy-101",
      "title": "…",
      "instructor": "…",
      "thumbnail": "assets/images/anatomy.png",
      "sections": [
        {
          "id": "s1",
          "title": "…",
          "lessons": [
            { "id": "l1", "title": "…", "durationSec": 31, "video": "assets/videos/sample_1.mp4" }
          ]
        }
      ]
    }
  ]
}
```

- Every string field is required and non-empty; `durationSec` is a positive integer.
- Course IDs and lesson IDs are unique across the whole catalog (progress and
  notes are stored by lesson ID).
- An invalid catalog shows an error screen with Retry, never partial data.
- A course with no lessons opens to an empty-state message.

## Screens and routes

| Route | Screen |
|---|---|
| `/` | Redirects to `/courses` |
| `/courses` | Course list: search, Continue watching, course cards |
| `/courses/:courseId` | Course details: sections and lessons with status |
| `/courses/:courseId/lessons/:lessonId` | Lesson player with notes |
| anything else | Not-found screen |

A missing course or lesson shows "not found"; other failures show a generic
error with Retry.

## Progress rules

- **Lesson order:** lessons are ordered by section, then by position in the
  section (flattened across sections).
- **Unlocking:** the first lesson is unlocked; every other lesson unlocks when
  the lesson before it is completed, including across section boundaries.
  The player enforces this too, so a direct link cannot skip ahead.
- **Completion:** a lesson completes when the playback position reaches at
  least **90%** of the video's duration (seeking counts). Zero duration or a
  negative position never completes. Completion never reverts.
- **Course progress:** completed lessons ÷ total lessons, clamped to 0–1;
  an empty course is 0. Shown as a rounded percentage.
- **Lesson status:** locked, completed, in progress (position > 0 and not
  completed), or not started.
- **Continue watching:** the first unlocked, in-progress lesson in catalog
  order. Hidden when there is none.

## Player

- Opens paused at the saved position (clamped to the video length).
- Controls: play/pause, time, seek bar, fullscreen (landscape).
- Speeds: 1×, 1.25×, 1.5×, 2×. The chosen speed is a global setting.
- Progress is saved every 5 seconds while playing, and on pause, seek,
  reaching 90%, going to the background, and leaving the lesson.
- Leaving (Back or Next lesson) first resolves unsaved notes, then saves
  progress; if that save fails, the user can retry, leave anyway, or cancel.
- Next lesson is enabled only when the next lesson is unlocked; the last
  lesson shows an end-of-course message.
- A video error shows an error with Retry, keeping the last saved position.

## Notes

- One plain-text note per lesson, saved explicitly with Save.
- Saving empty text deletes the note.
- Leaving with unsaved changes asks: Save, Discard, or Cancel.

## Search

Matches course title or instructor, case-insensitive, ignoring surrounding
spaces. No catalog and no matches have separate empty messages.

## Settings

| Setting | Values | Default |
|---|---|---|
| Language | Arabic (RTL), English | Arabic |
| Theme | Light, Dark | Light |
| Playback speed | 1×, 1.25×, 1.5×, 2× | 1× |

Changes apply immediately. A failed save keeps the new value on screen and
offers Retry.

## Storage

One Hive box, `thaheen`:

| Key | Value |
|---|---|
| `progress/<lessonId>` | `{positionMs: int, completed: bool}` |
| `notes/<lessonId>` | note text |
| `settings/locale` | `ar` or `en` |
| `settings/themeMode` | `light` or `dark` |
| `settings/playbackSpeed` | one of the speeds |

A corrupt progress record is skipped (and overwritten by the next save)
instead of blocking the app. Storage failing at startup shows a startup error
screen with Retry.

## Layout

| Window width | Course grid | Player |
|---|---|---|
| < 600 | 1 column | Video above lesson info |
| 600–839 | 2 columns | Video above lesson info |
| 840–1199 | 3 columns | Video beside a sidebar (35% of width, 320–480) |
| ≥ 1200 | 4 columns | Same; content capped at 1200 wide |

Course details are capped at 960 wide. Resizing keeps the video and the notes
draft.
