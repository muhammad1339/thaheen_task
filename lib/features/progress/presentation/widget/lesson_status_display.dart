import 'package:flutter/material.dart';

import 'package:thaheen_task/l10n/app_localizations.dart';
import 'package:thaheen_task/features/progress/domain/lesson_status.dart';

extension LessonStatusDisplay on LessonStatus {
  IconData get icon => switch (this) {
    LessonStatus.locked => Icons.lock_outline,
    LessonStatus.completed => Icons.check_circle_outline,
    LessonStatus.inProgress ||
    LessonStatus.notStarted => Icons.play_circle_outline,
  };

  String label(AppLocalizations l) => switch (this) {
    LessonStatus.locked => l.locked,
    LessonStatus.completed => l.completed,
    LessonStatus.inProgress => l.inProgress,
    LessonStatus.notStarted => l.notStarted,
  };
}
