import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:thaheen_task/core/design_system/spacing/thaheen_spacing.dart';
import 'package:thaheen_task/core/design_system/widgets/feedback/thaheen_retry_notice.dart';
import 'package:thaheen_task/features/notes/presentation/bloc/lesson_notes_cubit.dart';
import 'package:thaheen_task/features/notes/presentation/widget/lesson_notes_panel.dart';
import 'package:thaheen_task/features/player/presentation/bloc/player_cubit.dart';
import 'package:thaheen_task/features/player/presentation/widget/playback_speed_selector.dart';
import 'package:thaheen_task/features/progress/domain/entity/lesson_progress_entity.dart';
import 'package:thaheen_task/features/progress/domain/lesson_status.dart';
import 'package:thaheen_task/features/progress/presentation/bloc/progress_cubit.dart';
import 'package:thaheen_task/features/progress/presentation/widget/lesson_status_display.dart';
import 'package:thaheen_task/l10n/app_localizations.dart';

/// Everything beside or below the video: title, status, speed, notes and the
/// next-lesson action.
class LessonInfoPanel extends StatelessWidget {
  const LessonInfoPanel({
    required this.state,
    required this.player,
    required this.notes,
    required this.notesController,
    required this.editingEnabled,
    required this.onNextLesson,
    super.key,
  });

  final PlayerState state;
  final PlayerCubit player;
  final LessonNotesCubit notes;
  final TextEditingController notesController;
  final bool editingEnabled;
  final VoidCallback onNextLesson;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lesson = state.lesson!;
    final completed = context.select<ProgressCubit, bool>(
      (progress) => progress.state.completedIds.contains(lesson.id),
    );
    final status = LessonStatus.resolve(
      unlocked: true,
      progress: LessonProgressEntity(
        lessonId: lesson.id,
        position: state.position,
        isCompleted: completed,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(lesson.title, style: Theme.of(context).textTheme.headlineSmall),
        ThaheenSpacing.gapVerticalMediumSmall,
        Text(status.label(l)),
        ThaheenSpacing.gapVerticalMediumSmall,
        PlaybackSpeedSelector(
          selected: state.speed,
          onSelected: player.setSpeed,
        ),
        if (state.saveFailed) ThaheenRetryNotice(onRetry: player.flush),
        ThaheenSpacing.gapVerticalLarge,
        LessonNotesPanel(
          notes: notes,
          controller: notesController,
          editingEnabled: editingEnabled,
        ),
        ThaheenSpacing.gapVerticalLarge,
        if (state.nextLessonId == null)
          Text(l.courseEnd)
        else
          FilledButton.icon(
            onPressed: state.nextUnlocked ? onNextLesson : null,
            icon: const Icon(Icons.skip_next),
            label: Text(l.nextLesson),
          ),
      ],
    );
  }
}
