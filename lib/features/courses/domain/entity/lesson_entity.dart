class LessonEntity {
  const LessonEntity({
    required this.id,
    required this.title,
    required this.videoAsset,
    required this.duration,
  });
  final String id, title, videoAsset;
  final Duration duration;
}
