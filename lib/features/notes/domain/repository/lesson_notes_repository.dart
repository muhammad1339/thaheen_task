import 'package:thaheen_task/core/domain/errors/result.dart';
import 'package:thaheen_task/features/notes/domain/entity/lesson_note_entity.dart';

abstract interface class LessonNotesRepository {
  Future<Result<LessonNoteEntity?>> getNote(String lessonId);
  Future<Result<void>> saveNote(LessonNoteEntity note);
  Future<Result<void>> deleteNote(String lessonId);
}
