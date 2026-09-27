import 'package:hive_flutter/hive_flutter.dart';

import 'package:thaheen_task/core/domain/errors/result.dart';
import 'package:thaheen_task/core/domain/errors/failures.dart';
import 'package:thaheen_task/features/notes/domain/entity/lesson_note_entity.dart';
import 'package:thaheen_task/features/notes/domain/repository/lesson_notes_repository.dart';

class HiveLessonNotesRepository implements LessonNotesRepository {
  HiveLessonNotesRepository(this.box);
  final Box<dynamic> box;
  @override
  Future<Result<LessonNoteEntity?>> getNote(String id) async {
    try {
      final value = box.get('notes/$id');
      if (value == null) return const Success(null);
      if (value is! String) {
        return const FailureResult(Failure(FailureType.invalidData));
      }
      return Success(LessonNoteEntity(lessonId: id, text: value));
    } catch (_) {
      return const FailureResult(Failure(FailureType.storage));
    }
  }

  @override
  Future<Result<void>> saveNote(LessonNoteEntity note) async {
    if (note.text.isEmpty) return deleteNote(note.lessonId);
    try {
      await box.put('notes/${note.lessonId}', note.text);
      await box.flush();
      return const Success(null);
    } catch (_) {
      return const FailureResult(Failure(FailureType.storage));
    }
  }

  @override
  Future<Result<void>> deleteNote(String id) async {
    try {
      await box.delete('notes/$id');
      await box.flush();
      return const Success(null);
    } catch (_) {
      return const FailureResult(Failure(FailureType.storage));
    }
  }
}
