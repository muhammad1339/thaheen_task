import 'package:thaheen_task/features/progress/domain/entity/lesson_progress_entity.dart';

abstract final class ProgressRules {
  static bool shouldComplete({
    required Duration position,
    required Duration duration,
  }) =>
      duration.inMilliseconds > 0 &&
      position.inMilliseconds >= 0 &&
      position.inMilliseconds / duration.inMilliseconds >= .90;

  /// Playback has started but the lesson is not completed yet.
  static bool isUnfinished(LessonProgressEntity? progress) =>
      progress != null &&
      progress.position > Duration.zero &&
      !progress.isCompleted;
  static bool isUnlocked({
    required int lessonIndex,
    required List<String> orderedLessonIds,
    required Set<String> completedLessonIds,
  }) =>
      lessonIndex >= 0 &&
      lessonIndex < orderedLessonIds.length &&
      (lessonIndex == 0 ||
          completedLessonIds.contains(orderedLessonIds[lessonIndex - 1]));

  /// [isUnlocked] for a lesson by ID; a lesson not in the list is locked.
  static bool isLessonUnlocked({
    required String lessonId,
    required List<String> orderedLessonIds,
    required Set<String> completedLessonIds,
  }) => isUnlocked(
    lessonIndex: orderedLessonIds.indexOf(lessonId),
    orderedLessonIds: orderedLessonIds,
    completedLessonIds: completedLessonIds,
  );

  static double calculateCourseProgress({
    required int completedLessons,
    required int totalLessons,
  }) => totalLessons <= 0
      ? 0
      : completedLessons.clamp(0, totalLessons) / totalLessons;
}
