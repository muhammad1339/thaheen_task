import 'package:flutter/material.dart';

import 'package:thaheen_task/features/notes/presentation/bloc/lesson_notes_cubit.dart';
import 'package:thaheen_task/l10n/app_localizations.dart';

/// Actions available when leaving a screen with unsaved notes.
enum NotesLeaveAction { cancel, discard, save }

/// Resolves unsaved notes before leaving: asks to save, discard or cancel.
///
/// Returns true when it is safe to leave (nothing unsaved, discarded, or
/// saved successfully).
Future<bool> confirmNotesLeave(
  BuildContext context,
  LessonNotesCubit notes,
) async {
  if (notes.state.saving) return false;
  if (!notes.state.dirty) return true;
  final l = AppLocalizations.of(context);
  final action = await showDialog<NotesLeaveAction>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l.unsavedNotes),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, NotesLeaveAction.cancel),
          child: Text(l.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, NotesLeaveAction.discard),
          child: Text(l.discard),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, NotesLeaveAction.save),
          child: Text(l.save),
        ),
      ],
    ),
  );
  switch (action) {
    case NotesLeaveAction.discard:
      notes.discard();
      return true;
    case NotesLeaveAction.save:
      return notes.save();
    case NotesLeaveAction.cancel:
    case null:
      return false;
  }
}
