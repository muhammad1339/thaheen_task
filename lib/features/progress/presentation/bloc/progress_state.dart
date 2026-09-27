import 'package:thaheen_task/core/domain/errors/failures.dart';
import 'package:thaheen_task/features/progress/domain/entity/lesson_progress_entity.dart';

class ProgressState {
  ProgressState({
    Map<String, LessonProgressEntity> progressByLessonId = const {},
    this.loading = false,
    this.loaded = false,
    Set<String> pending = const {},
    this.failure,
  }) : progressByLessonId = Map.unmodifiable(progressByLessonId),
       pending = Set.unmodifiable(pending);
  final Map<String, LessonProgressEntity> progressByLessonId;
  final bool loading, loaded;
  final Set<String> pending;
  final Failure? failure;
  late final Set<String> completedIds = Set.unmodifiable({
    for (final p in progressByLessonId.values)
      if (p.isCompleted) p.lessonId,
  });

  @override
  String toString() =>
      'ProgressState(lessons: ${progressByLessonId.length}, '
      'completed: ${completedIds.length}, pending: $pending, '
      'loading: $loading, loaded: $loaded, failure: $failure)';
}
