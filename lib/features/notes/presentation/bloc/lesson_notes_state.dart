import 'package:thaheen_task/core/domain/errors/failures.dart';

class LessonNotesState {
  const LessonNotesState({
    this.lessonId = '',
    this.savedText = '',
    this.draftText = '',
    this.loading = false,
    this.loaded = false,
    this.saving = false,
    this.failure,
    this.saved = false,
  });
  final String lessonId, savedText, draftText;
  final bool loading, loaded, saving, saved;
  final Failure? failure;
  bool get dirty => savedText != draftText;

  @override
  String toString() =>
      // Lengths only: note text is user content and stays out of logs.
      'LessonNotesState(lessonId: $lessonId, '
      'savedText: ${savedText.length} chars, '
      'draftText: ${draftText.length} chars, dirty: $dirty, saved: $saved, '
      'loading: $loading, loaded: $loaded, saving: $saving, failure: $failure)';
}
