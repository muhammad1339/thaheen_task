import 'package:thaheen_task/core/domain/errors/result.dart';
import 'package:thaheen_task/features/progress/domain/entity/lesson_progress_entity.dart';
import 'package:thaheen_task/features/progress/domain/repository/progress_repository.dart';

/// Progress storage kept in memory, seeded with [initial] records.
class InMemoryProgressRepository implements ProgressRepository {
  InMemoryProgressRepository([List<LessonProgressEntity> initial = const []])
    : _records = {for (final record in initial) record.lessonId: record};

  final Map<String, LessonProgressEntity> _records;

  @override
  Future<Result<List<LessonProgressEntity>>> getAllProgress() async =>
      Success(_records.values.toList());

  @override
  Future<Result<void>> saveProgress(LessonProgressEntity progress) async {
    _records[progress.lessonId] = progress;
    return const Success(null);
  }
}
