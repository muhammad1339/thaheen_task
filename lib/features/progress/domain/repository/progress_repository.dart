import 'package:thaheen_task/core/domain/errors/result.dart';
import 'package:thaheen_task/features/progress/domain/entity/lesson_progress_entity.dart';

abstract interface class ProgressRepository {
  Future<Result<List<LessonProgressEntity>>> getAllProgress();
  Future<Result<void>> saveProgress(LessonProgressEntity progress);
}
