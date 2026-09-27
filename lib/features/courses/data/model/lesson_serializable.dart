import 'package:thaheen_task/features/courses/data/model/json_fields.dart';

class LessonSerializable {
  const LessonSerializable({
    required this.id,
    required this.title,
    required this.video,
    required this.durationSec,
  });

  factory LessonSerializable.fromJson(Map<String, dynamic> json) =>
      LessonSerializable(
        id: json.requireString('id'),
        title: json.requireString('title'),
        video: json.requireString('video'),
        durationSec: json.requirePositiveInt('durationSec'),
      );

  final String id, title, video;
  final int durationSec;
}
