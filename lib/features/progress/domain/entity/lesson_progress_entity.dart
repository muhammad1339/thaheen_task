class LessonProgressEntity {
  const LessonProgressEntity({
    required this.lessonId,
    this.position = Duration.zero,
    this.isCompleted = false,
  });
  final String lessonId;
  final Duration position;
  final bool isCompleted;
}
