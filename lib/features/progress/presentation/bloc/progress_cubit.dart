import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:thaheen_task/core/domain/errors/result.dart';
import 'package:thaheen_task/features/progress/domain/entity/lesson_progress_entity.dart';
import 'package:thaheen_task/features/progress/domain/repository/progress_repository.dart';
import 'package:thaheen_task/features/progress/presentation/bloc/progress_state.dart';
export 'package:thaheen_task/features/progress/presentation/bloc/progress_state.dart';

class ProgressCubit extends Cubit<ProgressState> {
  ProgressCubit(this.repository) : super(ProgressState());
  final ProgressRepository repository;
  final Map<String, int> _revisions = {};
  Future<void> _queue = Future.value();
  Future<void> load() async {
    emit(
      ProgressState(
        progressByLessonId: state.progressByLessonId,
        loading: true,
        pending: state.pending,
      ),
    );
    final result = await repository.getAllProgress();
    if (isClosed) return;
    switch (result) {
      case Success<List<LessonProgressEntity>>(:final value):
        emit(
          ProgressState(
            loaded: true,
            progressByLessonId: {
              for (final p in value) p.lessonId: p,
              ...{
                for (final id in state.pending)
                  id: state.progressByLessonId[id]!,
              },
            },
            pending: state.pending,
          ),
        );
      case FailureResult<List<LessonProgressEntity>>(:final failure):
        emit(
          ProgressState(
            progressByLessonId: state.progressByLessonId,
            pending: state.pending,
            failure: failure,
          ),
        );
    }
  }

  Future<void> record(LessonProgressEntity value) {
    final id = value.lessonId;
    final revision = (_revisions[id] ?? 0) + 1;
    _revisions[id] = revision;
    final merged = LessonProgressEntity(
      lessonId: id,
      position: value.position,
      isCompleted:
          value.isCompleted ||
          (state.progressByLessonId[id]?.isCompleted ?? false),
    );
    emit(
      ProgressState(
        loaded: state.loaded,
        progressByLessonId: {...state.progressByLessonId, id: merged},
        pending: {...state.pending, id},
        failure: state.failure,
      ),
    );
    return _queue = _queue.then((_) async {
      final result = await repository.saveProgress(merged);
      if (isClosed || _revisions[id] != revision) return;
      final pending = {...state.pending};
      if (result is Success<void>) pending.remove(id);
      emit(
        ProgressState(
          loaded: state.loaded,
          progressByLessonId: state.progressByLessonId,
          pending: pending,
          failure: result is FailureResult<void>
              ? result.failure
              : (pending.isEmpty ? null : state.failure),
        ),
      );
    });
  }

  Future<void> retryPending() async {
    for (final id in state.pending.toList()) {
      await record(state.progressByLessonId[id]!);
    }
  }

  @override
  Future<void> close() async {
    await _queue;
    await super.close();
  }
}
