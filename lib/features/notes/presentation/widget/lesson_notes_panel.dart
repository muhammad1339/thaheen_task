import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:thaheen_task/core/design_system/spacing/thaheen_spacing.dart';
import 'package:thaheen_task/l10n/app_localizations.dart';
import 'package:thaheen_task/features/notes/presentation/bloc/lesson_notes_cubit.dart';

/// Notes editor for one lesson, with load/save state and retry.
class LessonNotesPanel extends StatelessWidget {
  const LessonNotesPanel({
    required this.notes,
    required this.controller,
    this.editingEnabled = true,
    super.key,
  });
  final LessonNotesCubit notes;
  final TextEditingController controller;
  final bool editingEnabled;

  /// Pushes cubit-driven text changes (load, discard) into the field.
  /// Runs in build so it also covers the first frame and layout switches.
  void _syncController(LessonNotesState state) {
    if (controller.text == state.draftText) return;
    controller.value = TextEditingValue(
      text: state.draftText,
      selection: TextSelection.collapsed(offset: state.draftText.length),
    );
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<LessonNotesCubit, LessonNotesState>(
        bloc: notes,
        builder: (context, state) {
          _syncController(state);
          final l = AppLocalizations.of(context);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l.notes, style: Theme.of(context).textTheme.titleLarge),
              ThaheenSpacing.gapVerticalMediumSmall,
              TextField(
                controller: controller,
                enabled: state.loaded && editingEnabled,
                minLines: 3,
                maxLines: 8,
                decoration: InputDecoration(
                  labelText: l.notes,
                  hintText: l.noteHint,
                ),
                onChanged: notes.edit,
              ),
              ThaheenSpacing.gapVerticalMediumSmall,
              if (state.loading) const LinearProgressIndicator(),
              if (state.failure != null)
                Text(state.loaded ? l.notSaved : l.error),
              if (!state.loaded && !state.loading)
                TextButton(
                  onPressed: () => notes.load(state.lessonId),
                  child: Text(l.retry),
                ),
              if (state.loaded)
                FilledButton(
                  onPressed: editingEnabled && state.dirty && !state.saving
                      ? () => notes.save()
                      : null,
                  child: Text(state.saving ? l.loading : l.save),
                ),
              if (state.saved && !state.dirty) Text(l.saved),
            ],
          );
        },
      );
}
