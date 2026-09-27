import 'package:hive_flutter/hive_flutter.dart';

import 'package:thaheen_task/core/domain/errors/result.dart';
import 'package:thaheen_task/core/domain/errors/failures.dart';
import 'package:thaheen_task/features/progress/domain/entity/lesson_progress_entity.dart';
import 'package:thaheen_task/features/progress/domain/repository/progress_repository.dart';
import 'package:thaheen_task/utils/logger/app_logger.dart';

class HiveProgressRepository implements ProgressRepository {
  HiveProgressRepository(this.box);
  final Box<dynamic> box;
  Future<void> _queue = Future.value();
  LessonProgressEntity? _read(String id) {
    final value = box.get('progress/$id');
    if (value == null) return null;
    if (value is! Map ||
        value['positionMs'] is! int ||
        value['completed'] is! bool ||
        (value['positionMs'] as int) < 0) {
      throw const FormatException();
    }
    return LessonProgressEntity(
      lessonId: id,
      position: Duration(milliseconds: value['positionMs'] as int),
      isCompleted: value['completed'] as bool,
    );
  }

  /// Like [_read], but treats a corrupt record as missing so one bad entry
  /// can't block loading or overwriting every other lesson's progress.
  LessonProgressEntity? _readOrSkipCorrupt(String id) {
    try {
      return _read(id);
    } on FormatException {
      AppLogger.w(
        'Skipping corrupt progress record for lesson $id',
        tag: 'ProgressRepository',
      );
      return null;
    }
  }

  @override
  Future<Result<List<LessonProgressEntity>>> getAllProgress() async {
    try {
      return Success([
        for (final key in box.keys.whereType<String>())
          if (key.startsWith('progress/'))
            ?_readOrSkipCorrupt(key.substring('progress/'.length)),
      ]);
    } catch (_) {
      return const FailureResult(Failure(FailureType.storage));
    }
  }

  @override
  Future<Result<void>> saveProgress(LessonProgressEntity progress) {
    final job = _queue.then((_) async {
      try {
        final previous = _readOrSkipCorrupt(progress.lessonId);
        await box.put('progress/${progress.lessonId}', {
          'positionMs': progress.position.inMilliseconds.clamp(0, 1 << 53),
          'completed': progress.isCompleted || (previous?.isCompleted ?? false),
        });
        await box.flush();
        return const Success<void>(null);
      } catch (_) {
        return const FailureResult<void>(Failure(FailureType.storage));
      }
    });
    _queue = job.then((_) {});
    return job;
  }
}
