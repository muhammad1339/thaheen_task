import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:thaheen_task/core/domain/errors/result.dart';
import 'package:thaheen_task/features/notes/domain/entity/lesson_note_entity.dart';
import 'package:thaheen_task/features/notes/domain/repository/lesson_notes_repository.dart';
import 'package:thaheen_task/features/notes/presentation/bloc/lesson_notes_state.dart';
export 'package:thaheen_task/features/notes/presentation/bloc/lesson_notes_state.dart';

class LessonNotesCubit extends Cubit<LessonNotesState> {
  LessonNotesCubit(this.repository) : super(const LessonNotesState());
  final LessonNotesRepository repository;
  int _generation = 0;
  Future<void> load(String id) async {
    final generation = ++_generation;
    emit(LessonNotesState(lessonId: id, loading: true));
    final result = await repository.getNote(id);
    if (isClosed || generation != _generation) return;
    switch (result) {
      case Success<LessonNoteEntity?>(:final value):
        emit(
          LessonNotesState(
            lessonId: id,
            loaded: true,
            savedText: value?.text ?? '',
            draftText: value?.text ?? '',
          ),
        );
      case FailureResult<LessonNoteEntity?>(:final failure):
        emit(LessonNotesState(lessonId: id, failure: failure));
    }
  }

  void edit(String text) {
    if (!state.loaded) return;
    emit(
      LessonNotesState(
        lessonId: state.lessonId,
        loaded: true,
        savedText: state.savedText,
        draftText: text,
        saving: state.saving,
        failure: state.failure,
      ),
    );
  }

  Future<bool> save() async {
    if (!state.loaded || state.saving) return false;
    if (!state.dirty) return true;
    final id = state.lessonId, text = state.draftText, generation = _generation;
    emit(
      LessonNotesState(
        lessonId: id,
        loaded: true,
        savedText: state.savedText,
        draftText: text,
        saving: true,
      ),
    );
    final result = text.isEmpty
        ? await repository.deleteNote(id)
        : await repository.saveNote(LessonNoteEntity(lessonId: id, text: text));
    if (isClosed || generation != _generation) return false;
    emit(
      LessonNotesState(
        lessonId: id,
        loaded: true,
        savedText: result is Success<void> ? text : state.savedText,
        draftText: state.draftText,
        failure: result is FailureResult<void> ? result.failure : null,
        saved: result is Success<void>,
      ),
    );
    return result is Success<void> && !state.dirty;
  }

  void discard() {
    if (state.saving) return;
    emit(
      LessonNotesState(
        lessonId: state.lessonId,
        loaded: state.loaded,
        savedText: state.savedText,
        draftText: state.savedText,
      ),
    );
  }
}
