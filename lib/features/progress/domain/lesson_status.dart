import 'package:thaheen_task/features/progress/domain/entity/lesson_progress_entity.dart';
import 'package:thaheen_task/features/progress/domain/progress_rules.dart';

/// Where the learner stands on a single lesson.
enum LessonStatus {
  locked,
  completed,
  inProgress,
  notStarted;

  static LessonStatus resolve({
    required bool unlocked,
    required LessonProgressEntity? progress,
  }) {
    if (!unlocked) return locked;
    if (progress?.isCompleted ?? false) return completed;
    if (ProgressRules.isUnfinished(progress)) return inProgress;
    return notStarted;
  }
}
